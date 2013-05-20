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
wind_tunnel.crosssection_test_section = 6.5;
wind_tunnel.velocity_test_section     = 133;

%% Build the parts struct
% part numbers must be following!!
% - Edit the following information:
% - change name(first purple part), do NOT change part type (second in
% purple!)
% - width&hight in and width&hight out
% addition info is edited at last

parts = [];
parts = add_part(wind_tunnel, parts, 'Straight part'     , 'straight_part' , 9.14, 10.06, 9.14, 10.06, 'length', 6.1);
parts = add_part(wind_tunnel, parts, 'Contraction'       , 'contraction'   , 9.14, 10.06, 2.13, 3.05,  'shape','curved','center_length', 13.11); % length along the center line
parts = add_part(wind_tunnel, parts, 'Test section'      , 'fetch'         , 3.05, 2.13, 3.09, 2.13,   'length', 4.57, 'height_testsection', 3.05);
%parts = add_part(wind_tunnel, parts, 'Safetynet'        , 'safetynet'     , 2.13, 3.09, 2.15, 3.15);
parts = add_part(wind_tunnel, parts, 'Screen downstr ts' , 'screen'        ,  2.13, 3.09, 2.15, 3.15,  'wire_diameter', 0.0001, 'wire_roughness', 1.2, 'cell_diameter', 0.1);
parts = add_part(wind_tunnel, parts, 'Diffuser'          , 'diffuser'      ,  2.13, 3.09, 2.15, 3.15,  'cross_section_shape', 'rectangle', 'length_center_line', 0.34, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!

%parts = add_part(wind_tunnel, parts, 'contraction'        , 'contraction'      , 2.13, 3.09, 2.15, 3.11,  'shape', 'straight', 'center_length', 0.34);
%parts = add_part(wind_tunnel, parts, 'Honeycomb'         , 'honeycomb'     , 2.13, 3.09, 2.15, 3.11,  'cell_length', 0.34, 'cell_diameter', .02, 'cell_wall_thickness', .0005064, 'material_roughness', 0.00001);
parts = add_part(wind_tunnel, parts, 'Diffuser'          , 'diffuser'      , 2.15, 3.11, 4.84, 5.75,   'cross_section_shape', 'rectangle', 'length_center_line', 28.96, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Small corner 1'    , 'corner'        , 4.84, 5.75, 4.84, 5.75,   'chord', .3048);
parts = add_part(wind_tunnel, parts, 'Diffuser'          , 'diffuser'      , 4.84, 5.75, 5.68, 6.6,    'cross_section_shape', 'rectangle', 'length_center_line', 9.14, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Small corner 2'    , 'corner'        , 5.68, 6.6, 5.68, 6.6,     'chord', .3048);

parts = add_part(wind_tunnel, parts, 'Diffuser'          , 'diffuser'      , 5.68, 6.6, 7.72, 7.72,    'cross_section_shape', 'circle', 'length_center_line', 17.16, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
%parts = add_part(wind_tunnel, parts, 'Contractor'        , 'contraction'   , 8.71, 8.71, 8.87, 8.87,   'shape', 'curved', 'center_length', 1.51); % length along the center line
%parts = add_part(wind_tunnel, parts, 'Safety net'        , 'safetynet'     , 8.87, 8.87, 8.87, 8.87);  % No additional arguments, always gives a loss coefficient of 0.2
parts = add_part(wind_tunnel, parts, 'Diffuser'          , 'diffuser'      , 7.72, 7.72, 9.14, 10.06,  'cross_section_shape', 'circle', 'length_center_line', 18.14, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Contractor'        , 'contraction'   , 9.14, 10.06, 8.19, 9.11,  'shape', 'curved','center_length', 5.33); % length along the center line
parts = add_part(wind_tunnel, parts, 'Diffuser'          , 'diffuser'      , 8.19, 9.11, 8.52, 9.43,   'cross_section_shape', 'rectangle', 'length_center_line', 3.05, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Diffuser'          , 'diffuser'      , 8.52, 9.43, 9.14, 10.06,  'cross_section_shape', 'rectangle', 'length_center_line', 5.33, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Straight part'     , 'straight_part' , 9.14, 10.06, 9.14, 10.06, 'length', 1.52);
parts = add_part(wind_tunnel, parts, 'Large corner 3'    , 'corner'        , 9.14, 10.06, 9.14, 10.06, 'chord', .3048 );
parts = add_part(wind_tunnel, parts, 'Straight part'     , 'straight_part' , 9.14, 10.06, 9.14, 10.06, 'length', 5.38 );
parts = add_part(wind_tunnel, parts, 'Large corner 4'    , 'corner'        , 9.14, 10.06, 9.14, 10.06, 'chord', .1524 );

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
