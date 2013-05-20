%%
% function print_error(text, settings)
%
% Description: Print error text to screen.
% 
% Input description:
%   text
%       - Text to print to screen (use sprintf to generate text)
%   settings
%       - Settings as defined in make_settings()
% Output descrion:
%   All output is printed to screen.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function print_error(text, settings)

fprintf(settings.checks.fid_error, 'ERROR: %s\n', text);

end
