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
wind_tunnel.crosssection_test_section = 20.9;
wind_tunnel.velocity_test_section     = 45.72;

%% Build the parts struct
% part numbers must be following!!
% - Edit the following information:
% - change name(first purple part), do NOT change part type (second in
% purple!)
% - width&hight in and width&hight out
% addition info is edited at last

parts = [];
parts = add_part(wind_tunnel, parts, 'Screen'                , 'screen'        , 11.13, 39.32, 11.13, 39.32, 'wire_diameter', 0.0005, 'wire_roughness', 1.3, 'cell_diameter', 0.000704);
parts = add_part(wind_tunnel, parts, 'Contractor'            , 'contraction'   , 11.13, 39.32, 11.13, 12.19, 'shape', 'straight', 'center_length', 9.14); % length along the center line
parts = add_part(wind_tunnel, parts, 'Honeycomb'             , 'honeycomb'     , 11.13, 10.06, 11.13, 10.06, 'cell_length', 0.91, 'cell_diameter', 0.758,'cell_wall_thickness', 0.0067, 'material_roughness', 1);
parts = add_part(wind_tunnel, parts, 'Contractor'            , 'contraction'   , 11.13, 12.19, 4.57, 4.57,   'shape', 'straight', 'center_length', 9.14); % length along the center line
parts = add_part(wind_tunnel, parts, 'Straight part'         , 'straight_part' , 4.57, 4.57, 4.57, 4.57,     'length', 2.44);
parts = add_part(wind_tunnel, parts, 'Straight part'         , 'straight_part' , 4.57, 4.57, 4.57, 4.57,     'length', 7.31);
parts = add_part(wind_tunnel, parts, 'Straight part'         , 'straight_part' , 4.57, 4.57, 4.57, 4.57,     'length', 2.44);
parts = add_part(wind_tunnel, parts, 'Diffuser'              , 'diffuser'      , 4.57, 4.57, 5.16, 5.16,     'cross_section_shape', 'rectangle', 'length_center_line', 1.83, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Diffuser'              , 'diffuser'      , 5.16, 5.16, 7.54, 7.54,     'cross_section_shape', 'rectangle', 'length_center_line', 16.76, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!

parts = add_part(wind_tunnel, parts, 'Diffuser'             , 'diffuser'      , 7.54, 7.54, 8.78, 8.78,      'cross_section_shape', 'rectangle', 'length_center_line', 3.05, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Contractor'           , 'contraction'   , 3.31, 3.31, 3.05, 3.05,      'shape', 'straight', 'center_length', 0.46); % length along the center line
parts = add_part(wind_tunnel, parts, 'Straight part fan'    , 'straight_part' , 3.05, 3.05, 3.05, 3.05,      'length', 1.52);
%parts = add_part(wind_tunnel, parts, 'Sudden expansion??'   , 'diffuser'      , 2.89, 2.89, 8.78, 8.78,      'length_center_line', 0.001, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Straight part'        , 'straight_part' , 8.78, 8.78, 8.78, 8.78,      'length', 2.59 );
parts = add_part(wind_tunnel, parts, 'sudden exapnsion??'   , 'diffuser'      , 8.78, 8.78, 10.36, 14.02,    'cross_section_shape', 'rectangle', 'length_center_line',0.001 , 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Corner'               , 'corner'        , 10.36, 14.02, 10.36, 12.5,   'chord', 0.1, 'gap_hoh_in', 10, 'gap_hoh_out', 10);
parts = add_part(wind_tunnel, parts, 'Contractor'           , 'contraction'   , 10.36, 14.02, 10.36, 12.5,   'shape', 'straight', 'center_length', 9.75); % length along the center line
parts = add_part(wind_tunnel, parts, 'Diffuser'             , 'diffuser'      , 10.36, 12.50, 12.00, 40.0,   'cross_section_shape', 'rectangle', 'length_center_line', 0.001, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!

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
