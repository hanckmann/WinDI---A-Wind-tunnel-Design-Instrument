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
wind_tunnel.crosssection_test_section = 11 % 11.33 - 10.54;
wind_tunnel.velocity_test_section     = 96.32;

%% Build the parts struct
% part numbers must be following!!
% - Edit the following information:
% - change name(first purple part), do NOT change part type (second in
% purple!)
% - width&hight in and width&hight out
% addition info is edited at last

parts = [];

parts = add_part(wind_tunnel, parts, 'Inlet',           'inlet'             , 6.1, 24.38, 6.1, 24.38);
parts = add_part(wind_tunnel, parts, 'Screen'         , 'screen'            , 6.1, 24.38, 6.1, 24.38,       'wire_diameter', 0.0005, 'wire_roughness', 1.5, 'cell_diameter', 0.007);
parts = add_part(wind_tunnel, parts, 'Screen'         , 'screen'            , 6.1, 24.38, 6.1, 24.38,       'wire_diameter', 0.0005, 'wire_roughness', 1.5, 'cell_diameter', 0.007);
parts = add_part(wind_tunnel, parts, 'Screen'         , 'screen'            , 6.1, 24.38, 6.1, 24.38,       'wire_diameter', 0.0005, 'wire_roughness', 1.5, 'cell_diameter', 0.007);
parts = add_part(wind_tunnel, parts, 'Screen'         , 'screen'            , 6.1, 24.38, 6.1, 24.38,       'wire_diameter', 0.0005, 'wire_roughness', 1.5, 'cell_diameter', 0.007);
parts = add_part(wind_tunnel, parts, 'Screen'         , 'screen'            , 6.1, 24.38, 6.1, 24.38,       'wire_diameter', 0.0005, 'wire_roughness', 1.5, 'cell_diameter', 0.007);
parts = add_part(wind_tunnel, parts, 'Contraction'    , 'contraction'       , 6.1, 24.38, 3.47, 5.99,       'shape', 'straight','center_length', 17.86 ); % length along the center line
parts = add_part(wind_tunnel, parts, 'Contraction'    , 'contraction'       , 3.47, 5.99, 2.82, 4.34,       'shape', 'curved', 'center_length', 5.49); % length along the center line
parts = add_part(wind_tunnel, parts, 'Test section'   , 'fetch'             , 2.82, 4.34, 2.95, 4.47,       'length', 6.1, 'height_testsection', 1.85); %here via pi*r^2 = crossection_ts
parts = add_part(wind_tunnel, parts, 'Diffuser'       , 'diffuser'          , 2.95, 4.47, 4.72, 9.8,        'cross_section_shape', 'circle', 'length_center_line', 36.85, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
%parts = add_part(wind_tunnel, parts, 'Diffuser'       , 'diffuser'          , 4.72, 5.41, 4.88, 4.88,       'cross_section_shape', 'circle', 'length_center_line', 3.05, 'length_wall', 0); % length along the center line
parts = add_part(wind_tunnel, parts, 'Contraction'    , 'contraction'       , 4.72, 5.41, 4.88, 4.88,       'shape', 'curved', 'center_length', 3.05); % length along the center line
parts = add_part(wind_tunnel, parts, 'Diffuser'       , 'diffuser'          , 4.88, 4.88, 5.26, 6.39,       'cross_section_shape', 'circle', 'length_center_line', 5.33, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
%parts = add_part(wind_tunnel, parts, 'Sudden expansion','sudden_expansion'  , 5.26, 6.39, 5.26, 11.51);
parts = add_part(wind_tunnel, parts, 'Corner large 3' , 'corner'            , 5.26, 11.51, 6.32, 11.58,     'loss_coefficient', 1,'chord',0.1);
parts = add_part(wind_tunnel, parts, 'Outlet',           'outlet'           , 6.32, 11.58, 6.32, 11.58);


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
