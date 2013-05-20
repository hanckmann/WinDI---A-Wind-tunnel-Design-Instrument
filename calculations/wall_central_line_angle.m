%%
% function [angle length] = wall_central_line_angle(radius_in, radius_out, wall_length, length_center_line)
%
% Returns the angle the the wall and the center_line make, and the length
% of the center_line
% Input:
% - radius_in           (rad)
% - radius_out          (rad)
% - wall_length         (m)
% - length_center_line (m)
% Output:
% - angle               (rad)
% - length              (m)
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function [angle length] = wall_central_line_angle(radius_in, radius_out, wall_length, length_center_line)

    if radius_in == radius_out
        error('The radius_in and the_radius out are equal, resulting in an invalid angle.');
    end

    if (wall_length ~= 0) && (length_center_line == 0)
        angle = asin( (radius_out - radius_in) / wall_length );
        length = sqrt(wall_length^2 - (radius_out - radius_in)^2);

    else if (wall_length == 0) && (length_center_line ~= 0)
            angle = atan((radius_out - radius_in) / length_center_line);
            length = length_center_line;

        else
            warning('Both the wall_length and the length_center_line are zero. Omitting this part!');
            angle = 0;
            length = 0;
        end
    end
end
