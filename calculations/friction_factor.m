%%
% function friction = friction_factor(part_reynolds_number, settings)
%
% Determine the friction factor based on the reynolds number. The friction factor
% is determined using a brute force search. The search parameters are provided
% in the settings.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : June 20, 2012
%%

function friction = friction_factor(part_reynolds_number, settings)

    Re = part_reynolds_number;
    friction = [];

    % Brute force search
    start    = settings.friction_factor.start;
    interval = settings.friction_factor.interval;
    finish   = settings.friction_factor.finish;
    
    result = inf;
    hist = 0;
    for x = start:interval:finish
        n_result = (2 * log10(Re * x^(.5)) - .8)^(-2) - x;
        if abs(n_result) < result   % searching for the least talented x-factor (closest to zero)
            result = n_result;  
            friction = x;
        else                        % when the quality gets worse again, then we quit searching (assumption: there is no local optimum)
            if hist > 1
                break
            end
            hist = hist+1;
        end
    end
end
