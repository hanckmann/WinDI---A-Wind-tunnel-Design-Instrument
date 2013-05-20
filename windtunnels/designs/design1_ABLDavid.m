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
wind_tunnel.crosssection_test_section = .42;
wind_tunnel.velocity_test_section     = 12.5;

%% Build the parts struct
% - change name(first purple part), do NOT change part type (second in
% purple!)
% - width&hight in and width&hight out
% addition info is edited at last

parts = [];

A_range = 5;

L_range = 3;

%-->>>> MENTAL NOTE: THE SUBPLOTS MUST BE THE FIRST TO START THE LOOP!!!!
for A = A_range
    for L = L_range
        
        
        parts = [];
        parts = add_part(wind_tunnel, parts, 'Test section'          , 'fetch'                         , .66, .6, .7, .6,                  'length', 4.8, 'height_testsection', 0.6);
        parts = add_part(wind_tunnel, parts, 'Corner small 1'        , 'corner_downstream_testsection' , .6, .7, .6, .85,                  'chord', .42);
        parts = add_part(wind_tunnel, parts, 'Diffuser corner 1'     , 'diffuser'                      , .6, .7, .6, .85,                  'cross_section_shape', 'rectangle', 'length_center_line', 1, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
        parts = add_part(wind_tunnel, parts, 'Straight part'         , 'straight_part'                 , .6, .85, .6, .85,                  'length', .88);
        parts = add_part(wind_tunnel, parts, 'Corner small 2'        , 'corner_downstream_testsection' , .6, .85, .6, .92,                  'chord', .42);
        parts = add_part(wind_tunnel, parts, 'Diffuser corner 2'     , 'diffuser'                      , .6, .85, .6, .92,                  'cross_section_shape', 'rectangle', 'length_center_line', 1, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
        parts = add_part(wind_tunnel, parts, 'Safety net'            , 'safetynet'                     , .6, .92, .6, .92);                 % No additional arguments, always gives a loss coefficient of 0.2
        parts = add_part(wind_tunnel, parts, 'diffuser before fan'   , 'diffuser'                      , .6, .92, .76, .76,                 'cross_section_shape', 'circle', 'length_center_line', 0.635, 'length_wall', 0);
        %fan
        parts = add_part(wind_tunnel, parts, 'Diffuser small angle'  , 'diffuser'                      , .76, .76, .98, .93,                'cross_section_shape', 'rectangle', 'length_center_line', 0, 'length_wall', 2.5); % Only fill in length_center_line OR length_wall, but NOT both!
        parts = add_part(wind_tunnel, parts, 'Diffuser small angle2', 'diffuser'                       , .98, .93, 1.2, 1.1,                'cross_section_shape', 'rectangle','length_center_line', 0, 'length_wall', 2.7); % Only fill in length_center_line OR length_wall, but NOT both!
        parts = add_part(wind_tunnel, parts, 'Straight part'        , 'straight_part'                  , 1.2 , 1.1, 1.2, 1.1,               'length', L);
        %parts = add_part(wind_tunnel, parts, 'Honeycomb'            , 'honeycomb'                      , 1.2, 1.1, 1.2, 1.1,               'cell_length', .3, 'cell_diameter', .03, 'cell_wall_thickness', .006, 'material_roughness', 8*10^-5);
        parts = add_part(wind_tunnel, parts, 'Corner large 3'       , 'corner'                         , 1.2, 1.1, 1.2, 1.3,                'chord', .42);
        parts = add_part(wind_tunnel, parts, 'Diffuser corner 3'    , 'diffuser'                       , 1.2, 1.1, 1.2, 1.3,                'cross_section_shape', 'rectangle', 'length_center_line', 1.5, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
        parts = add_part(wind_tunnel, parts, 'Corner large 4'       , 'corner'                         , 1.2, 1.3, 1.2, 1.5,                'chord', .42);
        parts = add_part(wind_tunnel, parts, 'Diffuser corner 4'    , 'diffuser'                       , 1.2, 1.3, 1.2, 1.5,                'cross_section_shape', 'rectangle', 'length_center_line', 1.5, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
        parts = add_part(wind_tunnel, parts, 'Diffuser'             , 'diffuser'                       , 1.2, 1.5, sqrt(A), sqrt(A),        'cross_section_shape', 'rectangle', 'length_center_line', L , 'length_wall', 0);
        
        % if the angle of the diffuser is larger than 10 degrees, it will
        % remove the last part (can be changed) and add a Diffuser_BLC and 2 screens
        last_part_number = length(parts);
        tmp_part = parts{last_part_number};
        if (strcmp(parts{last_part_number}.type, 'diffuser'))
            tmp_part.radius_in      = sqrt((tmp_part.width_in  * tmp_part.height_in) / pi);
            tmp_part.radius_out     = sqrt((tmp_part.width_out * tmp_part.height_out) / pi);
            [tmp_part.angle_radian tmp_part.length_center_line] = wall_central_line_angle(tmp_part.radius_in, tmp_part.radius_out, tmp_part.length_wall, tmp_part.length_center_line);
            tmp_part.angle_degrees = radian2degrees(tmp_part.angle_radian);
            if(isfield(tmp_part, 'angle_degrees'))
                if (tmp_part.angle_degrees > 10)
                    parts = remove_part(parts, last_part_number); % Remove old diffuser, and add the new stuff
                    parts = add_part(wind_tunnel, parts, 'Diffuser_BLC' , 'diffuser_with_boundary_layer_control',1.2, 1.5, sqrt(A), sqrt(A),'length_center_line', L, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
                    parts = add_part(wind_tunnel, parts, 'BLC Screen 2' , 'screen'                     , sqrt((1.2+A)/2), sqrt((1.5+A)/2), sqrt((1.2+A)/2), sqrt((1.5+A)/2),   'wire_diameter', 0.001, 'wire_roughness', 1.3, 'cell_diameter', 0.01);
               end
            end
        end
        clear last_part_number tmp_part;
        
        parts = add_part(wind_tunnel, parts, 'Straight part honey'  , 'straight_part'                  , sqrt(A), sqrt(A), sqrt(A), sqrt(A),'length', .4);
        parts = add_part(wind_tunnel, parts, 'Screen 1'             , 'screen'                         , sqrt(A), sqrt(A), sqrt(A), sqrt(A),'wire_diameter', 0.0005, 'wire_roughness', 1.3, 'cell_diameter', 0.0015);
        parts = add_part(wind_tunnel, parts, 'Screen 2'             , 'screen'                         , sqrt(A), sqrt(A), sqrt(A), sqrt(A),'wire_diameter', 0.0007,  'wire_roughness', 1.3, 'cell_diameter', 0.003);
        parts = add_part(wind_tunnel, parts, 'Honeycomb'            , 'honeycomb'                       , sqrt(A), sqrt(A), sqrt(A), sqrt(A),'cell_length', 8*(sqrt(A)/150), 'cell_diameter', (sqrt(A)/150), 'cell_wall_thickness', .002, 'material_roughness', 8*10^-5);
        parts = add_part(wind_tunnel, parts, 'Contraction'          , 'contraction'                    , sqrt(A), sqrt(A), .71, .6,         'shape', 'straight', 'center_length', 1.5);
    end
end

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


%% search part information via
% parts{x}