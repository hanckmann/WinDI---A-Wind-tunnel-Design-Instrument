%%
% script example_script
%
% Provides an example on how to use the WinDI tool. Use this script as a starting
% point for your own wind tunnel description and calculations.
% Als see the example wind tunnels and optimisation scripts for more information
% and examples.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : LGPL
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

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

clear all;

clear parts;
clear wind_tunnel;

%% Create settings
settings = make_settings();

%% Start script
print_info(['Windtunnel test script (' mfilename() ')'], settings);

%% Windtunnel specifications (input)
wind_tunnel.efficiency_fan            = 0.8;
wind_tunnel.efficiency_motor          = 0.8;
wind_tunnel.crosssection_test_section = 3.96;
wind_tunnel.velocity_test_section     = 20;

%% Build the parts struct
% - change name(first purple part), do NOT change part type (second in
% purple!)
% - width&hight in and width&hight out
% addition info is edited at last
%
% Date:     June 20, 2012
% Version:  1
% Contact:  rinkavdommelen@hotmail.com
% Authors:  Rinka van Dommelen
%           Patrick Hanckmann
%
% parts = add_part(wind_tunnel, parts, 'part_name', 'straight_part' , height_in, width_in, height_out, width_out, ...
%     'length', part_length);
% parts = add_part(wind_tunnel, parts, 'part_name', 'fetch' , height_in, width_in, height_out, width_out, ...
%     'length', part_length, 'height_testsection', height_testsection); 
%       # height_testsetction = design geometry (height) testsection,
%       # height_out = height max
% parts = add_part(wind_tunnel, parts, 'part_name', 'honeycomb'     , height_in, width_in, height_out, width_out, ...
%     'cell_length', cell_/home/matlablength, 'cell_diameter', cell_diameter, 'cell_wall_thickness', cell_wall_thickness, 'material_roughness', material_roughness);
%       # cell diameter = approximatly diameter/150
% parts = add_part(wind_tunnel, parts, 'part_name', 'screen'        , height_in, width_in, height_out, width_out,...
%     'wire_diameter', wire_diameter, 'wire_roughness', wire_roughness, 'cell_diameter', cell_diameter);
%       # screen--> wire roughnesh = Kmesh = 1.3 for average circular metal wire, =1.0 for new metal wire, =2.1 for silk thread.
% parts = add_part(wind_tunnel, parts, 'part_name', 'corner'        , height_in, width_in, height_out, width_out,...
%     'chord', chord, 'gap_hoh_in', gap_hoh_in, 'gap_hoh_out', gap_hoh_out);
% parts = add_part(wind_tunnel, parts, 'part_name', 'corner_downstream_testsection'        , height_in, width_in, height_out, width_out,...
%     'chord', chord, 'gap_hoh_in', gap_hoh_in, 'gap_hoh_out', gap_hoh_out);
% parts = add_part(wind_tunnel, parts, 'part_name', 'contractor'    , height_in, width_in, height_out, width_out,...
%     'length', part_length); % length = length along the center line
% parts = add_part(wind_tunnel, parts, 'part_name', 'diffuser'      , height_in, width_in, height_out, width_out,...
%     'length_center_line', length_center_line, 'length_wall', length_wall); % Only fill in length_center_line OR length_wall, but NOT both!
% parts = add_part(wind_tunnel, parts, 'part_name', 'inlet'      , height_in, width_in, height_out, width_out,  'shape', shape); 
% parts = add_part(wind_tunnel, parts, 'part_name', 'safetynet'      , height_in, width_in, height_out, width_out); % No additional arguments, always gives a loss coefficient of 0.2
% parts = add_part(wind_tunnel, parts, 'part_name', 'outlet'      , height_in, width_in, height_out, width_out); % No additional arguments, always gives a loss coefficient of 0.2
% parts = add_part(wind_tunnel, parts, 'part_name', 'sudden_expansion'    , height_in, width_in, height_out, width_out);


parts = [];

% 'straight_part'
parts = add_part(wind_tunnel, parts, 'self made text',       'straight_part',                        1.0, 2.0, 1.0, 2.0, 'length', 1);

% 'fetch'
parts = add_part(wind_tunnel, parts, 'Fetch',                'fetch',                                1.6, 2.2, 2.0, 2.2, 'length', 12, 'height_testsection', 1.8);

