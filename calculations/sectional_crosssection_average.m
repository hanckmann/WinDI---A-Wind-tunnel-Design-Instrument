%%
% function crosssection_average = sectional_crosssection_average(wind_tunnel, velocity_average)
%
% Determine the average sectional cross section.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : LGPL
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function crosssection_average = sectional_crosssection_average(wind_tunnel, velocity_average)

    crosssection_average = (wind_tunnel.crosssection_test_section * wind_tunnel.velocity_test_section) / velocity_average;
end
