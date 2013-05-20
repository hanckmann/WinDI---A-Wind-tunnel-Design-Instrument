%%
% function re = reynolds_number(velocity, variable_diameter, settings)
%
% Calculate the Reynolds number.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function re = reynolds_number(velocity, variable_diameter, settings)
    
    kinematic_viscosity = settings.dynamic_viscosity / settings.density;
    
    re = velocity * variable_diameter / kinematic_viscosity;

end
