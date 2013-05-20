% function plot_diffuser_functions()
clear all;
close all;
settings = make_settings();
%            b     blue          .     point              -     solid
%            g     green         o     circle             :     dotted
%            r     red           x     x-mark             -.    dashdot
%            c     cyan          +     plus               --    dashed
%            m     magenta       *     star             (none)  no line
%            y     yellow        s     square
%            k     black         d     diamond
%            w     white

%z = [  0,   1,   2,   3,   4,   5,   6,   8,  10];

x = [  0, 0.25, 0.5,  1, 1.5,   2, 2.5,   3, 3.5,   4, 4.5,   5, 5.5,   6,   7,   8,   9,  10,  11];

b = [.11, .107,.103,0.1,.096,.093,.090,.087,.087,.087,.089,.090,.092,.095,.105,.115, .13, .16, .19]; % eckert

c = [.13, .125, .12,.11,.097, .09,.084,.076,.073, .07,.074,.085,.092,.11, .16, .22, .30, .40, .55]; % cockrell 1963, Ar=9

d = [.24, .228, .22,.20,.180, .16, .15, .14, .13, .14, .15,.165,.175,.19,.235, .28, .33, .40, .51]; % Melbourne 2 < Ar < 9

%%
fun = [NaN]; % model

area_ratio = 9;
velocity_average = 10;
diameter_average = 2;
cross_section_shape = 'rectangle';
for angle_degrees = x
    if(angle_degrees == 0)
        continue;
    end
    angle_radian = degrees2radian(angle_degrees);
    
    re = reynolds_number(velocity_average, diameter_average, settings);
    friction_fact = friction_factor(re, settings);
    
    % deel 1
    loss_friction = (1 - (1 / area_ratio^2)) * (friction_fact / (8 * sin(angle_radian)));
    % deel 2
    % Check type
    switch cross_section_shape
        case 'rectangle'
            if angle_degrees > 0 && angle_degrees <= 1.5
                loss_e = 0.09623 - 0.004152 * angle_degrees;
            else if angle_degrees > 1.5 && angle_degrees <= 5
                    loss_e = 0.1222 - 0.04590 * angle_degrees + 0.02203 * angle_degrees^2 + 0.003269 * angle_degrees^3 - 0.0006145 * angle_degrees^4 - 0.00002800 * angle_degrees^5 + 0.00002337 * angle_degrees^6;
                else if angle_degrees > 5
                        loss_e = -0.01322 + 0.05866 * angle_degrees;
                    else
                        error('Invalid angle provided (%s)', num2str(angle_degrees));
                    end
                    
                end
            end
        case 'circle'
            if angle_degrees > 0 && angle_degrees <= 1.5
                loss_e = 0.1033 - 0.002389 * angle_degrees;
            else if angle_degrees > 1.5 && angle_degrees <= 5
                    loss_e = 0.1709 - 0.1170 * angle_degrees + 0.03260 * angle_degrees^2 + 0.001078 * angle_degrees^3 - 0.0009076 * angle_degrees^4 - 0.00001331 * angle_degrees^5 + 0.00001345 * angle_degrees^6;
                else if angle_degrees > 5
                        loss_e = -0.09661 + 0.04672 * angle_degrees;
                    else
                        error('Invalid angle provided (%s)', num2str(angle_degrees));
                    end
                    
                end
            end
    end
    % deel 3
    loss_expansion = loss_e * ((area_ratio - 1) / area_ratio)^2;
    loss_coefficient = loss_friction + loss_expansion;
    
    fun = [fun loss_coefficient];
end
%%
diameter_in = 1;
diameter_out = 3;
diameter_average = 2;
velocity_average = 10;
fun2 = [NaN];
for angle_degrees = x
    if(angle_degrees == 0)
        continue;
    end
    angle_radian = degrees2radian(angle_degrees);
    
    re = reynolds_number(velocity_average, diameter_average, settings);
    friction_fact = friction_factor(re, settings);
    
    pope = 0.01 / (8*tan(angle_degrees/180*pi)) + 0.6*tan(angle_degrees/180*pi) * (1-(diameter_in^4)/(diameter_out^4));
    fun2 = [fun2 pope];
end


%%
plot (x, fun, 'k-'); hold on;
plot (x, fun2, 'm-'); hold on;
plot (x, b, 'b-'); hold on;
plot (x, c, 'r-'); hold on;
plot (x, d, 'g-'); hold on;
%plot (x, f, 'r-'); hold on;
%plot (x, c, 'c-'); hold on;
%plot (x, g, 'm-'); hold on;
%plot (x, h, 'y-'); hold on;


legend ('Barlow - refenrence', 'Pop - reference', 'Eckert - reference', 'Cockrell - measurements', 'Melbourne - measurements')
title ('rectangular diffuser graphs')
xlabel ('centerline - wall angle (degrees)')
ylabel ('Pressure loss coefficient (-)')

% YLIM([0 0.4])
% end