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
settings.diffuser.enable_max_value_max_degrees = false;

%% Start script
print_info(['Windtunnel optimise script (' mfilename() ')'], settings);

%% Windtunnel specifications (input)
wind_tunnel.efficiency_fan      = 0.8;
wind_tunnel.efficiency_motor    = 0.8;
wind_tunnel.crosssection_test_section = 1;
wind_tunnel.velocity_test_section     = 20;

%% Calculations circular
disp('Calculations circular')
test_results = []; % Test result storage
testset = 0.2:0.2: 30;
for t_length_center_line = testset
    parts = [];
    parts = add_part(wind_tunnel, parts, 'Circular diffuser',     'diffuser',              1, 1, 1.4, 1.4, 'cross_section_shape', 'circle', 'length_center_line', t_length_center_line, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
    
    % Number of parts/home/matlab
    parts_count = length(parts);
    
    % Check parts
    if settings.checks.do
        check_windtunnel(parts, settings);
    end
    
    % Calculate the part loss coefficient
    for i = 1:parts_count
        parts{i} = part_loss_coefficient(parts{i}, settings); %#ok<SAGROW>
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
    
    % Calculate the part loss percentage
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

% Clear useless information
clear i;
clear parts_count;
clear wind_tunnel.crosssection_test_section wind_tunnel.velocity_test_section;

% Plot the outcome values
plotdataX = [];
plotdataY = [];
for index = 1:length(test_results)
    plotdataX = [plotdataX test_results(index).parts{1}.angle_degrees];
    plotdataY = [plotdataY test_results(index).parts{1}.loss_coefficient];
end
plot(plotdataX,plotdataY,'k-'); hold on;

%%
 % Calc the pressure losses
 velocity_average = 20; %=velocity in
 diameter_in = 1;
 diameter_out = 1.4;
 diameter_average = diameter_in;
 pressure_loss = [];
 %x = 
 for angle_degrees = x
     if(angle_degrees <= 0)
         pressure_loss = [pressure_loss NaN];
         continue;
     end
     if(angle_degrees > 3.5)
         pressure_loss = [pressure_loss NaN];
         continue;
     end
 %     angle_radian = degrees2radian(angle_degrees);
     
     re = reynolds_number(velocity_average, diameter_average, settings);
     friction_fact = friction_factor(re, settings);
     
     pope = friction_fact / (8*tan(angle_degrees/180*pi)) + 0.6*tan(angle_degrees/180*pi) * (1-(diameter_in^4)/(diameter_out^4));
     pressure_loss = [pressure_loss pop];
 end
 
 pressure_loss2 = [];
 for angle_degrees = x
     if(angle_degrees <= 0)
         pressure_loss2 = [pressure_loss2 NaN];
         continue;
     end
     
     re = reynolds_number(velocity_average, diameter_average, settings);
     friction_fact = friction_factor(re, settings);
     
     pope = friction_fact / (8*tan(angle_degrees/180*pi)) + 0.6*tan(angle_degrees/180*pi) * (1-(diameter_in^4)/(diameter_out^4));
     pressure_loss2 = [pressure_loss2 pope];
 end




%%
% Results measurements of wind tunnels
disp('Measurements')

x = [0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 20, 22, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90 ]

xh=  [  1,  2,  3,  4,  6, 10, 15, 18, 20, 22.5];
h9=  [.22,.13,.11,.13, .2, .4,.65,.78,.83,.89]; %henry Ar=9
h2=  [.12,.07,.06,.07,.11,.22,.36,.42,.46,.49]; %henry Ar=2

xm = [  2,  5,  7, 15,  30,  90 ];
m9 = [ .6,.22,.35,.80, 1.06, .9 ]; %mun Ar=9
m2 = [.32,.12,.20,.45, .60, .50]; %mun Ar=2

xg = [ 1.5,   2, 2.5, 3.5,   5,   6,  7.5, 10, 12.5, 15,   20,  25,   30,  90 ];
g9 = [ .18, .17, .13, .14, .17, .21, .27, .42, .64, .80, 1.02, 1.03, 1.04, 1.04]; %gibson Ar=9
g4 = [ .18, .17, .13, .14, .17, .21, .27, .42, .82, 1.02,1.22, 1.17, 1.1, 1.03 ]; %gibson Ar=4
g2 = [ .18, .17, .13, .14, .17, .21, .27, .42, .64, .80,  1  , 1.17,1.11, 1  ]; %gibson Ar =2

xe = [  0, 0.5,    1,  1.5,    2, 2.5,   3, 3.5,    4, 4.5,   5, 5.5]; %eckert
e =  [.115, .1, .076, .065, .055, .06, .07, .09,   .1, .12, .15,.165] ;

xmel= [  0, 0.25, 0.5,  1, 1.5,   2, 2.5,   3, 3.5,   4, 4.5,   5, 5.5,   6,   7,   8,   9,  10,  11, 15,  20,  25,  30,  35,  40,  50,  90];

mel9 = [.24, .228, .22,.195,.18, .16, .15,.135, .13,.135, .15,.165,.175,.192,.235, .28, .33, .40, .51, .67, .82, .93,1.03,1.07,1.05,1.04,1.02]; % Melbourne Ar = 9
mel4 = [.24, .228, .22,.195,.18, .16, .15,.135, .13,.135, .15,.165,.175,.192,.235, .28, .33, .40, .51, .80,1.02,1.15,1.20,1.20,1.16,1.10,1.03]; % Melbourne Ar = 4 
mel2 = [.24, .228, .22,.195,.18, .16, .15,.135, .13,.135, .15,.165,.175,.192,.235, .28, .33, .40, .51, .70, .90,1.06,1.20,1.20,1.16,1.10,1.03]; % Melbourne Ar = 2.3
%%
% plot the bunch

plot (x, pressure_loss, 'k-');
plot (x, pressure_loss2, 'k--');

plot (xe, e, 'b-'); hold on;
plot (xh, h2, 'y-'); hold on;
plot (xm, m2, 'c-'); hold on;
plot (xg, g2, 'r-'); hold on;
plot (xmel, mel2, 'm-'); hold on;

legend ('barlow Ar=2', 'Pope', 'Pope extented', 'Eckert', 'Henry Ar=2', 'Munson Ar=2', 'Gibson Ar=2', 'Melbourne Ar=2')
title ('Circular Diffuser graphs, Area ratio =9')
xlabel ('Centerline - Wall angle (degrees)')
ylabel ('Pressure loss coefficient (-)')

ylim([0 1.4])
xlim([0 90])
