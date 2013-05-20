% example_optimise_script
%
% Optimise a windtunnel design following a brute force search approach.
% See comments in the file for more details.
%
% Date:     January 19, 2013
% Version:  1
% Contact:  rinkavdommelen@hotmail.com
% Authors:  Rinka van Dommelen
%           Patrick Hanckmann

%            b     blue          .     point              -     solid
%            g     green         o     circle             :     dotted
%            r     red           x     x-mark             -.    dashdot
%            c     cyan          +     plus               --    dashed
%            m     magenta       *     star             (none)  no line
%            y     yellow        s     square
%            k     black         d     diamond
%            w     white         v     triangle (down)
%                                ^     triangle (up)
%                                <     triangle (left)
%                                >     triangle (right)
%                                p     pentagram
%                                h     hexagram

clear all;

clear parts;
clear wind_tunnel;
close all;

%% Create settings
settings = make_settings();
settings.checks.do = 0;
settings.check.type = 'open';
settings.diffuser.enable_max_value_max_degrees = false;

%% Start script
print_info(['Windtunnel optimise script (' mfilename() ')'], settings);

%% Windtunnel specifications (input)
wind_tunnel.efficiency_fan      = 0.8;
wind_tunnel.efficiency_motor    = 0.8;
wind_tunnel.crosssection_test_section = 1.5;
wind_tunnel.velocity_test_section     = 20;

%% Calculations circular
disp('Design optimisation1')
test_results = []; % Test result storage



%A1_range = [2.5 : 3 : 11.5 ];
A1_range = [3 : 1 : 12 ];

% A2_range = [2.5 : 0.2 : 3.5];
%  
% L_range = [3.5 : 0.5 : 5.5];

A2_range = 3.3;
L_range = 5.5;

