%%
% function show_part(parts, part_id)
%
% Print all known information about a part to screen. The part can be requested
% using its index in the wind tunnel, or using the provided name of that part.
% If no partname or index is provided, all the wind tunnel parts and their indices
% will be printed to screen.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function show_part(parts, part_id)

if nargin < 2
	disp('Wind tunnel information');
	error('TBD.');
else
	disp('Part information');
end


id = -1;
if isnumeric(part_id)
    id = part_id;
else % Part is a name
    for i = 1:length(parts)
        if strcmpi(parts{i}.name, part_id)
            id = i;
        end
    end
end

if id < 0
    error('Part is not available.');
end

if id > length(parts)
    error('Part is not available.');
end

parts{id}
