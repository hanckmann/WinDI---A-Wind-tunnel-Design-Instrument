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
wind_tunnel.crosssection_test_section = .2;
wind_tunnel.velocity_test_section     = 15;

%% Build the parts struct
% part numbers must be following!!
% - Edit the following information:
% - change name(first purple part), do NOT change part type (second in
% purple!)
% - width&hight in and width&hight out
% addition info is edited at last

parts = [];

parts = add_part(wind_tunnel, parts, 'Diffuser small angle'  , 'diffuser'                      ,     .67, .67, 1.2, 1.1,   'cross_section_shape', 'rectangle', 'length_center_line', 0, 'length_wall', 5.2); % Only fill in length_center_line OR length_wall, but NOT both!
%parts = add_part(wind_tunnel, parts, 'Diffuser small angle2' , 'diffuser'                      ,     .98, .93, 1.2, 1.1,   'cross_section_shape', 'rectangle', 'length_center_line', 0, 'length_wall', 2.7); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Straight part'         , 'straight_part'                 ,     1.2 , 1.1, 1.2, 1.1,  'length', .225);
parts = add_part(wind_tunnel, parts, 'Honeycomb'             , 'honeycomb'                     ,     1.2, 1.1, 1.2, 1.1,   'cell_length', .33, 'cell_diameter', .03, 'cell_wall_thickness', .006, 'material_roughness', 8*10^-5);
parts = add_part(wind_tunnel, parts, 'Corner large 3'        , 'corner'                        ,     1.2, 1.1, 1.2, 1.3,   'chord', .42);
parts = add_part(wind_tunnel, parts, 'Diffuser corner 3'     , 'diffuser'                      ,     1.2, 1.1, 1.2, 1.3,   'cross_section_shape', 'rectangle', 'length_center_line', 1.5, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Corner large 4'        , 'corner'                        ,     1.2, 1.3, 1.2, 1.5,   'chord', .42);
parts = add_part(wind_tunnel, parts, 'Diffuser corner 4'     , 'diffuser'                      ,     1.2, 1.3, 1.2, 1.5,   'cross_section_shape', 'rectangle','length_center_line', 1.5, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'BLC Screen 1'          , 'screen'                        ,     1.2, 1.3, 1.2, 1.5,   'wire_diameter', 0.00048, 'wire_roughness', 1.5, 'cell_diameter', 0.0010);
parts = add_part(wind_tunnel, parts, 'BLC Screen 2'          , 'screen'                        ,     1.5, 1.7, 1.5, 1.8,   'wire_diameter', 0.00048, 'wire_roughness', 1.5, 'cell_diameter', 0.0010);
parts = add_part(wind_tunnel, parts, 'BLC Screen 3'          , 'screen'                        ,     1.8, 2, 1.7, 2.1,     'wire_diameter', 0.00048, 'wire_roughness', 1.5, 'cell_diameter', 0.0010);
parts = add_part(wind_tunnel, parts, 'Diffuser wide angle'   , 'diffuser_with_boundary_layer_control' , 1.2, 1.5, 2, 2.5,  'length_center_line', .95, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Straight part honey'   , 'straight_part'                 ,     2, 2.5, 2, 2.5,       'length', .455);
parts = add_part(wind_tunnel, parts, 'Honeycomb'             , 'honeycomb'                     ,     2, 2.5, 2, 2.5,       'cell_length', .33, 'cell_diameter', .013, 'cell_wall_thickness', .0047, 'material_roughness', 8*10^-5);
parts = add_part(wind_tunnel, parts, 'Screen 1'              , 'screen'                        ,     2, 2.5, 2, 2.5,       'wire_diameter', 0.00048, 'wire_roughness', 1.5, 'cell_diameter', 0.0010);
parts = add_part(wind_tunnel, parts, 'Screen 2'              , 'screen'                        ,     2, 2.5, 2, 2.5,       'wire_diameter', 0.00048, 'wire_roughness', 1.5, 'cell_diameter', 0.0010);
parts = add_part(wind_tunnel, parts, 'Screen 3'              , 'screen'                        ,     2, 2.5, 2, 2.5,       'wire_diameter', 0.00048, 'wire_roughness', 1.5, 'cell_diameter', 0.0010);
parts = add_part(wind_tunnel, parts, 'Straight contraction'  , 'contraction'                   ,     2, 2.5, .4, .5,       'shape', 'straight', 'center_length', 2.2); % length = length along the center line
%parts = add_part(wind_tunnel, parts, 'straight test section' , 'straight_part'                 ,     .45, .4, .5, .4,       'length', 2.45);
parts = add_part(wind_tunnel, parts, 'Test section'          , 'fetch'                         ,     .45, .4, .5, .4,      'length', 2.45, 'height_testsection', 0.5);
parts = add_part(wind_tunnel, parts, 'Diffuser'              , 'diffuser'                      ,     .5, .5, .6, .75,      'cross_section_shape', 'rectangle','length_center_line', 1.85, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Corner small 1'        , 'corner_downstream_testsection' ,     .6, .75, .6, .85,     'chord', .42);
parts = add_part(wind_tunnel, parts, 'Diffuser corner 1'     , 'diffuser'                      ,     .6, .75, .6, .85,     'cross_section_shape', 'rectangle', 'length_center_line', 1, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Straight part'         , 'straight_part'                 ,     .6, .85, .6, .85,     'length', .88);
parts = add_part(wind_tunnel, parts, 'Corner small 2'        , 'corner'                        ,     .6, .85, .6, .92,     'chord', .42);
parts = add_part(wind_tunnel, parts, 'Diffuser corner 2'     , 'diffuser'                      ,     .6, .85, .6, .92,     'cross_section_shape', 'rectangle', 'length_center_line', 1, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Safety net'            , 'safetynet'                     ,     .6, .92, .6, .92);  % No additional arguments, always gives a loss coefficient of 0.2
parts = add_part(wind_tunnel, parts, 'Contractor'            , 'contraction'                   ,     .6, .92, .67, .67,     'shape', 'straight', 'center_length', 0.635); % length along the center line

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
wind_tunnel.efficiency_motor    = 0.7;

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
