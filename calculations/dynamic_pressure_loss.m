%%
% function pressure_loss = dynamic_pressure_loss(velocity, settings)
%
% Calculate the pressure loss from the dynamic pressure liss.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : June 20, 2012
%%

function pressure_loss = dynamic_pressure_loss(velocity, settings)

    pressure_loss = .5 * settings.density * velocity^2;
end
