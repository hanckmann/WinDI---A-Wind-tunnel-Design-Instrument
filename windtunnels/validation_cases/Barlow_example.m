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
% Date:     June 20, 2012
% Version:  1
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
wind_tunnel.crosssection_test_section = 2.3226;
wind_tunnel.velocity_test_section     = 44.7;

%% Build the parts struct
% part numbers must be following!!
% - Edit the following information:
% - change name(first purple part), do NOT change part type (second in
% purple!)
% - width&hight in and width&hight out
% addition info is edited at last

parts = [];
parts = add_part(wind_tunnel, parts, 'Straight part TS'  , 'straight_part'    , 1.524, 1.524, 1.524, 1.524,       'length', 1.524);
parts = add_part(wind_tunnel, parts, 'Diffuser'          , 'diffuser'         , 1.524, 1.524, 2, 2,               'cross_section_shape', 'circle','length_center_line', 3.444, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Corner small'      , 'corner'           ,  2, 2, 2, 2,                      'chord', 1.8);
parts = add_part(wind_tunnel, parts, 'Straight part'     , 'straight_part'    , 2, 2, 2, 2,                       'length', 1.585);
parts = add_part(wind_tunnel, parts, 'Corner small'      , 'corner'           ,  2, 2, 2, 2,                      'chord', 1.8);
parts = add_part(wind_tunnel, parts, 'Straight part'     , 'straight_part'    , 2, 2, 2, 2,                       'length', 1.219);
parts = add_part(wind_tunnel, parts, 'Large diffuser'    , 'diffuser'         , 2, 2, 3.048, 3.048,               'cross_section_shape', 'circle', 'length_center_line', 7.4, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Corner large'      , 'corner'           , 3.048, 3.048,3.048, 3.048,        'chord', 2.5);
parts = add_part(wind_tunnel, parts, 'Corner large'      , 'corner'           , 3.048, 3.048,3.048, 3.048,        'chord', 2.5);
parts = add_part(wind_tunnel, parts, 'Straight part'     , 'straight_part'    , 3.048, 3.048,3.048, 3.048,        'length', 0.914);
%parts = add_part(wind_tunnel, parts, 'Honeycomb'         , 'honeycomb'        , .254, .254, .254, .254,           'cell_length', .03, 'cell_diameter', .0017, 'cell_wall_thickness', .0001, 'material_roughness', 7*10^-6);
parts = add_part(wind_tunnel, parts, 'Contraction'       , 'contraction'      , 3.048, 3.048, 1.524, 1.524,       'shape', 'curved', 'center_length', 2.577); % length = length along the center line
%parts = add_part(wind_tunnel, parts, 'Screen'            , 'screen'           , 2, 2.5, 2, 2.5,                   'wire_diameter', 0.0006, 'wire_roughness', 1.3, 'cell_diameter', 0.00253747);
%parts = add_part(wind_tunnel, parts, 'Safety net'        , 'safetynet'        , 2, 2.5, .5, .5);

% Number of parts
parts_count = length(parts);

%% Check parts
if settings.checks.do
    check_windtunnel(parts, settings);
end

%% Calculate the part loss coefficient
for i = 1:parts_count
    parts{i} = part_loss_coefficient(parts{i}, settings); %#ok<SAGROW>
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
