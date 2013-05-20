%%
% function crosssection = part_crosssection_average(velocity_test_section, crosssection_test_section, velocity_in, velocity_out)
%
% Determines the parts average crossection.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function crosssection = part_crosssection_average(velocity_test_section, crosssection_test_section, velocity_in, velocity_out)

    % Velocity difference
    d_velocity = (velocity_in + velocity_out) / 2;
    
    crosssection = velocity_test_section * crosssection_test_section / d_velocity;
end
