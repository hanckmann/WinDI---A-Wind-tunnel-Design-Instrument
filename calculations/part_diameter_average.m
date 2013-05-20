%%
% function diameter = part_diameter_average(crosssection, type)
%
% Determines the average diameter for a part (currently only supports a rectangular shape).
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : LGPL
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function diameter = part_diameter_average(crosssection, type)

    % Check type
    switch type
        case 'rectangle'
            diameter = sqrt(crosssection);
        otherwise
            error('Wrong type definition (%s).', type);
    end

end
