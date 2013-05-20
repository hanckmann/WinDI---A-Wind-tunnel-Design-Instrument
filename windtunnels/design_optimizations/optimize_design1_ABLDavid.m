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
wind_tunnel.crosssection_test_section = 0.40;
wind_tunnel.velocity_test_section     = 13;

%% Calculations circular
disp('Design optimisation1')
test_results = []; % Test result storage

A_range = [ 3 : 0.2 : 16];

%L_range = [1 : 0.2: 8.6];
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
                if (tmp_part.angle_degrees > 15)
                    parts = add_part(wind_tunnel, parts, 'BLC Screen 3' , 'screen'                         ,  sqrt(A), sqrt(A), sqrt(A), sqrt(A), 'wire_diameter', 0.001, 'wire_roughness', 1.3, 'cell_diameter', 0.01);
                end
                if (tmp_part.angle_degrees > 20)
                    parts = add_part(wind_tunnel, parts, 'BLC Screen 1' , 'screen'                         , 1.2, 1.5, 1.2, 1.5,'wire_diameter', 0.001, 'wire_roughness', 1.3, 'cell_diameter', 0.01);
                    end
                if (tmp_part.angle_degrees > 22.5)
                    parts = add_part(wind_tunnel, parts, 'BLC Screen 4' , 'screen'                         , sqrt((1.2+A)/2), sqrt((1.5+A)/2), sqrt((1.2+A)/2), sqrt((1.5+A)/2),'wire_diameter', 0.001, 'wire_roughness', 1.3, 'cell_diameter', 0.01);
                end
            end
        end
        clear last_part_number tmp_part;

        parts = add_part(wind_tunnel, parts, 'Straight part honey'  , 'straight_part'                  , sqrt(A), sqrt(A), sqrt(A), sqrt(A),'length', .4);
        parts = add_part(wind_tunnel, parts, 'Screen 1'             , 'screen'                         , sqrt(A), sqrt(A), sqrt(A), sqrt(A),'wire_diameter', 0.0005, 'wire_roughness', 1.3, 'cell_diameter', 0.0015);
        parts = add_part(wind_tunnel, parts, 'Screen 2'             , 'screen'                         , sqrt(A), sqrt(A), sqrt(A), sqrt(A),'wire_diameter', 0.0007,  'wire_roughness', 1.3, 'cell_diameter', 0.003);
        parts = add_part(wind_tunnel, parts, 'Honeycomb'            , 'honeycomb'                       , sqrt(A), sqrt(A), sqrt(A), sqrt(A),'cell_length', 8*(sqrt(A)/150), 'cell_diameter', (sqrt(A)/150), 'cell_wall_thickness', .002, 'material_roughness', 8*10^-5);
        parts = add_part(wind_tunnel, parts, 'Contraction'          , 'contraction'                    , sqrt(A), sqrt(A), .71, .6,         'shape', 'straight', 'center_length', 1.5);
        
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

% Clear useless information
clear i;
clear parts_count;
clear wind_tunnel.crosssection_test_section wind_tunnel.velocity_test_section;

%% Plotting
% NOTE: This only works if you use 2 variable-ranges (2 loops), otherwise
%       the result is undefined.

% Plot the outcome values
plot_count = L_range;
X_range    = A_range;
Y_line     = 605; % if you do not want to use it, set it to: NaN
X_label    = 'A (m^2)';
Y_label    = 'Fan power (W)';
Y_min      = NaN;     % if you do not want to use it, set it to: NaN
Y_max      = NaN;     % if you do not want to use it, set it to: NaN
line_size  = 2;
text_size  = 2;
titel_plot{1} = '';
titel_plot{2} = 'A = 5 m^2';
titel_plot{3} = 'A = 7 m^2';
titel_plot{4} = 'A = 9 m^2';

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
    if index == 1
        ylabel(Y_label);
    end
    title(titel_plot{index});
end

%% index plot

% % Plot the outcome values
% Y_line     = 605; % if you do not want to use it, set it to: NaN
% Title      = '';
% X_label    = 'Simulation number';
% Y_label    = 'Fan power (W)';
% line_size  = 3;
% %line_legend   = ''; % You should only specify 1 line here
% plot_legend_1 = '';
% 
% %%% DO NOT EDIT BELOW THIS LINE %%%
% figure;
% % Prepare the X and Y data
% plotdataX = [];
% plotdataY = [];
% for index = 1:length(test_results)
%     plotdataX = [plotdataX index];
%     plotdataY = [plotdataY test_results(index).wind_tunnel.power_fan];
% end
% % Prepare the Y line
% if(~isnan(Y_line))  % we want Y line
%     Y_line = ones(1,length(plotdataX)) * Y_line;
% end
% %figure;
% % Plot the line
% if(~isnan(Y_line)) % we want Y line
%     plot(plotdataX,Y_line,'--g','LineWidth',2); hold on;
% end
% % Plot the data
% plot(plotdataX,plotdataY,'r*','LineWidth',line_size);
% xlabel(X_label);
% ylabel(Y_label);
% title(Title);
% if(~isnan(Y_line))
%   %  legend(line_legend,plot_legend_1);
% else
%   %  legend(plot_legend_1);
% end
% % set(gca,'FontSize',text_size);
% 
% %% search test results via
% % test_results(simulation number).parts{part number}