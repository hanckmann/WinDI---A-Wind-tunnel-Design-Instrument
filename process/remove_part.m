%%
% function parts = remove_part(parts, parts_number)
%
% Removes the part defined in parts_number. 
% If parts_number <= 0, than the last part is removed.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : LGPL
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function parts = remove_part(parts, parts_number)

    if(parts_number <= 0)
        parts_number = length(parts);
    end

    parts(parts_number) = [];
end
