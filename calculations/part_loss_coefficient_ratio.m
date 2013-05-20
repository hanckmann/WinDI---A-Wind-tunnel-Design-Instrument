%%
% function part = part_loss_coefficient_ratio(part, settings)
%
% Calculates the pressure loss coefficient ratio. to be able to compaire
% the pressure loss coefficient relative to the test section.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function part = part_loss_coefficient_ratio(part, settings)

    pressure_loss_dynamic_test_section = 0.5 * settings.density * part.velocity_test_section^2;

    part.loss_coefficient_ratio = part.loss_coefficient * part.pressure_loss_dynamic / pressure_loss_dynamic_test_section;
end
