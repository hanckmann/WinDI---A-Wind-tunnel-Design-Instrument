%%
% function check_windtunnel(parts, settings)
%
% Description: Check for and report problems with the the windtunnel parts.
%
% Input description:
%   parts (cell array)
%       - Every cell in the array represents a part.
%       - Every part is in the correct order
%   settings
%       - Settings as defined in make_settings()
% Output descrion:
%   All output is printed to screen.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : LGPL
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function check_windtunnel(parts, settings)

%% Check and print the number of defined parts
part_count = length(parts);
print_info(['Number of defined parts: ' num2str(part_count)], settings);

%% Check if all parts connect (input and output sizes of subsequent parts)
if part_count > 1
    for i = 1:part_count-1
        if parts{i}.height_out ~= parts{i+1}.height_in
            text = sprintf('Part %s (%s) and %s (%s) do not connect (heights are different).', ...
                num2str(i), parts{i}.name, ...
                num2str(i+1), parts{i+1}.name);
            print_warn(text, settings);
        end
        if parts{i}.width_out ~= parts{i+1}.width_in
            text = sprintf('Part %s (%s) and %s (%s) do not connect (widths are different).', ...
                num2str(i), parts{i}.name, ...
                num2str(i+1), parts{i+1}.name);
            print_warn(text, settings);
        end
    end
    if strcmp(settings.check.type, 'closed')
        if parts{part_count}.height_out ~= parts{1}.height_in
            text = sprintf('Part %s (%s) and %s (%s) do not connect (heights are different).', ...
                num2str(part_count), parts{part_count}.name, ...
                num2str(1), parts{1}.name);
            print_warn(text, settings);
        end
        if parts{part_count}.width_out ~= parts{i}.width_in
            text = sprintf('Part %s (%s) and %s (%s) do not connect (widths are different).', ...
                num2str(part_count), parts{part_count}.name, ...
                num2str(1), parts{1}.name);
            print_warn(text, settings);
        end
    end
else
    text = sprintf('There is only 1 part defined.');
    print_warn(text, settings);
end


end