for L = L_range
for A1 = A1_range
    for A2 = A2_range
        
            parts = [];
            parts = add_part(wind_tunnel, parts, 'Inlet',                'inlet',                          sqrt(A1), sqrt(A1), sqrt(A1), sqrt(A1)   , 'shape', 'rounded');
            parts = add_part(wind_tunnel, parts, 'Straight part',        'straight_part',                  sqrt(A1), sqrt(A1), sqrt(A1), sqrt(A1)   , 'length', 0.5*sqrt(A1));
            parts = add_part(wind_tunnel, parts, 'Honeycomb'             ,'honeycomb'                     , sqrt(A1), sqrt(A1), sqrt(A1), sqrt(A1)  , 'cell_length', 8*(sqrt(A1)/150), 'cell_diameter', (sqrt(A1)/150), 'cell_wall_thickness', .002, 'material_roughness', 8*10^-5);
            parts = add_part(wind_tunnel, parts, 'Screen'                ,'screen'                        , sqrt(A1), sqrt(A1), sqrt(A1), sqrt(A1)  , 'wire_diameter', 0.0007, 'wire_roughness', 1.3, 'cell_diameter', 0.003);
            parts = add_part(wind_tunnel, parts, 'Screen'                ,'screen'                        , sqrt(A1), sqrt(A1), sqrt(A1), sqrt(A1)  , 'wire_diameter', 0.0005, 'wire_roughness', 1.3, 'cell_diameter', 0.0015);
            
            parts = add_part(wind_tunnel, parts, 'Curved contraction'    ,'contraction'                   , sqrt(A1), sqrt(A1), 1, 1.5              , 'shape' ,'curved', 'center_length', 1.5); % length = length along the center line
            parts = add_part(wind_tunnel, parts, 'Fetch'                 ,'fetch'                         , 1, 1.5, 1.07, 1.5                       , 'length', 8, 'height_testsection',1);
            parts = add_part(wind_tunnel, parts, 'contraction'           ,'contraction'                   , 1.07, 1.5, 1, 1                         , 'shape' ,'straight', 'center_length', 0.5); % length = length along the center line
            
            %sucking fan 1*1
            parts = add_part(wind_tunnel, parts, 'Rectangular diffuser'  ,'diffuser'                      , 1, 1, sqrt(A2), sqrt(A2)                , 'cross_section_shape', 'rectangle', 'length_center_line', L, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
            parts = add_part(wind_tunnel, parts, 'Outlet',               'outlet'                         , sqrt(A2), sqrt(A2), sqrt(A2), sqrt(A2));
            
            % Number of parts/home/matlab
            parts_count = length(parts);
            
            % Check parts
            if settings.checks.do > 0
                check_windtunnel(parts, settings);
            end
            
            % Calculate the part loss coefficient
            for i = 1:parts_count
                parts{i} = part_loss_coefficient(parts{i}, settings);
            end
            
            % Calculate the part|total pressure drop
            wind_tunnel.total_pressure_drop = 0;
            for i = 1:parts_count
                parts{i} = part_pressure_drop(parts{i}, settings);
                wind_tunnel.total_pressure_drop = wind_tunnel.total_pressure_drop + parts{i}.pressure_drop;
            end
            
            % Calculate the part|total loss coefficient ratio (and percentage)
            wind_tunnel.total_loss_coefficient_ratio = 0;
            for i = 1:parts_count
                parts{i} = part_loss_coefficient_ratio(parts{i}, settings);
                wind_tunnel.total_loss_coefficient_ratio = wind_tunnel.total_loss_coefficient_ratio + parts{i}.loss_coefficient_ratio;
            end
            
            % Calculmate the part loss percentage
            for i = 1:parts_count
                parts{i}.loss_percentage = 100 / wind_tunnel.total_loss_coefficient_ratio * parts{i}.loss_coefficient_ratio;
            end
            
            % Calculate the total power input
            wind_tunnel.reserve_factor = settings.total_power_input.reserve_factor;
            wind_tunnel.power_input = wind_tunnel.reserve_factor * wind_tunnel.total_pressure_drop * wind_tunnel.crosssection_test_section * wind_tunnel.velocity_test_section;
            
            % Calculate the fan power
            wind_tunnel.power_fan = wind_tunnel.power_input / (wind_tunnel.efficiency_fan * wind_tunnel.efficiency_motor);
            
            index = length(test_results) + 1;
            test_results(index).parts = parts;
            test_results(index).wind_tunnel = wind_tunnel;
        end
    end
end


% Clear useless information
clear i;
clear parts_count;
clear wind_tunnel.crosssection_test_section wind_tunnel.velocity_test_section;

%% Plotting
% NOTE: This only works if you use 2 variable-ranges (2 loops), otherwise
%       the result is undefined.

% Plot the outcome values
plot_count = L1_range;
X_range    = A_range;
Y_line     = 605; % if you do not want to use it, set it to: NaN
Title      = 'Wind tunnel power';
X_label    = 'Cross section (m^2)';
Y_label    = 'Fan power (W)';
Y_min      = NaN;     % if you do not want to use it, set it to: NaN
Y_max      = NaN;     % if you do not want to use it, set it to: NaN
line_size  = 2;
text_size  = 2;
line_legend   = 'Max fan power (605W)'; % You should only specify 1 line here
plot_legend_1 = 'Fan power for L = ';
plot_legend_2 = 'm';

%%% DO NOT EDIT BELOW THIS LINE %%%
% Prepare the Y line
if(~isnan(Y_line))  % we want Y line
    Y_line = ones(1,length(X_range)) * Y_line;
end
% Prepare the X range
plotdataX = X_range;
% Build the Y data
for index = 1:length(plot_count)
    % Plot the line
    if(~isnan(Y_line)) % we want Y line
        subplot(1,length(plot_count),index), plot(plotdataX,Y_line,'--g','LineWidth',line_size); hold on;
    end
    % Plot the data
    plotdataY = [];
    x_start = (index) * length(X_range) - length(X_range);
    for y_index = 1:length(X_range)
        plotdataY = [plotdataY test_results(x_start+y_index).wind_tunnel.power_fan];
    end
    subplot(1,length(plot_count),index), plot(plotdataX,plotdataY,'r-','LineWidth',line_size);
    if(~isnan(Y_min) && ~isnan(Y_min)) 
        ylim([Y_min Y_max]);
    end
    xlabel(X_label);
    ylabel(Y_label);
    if(~isnan(Y_line))
        legend(line_legend,[plot_legend_1 num2str(plot_count(index)) plot_legend_2]);
    else
        legend([plot_legend_1 num2str(plot_count(index)) plot_legend_2]);
    end
end
mtit(sprintf([Title '\n']));
set(gca,'FontSize',text_size);

% Plot the outcome values
Y_line     = 605; % if you do not want to use it, set it to: NaN
Title      = 'Wind tunnel power (index plot)';
X_label    = 'Simulation number';
Y_label    = 'Fan power (W)';
line_size  = 4;

%%% DO NOT EDIT BELOW THIS LINE %%%
% Prepare the X and Y data
plotdataX = [];
plotdataY = [];
for index = 1:length(test_results)
    plotdataX = [plotdataX index];
    plotdataY = [plotdataY test_results(index).wind_tunnel.power_fan];
end
% Prepare the Y line
if(~isnan(Y_line))  % we want Y line
    Y_line = ones(1,length(plotdataX)) * Y_line;
end
figure;
% Plot the line
if(~isnan(Y_line)) % we want Y line
    plot(plotdataX,Y_line,'--g','LineWidth',2); hold on;
end
% Plot the data
plot(plotdataX,plotdataY,'r*','LineWidth',line_size);
xlabel(X_label);
ylabel(Y_label);
title(Title);
set(gca,'FontSize',text_size);
