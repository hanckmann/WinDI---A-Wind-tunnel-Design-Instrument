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
% Version:  2.5
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
wind_tunnel.crosssection_test_section = 3;
wind_tunnel.velocity_test_section     = 25;

%% Build the parts struct
% part numbers must be following!!
% - Edit the following information:
% - change name(first purple part), do NOT change part type (second in
% purple!)
% - width&hight in and width&hight out
% addition info is edited at last


parts = [];

%parts = add_part(wind_tunnel, parts, 'Diffusing transition', 'diffuser'                     , wind_tunnel.crosssection_test_section, wind_tunnel.velocity_test_section,     1.8, 1.8, 1.8, 1.8,      'length_center_line', 0.34, 'length_wall', 0); % Only fill in length_center_line OR length_wall, NOT both!
parts = add_part(wind_tunnel, parts, 'Diffuser transition' , 'diffuser'                     ,     1.595, 1.595, 1.8, 1.8,  'cross_section_shape', 'circle', 'length_center_line', 1.8 , 'length_wall', 0); % Only fill in length_center_line OR length_wall, NOT both!
parts = add_part(wind_tunnel, parts, 'Diffuser'            , 'diffuser'                     ,     1.8, 1.8, 2.2, 2.85,     'cross_section_shape', 'rectangle', 'length_center_line', 11.8 , 'length_wall', 0); % Only fill in length_center_line OR length_wall, NOT both!
%parts = add_part(wind_tunnel, parts, 'outlet'             , 'outlet'                       ,     2.2, 2.85, 2.2, 2.85);
parts = add_part(wind_tunnel, parts, 'corner A large'      , 'corner'                       ,     2.2, 2.85, 2.2, 2.85,    'chord', .440);
parts = add_part(wind_tunnel, parts, 'Straight part'       , 'straight_part'                ,     2.2, 2.85, 2.2, 2.85,    'length', .9);
%parts = add_part(wind_tunnel, parts, 'inlet'              , 'inlet'                        ,     2.2, 2.85, 2.2, 2.85); 
parts = add_part(wind_tunnel, parts, 'corner B large'      , 'corner'                       ,     2.2, 2.85, 2.2, 2.85,    'chord', .440);
parts = add_part(wind_tunnel, parts, 'Straight part'       , 'straight_part'                ,     2.2, 2.85, 2.2, 2.85,    'length', .8);
parts = add_part(wind_tunnel, parts, 'Screen BLC 1'        , 'screen'                       ,     2.2, 2.85, 2.2, 2.85,    'wire_diameter', 0.001, 'wire_roughness', 1.3, 'cell_diameter', 0.005);
parts = add_part(wind_tunnel, parts, 'Diffuser_BLC'        , 'diffuser_with_boundary_layer_control',  2.2, 2.85, 3.8, 3.8,  'length_center_line', 2.5, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
%parts = add_part(wind_tunnel, parts, 'Diffuser 1a'        , 'diffuser'                     ,     2.2, 2.85, 3, 3.325,     'cross_section_shape', 'rectangle', 'length_center_line', 1.25, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Screen BLC 2'        , 'screen'                       ,     3, 3.325, 3, 3.325,      'wire_diameter', 0.001, 'wire_roughness', 1.3, 'cell_diameter', 0.005);
%parts = add_part(wind_tunnel, parts, 'Diffuser 1b'        , 'diffuser'                     ,     3, 3.325, 3.8, 3.8,      'cross_section_shape', 'rectangle', 'length_center_line', 1.25, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Screen 3'            , 'screen'                       ,     3.8, 3.8, 3.8, 3.8,      'wire_diameter', 0.001, 'wire_roughness', 1.3, 'cell_diameter', 0.005);% cell diameter is the mesh size, hoh!
parts = add_part(wind_tunnel, parts, 'Honeycomb'           , 'honeycomb'                    ,     3.8, 3.8, 3.8, 3.8,      'cell_length', 0.070, 'cell_diameter', .007, 'cell_wall_thickness', .0015, 'material_roughness', 0.00025);
parts = add_part(wind_tunnel, parts, 'Screen 4'            , 'screen'                       ,     3.8, 3.8, 3.8, 3.8,      'wire_diameter', 0.001, 'wire_roughness', 1.3, 'cell_diameter', 0.005);
parts = add_part(wind_tunnel, parts, 'Screen 5'            , 'screen'                       ,     3.8, 3.8, 3.8, 3.8,      'wire_diameter', 0.001, 'wire_roughness', 1.3, 'cell_diameter', 0.005);
parts = add_part(wind_tunnel, parts, 'Screen 6'            , 'screen'                       ,     3.8, 3.8, 3.8, 3.8,      'wire_diameter', 0.001, 'wire_roughness', 1.3, 'cell_diameter', 0.005);
parts = add_part(wind_tunnel, parts, 'Screen 7'            , 'screen'                       ,     3.8, 3.8, 3.8, 3.8,      'wire_diameter', 0.001, 'wire_roughness', 1.3, 'cell_diameter', 0.005);
parts = add_part(wind_tunnel, parts, 'Screen 8'            , 'screen'                       ,     3.8, 3.8, 3.8, 3.8,      'wire_diameter', 0.001, 'wire_roughness', 1.3, 'cell_diameter', 0.005);
parts = add_part(wind_tunnel, parts, 'Contraction'         , 'contraction'                  ,     3.8, 3.8, 1.9, 1.3,      'shape','straight','center_length', 3.8); % length along the center line
parts = add_part(wind_tunnel, parts, 'Test section'        , 'fetch'                        ,     1.3, 1.9, 1.6, 1.9,      'length', 10.4, 'height_testsection', 1.6);
parts = add_part(wind_tunnel, parts, '2d contraction'      , 'contraction'                  ,     1.9, 1.6, 1.9, 1.45,     'shape','straight','center_length', 1.1); % length along the center line
parts = add_part(wind_tunnel, parts, 'corner C small'      , 'corner_downstream_testsection',     1.9, 1.45, 1.9, 1.45,    'chord', .440);
parts = add_part(wind_tunnel, parts, 'Straight part'       , 'straight_part'                ,     1.9, 1.45, 1.9, 1.45,    'length', 1.2);
parts = add_part(wind_tunnel, parts, 'corner D small'      , 'corner_downstream_testsection',     1.9, 1.45, 1.9, 1.45,    'chord', .440);
parts = add_part(wind_tunnel, parts, 'contr transition'    , 'contraction'                  ,     1.9, 1.45, 1.595, 1.595, 'shape','straight','center_length', 11.8); 


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
