%%
% function ratio = gap_chord_ratio(gap_hoh, chord)
%
% Determine the friction factor based on the reynolds number. The friction factor
% is determined using a brute force search. The search parameters are provided
% in the settings.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : LGPL
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : June 20, 2012
%%

function ratio = gap_chord_ratio(gap_hoh, chord)

    ratio = gap_hoh / chord;
    if ratio > 0.3
        warning('gap_chord_ratio > 0.3');
    end
end
