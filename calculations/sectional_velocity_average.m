%%
% function velocity_average = sectional_velocity_average(crosssection_test_section, velocity_test_section, crosssection_in, crosssection_out, velocity_in)
%
% Calculate the sectional average velocity.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : LGPL
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function velocity_average = sectional_velocity_average(crosssection_test_section, velocity_test_section, crosssection_in, crosssection_out, velocity_in)

    if(crosssection_out == crosssection_in)
        velocity_average = velocity_in;
    else
        velocity_average = ((crosssection_test_section * velocity_test_section) * log(crosssection_out) ...
            - (crosssection_test_section * velocity_test_section) * log(crosssection_in)) ...
            / (crosssection_out - crosssection_in);
    end
end
