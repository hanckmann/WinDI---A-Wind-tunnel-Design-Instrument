%%
% function crosssection = sectional_crosssection(height, width, type)
%
% Determine the sectional cross section.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function crosssection = sectional_crosssection(height, width, type)

    if height == 0
            error('A height of zero is not valid.');
    end
    if width == 0
            error('A width of zero is not valid.');
    end
        
    % Check type
    switch type
        case 'rectangle'
            crosssection = height * width;
        otherwise
            error('Wrong type definition (%s).', type);
    end

end