% 'honeycomb'
parts = add_part(wind_tunnel, parts, 'Honeycomb',            'honeycomb',                            1.1, 1.2, 1.1, 1.2, 'cell_length', .3, 'cell_diameter', .0342, 'cell_wall_thickness', .06478940993, 'material_roughness', 1.5*10^-6);

% 'screen'
parts = add_part(wind_tunnel, parts, 'Screen',               'screen',                               2.0, 2.5, 2.0, 2.5, 'wire_diameter', 0.0006, 'wire_roughness', 1.3, 'cell_diameter', 0.00253747);

% 'corner'
parts = add_part(wind_tunnel, parts, 'Corner',               'corner',                               .85, .60, .92, .60, 'chord', .42);

% 'corner_downstream_testsection'
parts = add_part(wind_tunnel, parts, 'Corner downstream ts', 'corner_downstream_testsection',        1.8, 2.2, 1.8, 2.2, 'chord', .63);

% 'contraction' curved
parts = add_part(wind_tunnel, parts, 'Curved contractor',    'contraction',                          .92, .92, .76, .76, 'shape', 'curved',   'center_length', 1.5); % length = length along the center line

% 'contraction' straight
parts = add_part(wind_tunnel, parts, 'Straight contractor',  'contraction',                          .92, .92, .76, .76, 'shape', 'straight', 'center_length', 1.5); % length = length along the center line

% 'diffuser' cross section rectangular
parts = add_part(wind_tunnel, parts, 'Rectangular diffuser', 'diffuser',                             .76, .76, .98, .93, 'cross_section_shape', 'rectangle', 'length_center_line', 0, 'length_wall', 2.5); % Only fill in length_center_line OR length_wall, but NOT both!

% 'diffuser' cross section circular
parts = add_part(wind_tunnel, parts, 'Circular diffuser',    'diffuser',                             .76, .76, .98, .93, 'cross_section_shape', 'circle', 'length_center_line', 0, 'length_wall', 2.5);    % Only fill in length_center_line OR length_wall, but NOT both!

% 'diffuser_with_boundary_layer_control'
parts = add_part(wind_tunnel, parts, 'Diffuser_BLC',         'diffuser_with_boundary_layer_control', .76, .76, .98, .93, 'length_center_line', 0, 'length_wall', 2.5); % Only fill in length_center_line OR length_wall, but NOT both!

% 'inlet'
parts = add_part(wind_tunnel, parts, 'Inlet',                'inlet',                                2.0, 2.5, 2.0, 2.5, 'shape', 'rounded');

% 'safetynet'
parts = add_part(wind_tunnel, parts, 'Safety net',           'safetynet',                            2.0, 2.5, 2.0, 2.5);

% 'sudden_expansion'
parts = add_part(wind_tunnel, parts, 'Sudden expansion',     'sudden_expansion',                     2.0, 2.5, 2.0, 2.5);

% 'outlet'% Only fill in either wall_length or length_central_line. The other must be set to zero!!!!
parts = add_part(wind_tunnel, parts, 'Outlet',               'outlet',                               2.0, 2.5, 2.0, 2.5);





% Number of parts
parts_count = length(parts);

%% Check parts (checks if corss sections of following parts fit)
if settings.checks.do
    check_windtunnel(parts, settings);
end

%% Calculate the part loss coefficient
for i = 1:parts_count
    parts{i} = part_loss_coefficient(parts{i}, settings);
end

%% Calculate the part pressure losses and the total pressure loss of the wind tunnel (see subfolder calculations)
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

%% Calculate the total power input
wind_tunnel.reserve_factor = settings.total_power_input.reserve_factor;
wind_tunnel.power_input = wind_tunnel.reserve_factor * total_pressure_drop * wind_tunnel.crosssection_test_section * wind_tunnel.velocity_test_section;

%% Calculate the fan power
wind_tunnel.power_fan = wind_tunnel.power_input / (wind_tunnel.efficiency_fan * wind_tunnel.efficiency_motor);

%% Clear useless information
clear i;
clear parts_count;
clear total_loss_coefficient_ratio total_pressure_drop;

%% Show all parts as table
parts_overview = parts_info_table(parts)

%% Pretty printing of totals
pretty_print(parts, wind_tunnel)



%% search part information via --> parts{x}  !!!!!
