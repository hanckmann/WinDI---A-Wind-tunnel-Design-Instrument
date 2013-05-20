%%
% function power = required_power(total_power_loss, fan_efficiency, motor_efficiency)
%
% Calculate the required fan power.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : LGPL
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function power = required_power(total_power_loss, fan_efficiency, motor_efficiency)

    power = total_power_loss / (fan_efficiency * motor_efficiency);

end
