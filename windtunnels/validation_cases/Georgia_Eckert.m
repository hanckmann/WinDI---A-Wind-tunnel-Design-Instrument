% example_script
%
% Build the windtunnel by adding relevant parts and their
% information. 
% See comments in the file for more details.
% 
% Expected output:
%     wind_tunnel.crosssection_test_section     % input
%     wind_tunnel.velocity_test_section         % input
%     parts{i}                      % see below
%     total_pressure_drop           % calculated
%     total_loss_coefficient_ratio  % calculated
%     power_input                   % calculated
%     power_fan                     % calculated
%     efficiency_motor              % calculated
%     efficiency_fan                % calculated
%
% Output, the information for specific parts:
%     parts{i}                      % where i is the part number, input and system calculated
% The specific information per part depends on the part type. 
% See the (part specific) functions for their documentation.
%
% Date:     January 20, 2013
% Version:  1.5
% Contact:  rinkavdommelen@hotmail.com
% Authors:  Rinka van Dommelen
%           Patrick Hanckmann

clear all;

clear parts;
clear wind_tunnel;

%% Create settings
settings = make_settings();

%% Start script
print_info(['Windtunnel test script (' mfilename() ')'], settings);

%% Windtunnel specifications (input)
wind_tunnel.crosssection_test_section = 72.47;
wind_tunnel.velocity_test_section     = 52.27;

%% Build the parts struct
% part numbers must be following!!
% - Edit the following information:
% - change name(first purple part), do NOT change part type (second in
% purple!)
% - width&hight in and width&hight out
% addition info is edited at last

parts = [];
parts = add_part(wind_tunnel, parts, 'Straight part'    , 'straight_part'                 , 15.7, 15.7, 15.7, 15.7,     'length', 6.1 );
parts = add_part(wind_tunnel, parts, 'Contractor'       , 'contraction'                   , 15.7, 15.7, 9.14, 7.92,     'shape', 'straight', 'center_length', 10.97); % length along the center line
parts = add_part(wind_tunnel, parts, 'Test section'     , 'fetch'                         , 9.14, 7.92, 9.14, 8.12,     'length', 19.2 , 'height_testsection', 7.92 );
parts = add_part(wind_tunnel, parts, 'Contractor'       , 'contraction'                   , 9.14, 8.12, 4.95, 7.09,     'shape', 'straight', 'center_length', 7.01); % length along the center line
parts = add_part(wind_tunnel, parts, 'Diffuser'         , 'diffuser'                      , 4.95, 7.09, 4.95, 7.21,     'cross_section_shape', 'rectangle', 'length_center_line', 13.11 , 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Diffuser'         , 'diffuser'                      , 4.95, 7.21, 8.69, 8.69,     'cross_section_shape', 'rectangle', 'length_center_line', 29.79 , 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Corner small 1'   , 'corner_downstream_testsection' , 8.69, 8.69, 8.69, 8.69,     'chord', 1.067);
parts = add_part(wind_tunnel, parts, 'Diffuser'         , 'diffuser'                      , 8.69, 8.69, 9.75, 9.75,     'cross_section_shape', 'rectangle', 'length_center_line', 10.59 , 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Corner small 2'   , 'corner_downstream_testsection' , 9.75, 9.75, 9.75, 9.75,     'chord', 1.067);

parts = add_part(wind_tunnel, parts, 'Screen'          , 'screen'                         , 9.75, 9.75, 9.75, 9.75,     'wire_diameter', 0.003 , 'wire_roughness', 1.3 , 'cell_diameter', 0.06);
parts = add_part(wind_tunnel, parts, 'Diffuser'        , 'diffuser'                       , 9.75, 9.75, 11.58, 11.58,   'cross_section_shape', 'rectangle', 'length_center_line', 3.83 , 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'diffuser'        , 'diffuser'                       , 11.58, 11.58, 11.89, 11.89, 'cross_section_shape', 'rectangle', 'length_center_line', 7.83 , 'length_wall', 0);
parts = add_part(wind_tunnel, parts, 'Straight part'   , 'straight_part'                  , 11.89, 11.89, 11.89, 11.89, 'length', 12.65 );
parts = add_part(wind_tunnel, parts, 'Diffuser'        , 'diffuser'                       , 11.89, 11.89, 15.7, 15.7,   'cross_section_shape', 'rectangle', 'length_center_line', 55.17 , 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Corner large 3'  , 'corner'                         , 15.7, 15.7, 15.7, 15.7,     'chord', 1.829);
parts = add_part(wind_tunnel, parts, 'Straight part'   , 'straight_part'                  , 15.7, 15.7, 15.7, 15.7,     'length', 3.35 );
parts = add_part(wind_tunnel, parts, 'Corner large 4'  , 'corner'                         , 15.7, 15.7, 15.7, 15.7,     'chord',1.829 );
parts = add_part(wind_tunnel, parts, 'Screen'          , 'screen'                         , 15.7, 15.7, 15.7, 15.7,     'wire_diameter', 0.0015 , 'wire_roughness', 1.3 , 'cell_diameter', 0.00283 );


% Number of parts
parts_count = length(parts);

%% Check parts
if settings.checks.do
    check_windtunnel(parts, settings);
end

%% Calculate the part loss coefficient
for i = 1:parts_count
    parts{i} = part_loss_coefficient(parts{i}, settings);
end

%% Calculate the part|total pressure drop
total_pressure_drop = 0;
for i = 1:parts_count
    parts{i} = part_pressure_drop(parts{i}, settings);
    total_pressure_drop = total_pressure_drop + parts{i}.pressure_drop;
end

%% Calculate the part|total loss coefficient ratio (and percentage)
total_loss_coefficient_ratio = 0;
for i = 1:parts_count
    parts{i} = part_loss_coefficient_ratio(parts{i}, settings);
    total_loss_coefficient_ratio = total_loss_coefficient_ratio + parts{i}.loss_coefficient_ratio;
end

% Calculate the part loss percentage
for i = 1:parts_count
    parts{i}.loss_percentage = 100 / total_loss_coefficient_ratio * parts{i}.loss_coefficient_ratio;
end

%% Set the efficiency values (input)
wind_tunnel.efficiency_fan      = 0.8;
wind_tunnel.efficiency_motor    = 0.8;

%% Calculate the total power input
wind_tunnel.reserve_factor = settings.total_power_input.reserve_factor;
wind_tunnel.power_input = wind_tunnel.reserve_factor * total_pressure_drop * wind_tunnel.crosssection_test_section * wind_tunnel.velocity_test_section;

%% Calculate the fan power
wind_tunnel.power_fan = wind_tunnel.power_input / (wind_tunnel.efficiency_fan * wind_tunnel.efficiency_motor);

%% Clear useless information
clear i;
clear parts_count;
clear total_loss_coefficient_ratio total_pressure_drop;

%% Pretty printing
pretty_print(parts, wind_tunnel)
