%%
% function loss_factor_ratio = loss_test_section_ratio(loss_test_section, crosssection_test_section, crosssection_average)
%
% Determine the loss factor ratio for the test section.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : LGPL
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : June 20, 2012
%%

function loss_factor_ratio = loss_test_section_ratio(loss_test_section, crosssection_test_section, crosssection_average)

    loss_factor_ratio = loss_test_section * (crosssection_test_section / crosssection_average)^2;
end
