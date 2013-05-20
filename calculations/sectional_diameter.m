%%
% function crosssection_average = sectional_crosssection_average(wind_tunnel, velocity_average)
%
% Determine the sectional diameter.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function diameter = sectional_diameter(height, width, type) % is hydraulic diameter

    % Check type
    switch type
        case 'rectangle'
            diameter = (2 * height * width) / (height + width);
        otherwise
            error('Wrong type definition (%s).', type);
    end

end
