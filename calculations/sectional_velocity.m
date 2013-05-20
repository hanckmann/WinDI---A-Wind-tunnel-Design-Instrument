%%
% function velocity = sectional_velocity(crosssection_test_section, velocity_test_section, crosssection)
%
% Calculate the sectional velocity
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : LGPL
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function velocity = sectional_velocity(crosssection_test_section, velocity_test_section, crosssection)

    velocity = (crosssection_test_section * velocity_test_section) / (crosssection);
end
