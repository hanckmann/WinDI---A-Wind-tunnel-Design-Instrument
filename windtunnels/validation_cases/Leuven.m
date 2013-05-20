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
wind_tunnel.crosssection_test_section = 0.36;
wind_tunnel.velocity_test_section     = 16;

%% Build the parts struct
% part numbers must be following!!
% - Edit the following information:
% - change name(first purple part), do NOT change part type (second in
% purple!)
% - width&hight in and width&hight out
% addition info is edited at last

parts = [];

parts = add_part(wind_tunnel, parts, 'Inlet'                 ,'inlet'            , 0.73, .73, .73, .73);
parts = add_part(wind_tunnel, parts, 'Screen inlet fan'      ,'screen'           ,  0.73, .73, .73, .73,    'wire_diameter', 0.002, 'wire_roughness', 1, 'cell_diameter', 0.06);
parts = add_part(wind_tunnel, parts, 'Straight part'         ,'straight_part'    ,  0.73, .73, .73, .73   , 'length', 0.15);
parts = add_part(wind_tunnel, parts, 'contraction'           , 'contraction'     ,  .73, .73, 0.51, .51  ,  'shape' ,'straight', 'center_length', 0.1); % length = length along the center line

%flexible part, induces vortices. to insert these vortices in the 
%calculationa a screen with rough wire is added
parts = add_part(wind_tunnel, parts, 'flexible aka screen'   ,'screen'           , 0.9, .47, .9, .47     ,'wire_diameter', 0.01, 'wire_roughness', 1.8, 'cell_diameter', 0.1);
parts = add_part(wind_tunnel, parts, 'Straight part'         ,'straight_part'    , 0.9, .47, .9, .47     , 'length', 1.3);
%parts = add_part(wind_tunnel, parts, 'Rectangular diffuser' ,'diffuser'         , 0.9, .47, 1.05, 1.01  , 'cross_section_shape', 'rectangle', 'length_center_line', 0, 'length_wall', 1.0); % Only fill in length_center_line OR length_wall, but NOT both!
% diffuser larger than 10 degrees therefore BLC (1screen) is likely
parts = add_part(wind_tunnel, parts, 'Diffuser_BLC'          ,'diffuser_with_boundary_layer_control', 0.9, .47, 1.05, 1.01, 'length_center_line', 0, 'length_wall', 1); % Only fill in length_center_line OR length_wall, but NOT both!
parts = add_part(wind_tunnel, parts, 'Screen'                ,'screen'           , 0.9, .47, 1.05, 1.01,  'wire_diameter', 0.0005, 'wire_roughness', 1.5, 'cell_diameter', 0.0015);

parts = add_part(wind_tunnel, parts, 'Honeycomb'             ,'honeycomb'        , 1.05, 1.01, 1.05, 1.01, 'cell_length', .11, 'cell_diameter', .007, 'cell_wall_thickness', .002, 'material_roughness', 0.0002);
parts = add_part(wind_tunnel, parts, 'Screen'                ,'screen'           , 1.05, 1.01, 1.05, 1.01, 'wire_diameter', 0.0005, 'wire_roughness', 1.5, 'cell_diameter', 0.0015);
parts = add_part(wind_tunnel, parts, 'Screen'                ,'screen'           , 1.05, 1.01, 1.05, 1.01, 'wire_diameter', 0.0005, 'wire_roughness', 1.5, 'cell_diameter', 0.0011);
parts = add_part(wind_tunnel, parts, 'Curved contraction'     ,'contraction'      , 1.05, 1.01, .45, .50  , 'shape','curved', 'center_length', 1.25); % length = length along the center line
%parts = add_part(wind_tunnel, parts, 'Sudden expansion'      ,'sudden_expansion' , .45, .50, .65, .50    );
parts = add_part(wind_tunnel, parts, 'Fetch'                 ,'fetch'            , .45, .50, .7 , .50   , 'length', 5.2, 'height_testsection', 0.65);
parts = add_part(wind_tunnel, parts, 'Straight part'         ,'straight_part'    , .72, .5, .72, .5      , 'length', 1.35);
%parts = add_part(wind_tunnel, parts, 'Rectangular diffuser'  ,'diffuser'         , .7, .50, .72, .50    , 'cross_section_shape', 'rectangle', 'length_center_line', 1.35, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!72
parts = add_part(wind_tunnel, parts, 'Outlet'                ,'outlet'           , .72, .50, .72, .50 );

%parts = add_part(wind_tunnel, parts, 'Straight contraction'  ,'straight_contraction'                , 1.4, 1.7, .80, 1.0, 'length', 1.5); % length = length along the center line
%parts = add_part(wind_tunnel, parts, 'Curved contractor'     ,'curved_contraction'                  , .92, .60, .76, .76, 'length', 1.5); % length = length along the center line
%parts = add_part(wind_tunnel, parts, 'Circular diffuser'     ,'diffuser'                            , .76, .76, .98, .93, 'cross_section_shape', 'circle', 'length_center_line', 0, 'length_wall', 2.5); % Only fill in length_center_line OR length_wall, but NOT both!
%parts = add_part(wind_tunnel, parts, 'Diffuser_BLC'          ,'diffuser_with_boundary_layer_control', .76, .76, .98, .93, 'length_center_line', 0, 'length_wall', 2.5); % Only fill in length_center_line OR length_wall, but NOT both!
%parts = add_part(wind_tunnel, parts, 'Safety net'            ,'safetynet'                           , 2.0, 2.5, 2.0, 2.5);


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
