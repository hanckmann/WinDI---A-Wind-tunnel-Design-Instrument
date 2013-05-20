%%
% function part = part_pressure_drop(part, settings)
%
% Calculates the pressure loss per part via de pressure loss coefficient
% and the dynamic pressure.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : LGPL
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function part = part_pressure_drop(part, settings)

    % In special cases the velocity out is required instead of the
    % velocity in. Define these here:
    switch part.type
        case 'contraction'
            % Use the velocity average if required
            if(settings.use_average_values || strcmp(part.shape, 'av'))
                velocity = part.velocity_average;
            else
                velocity = part.velocity_out;
            end
        case 'fetch'
            velocity = part.velocity_test_section;
        otherwise
            % Use the velocity average if required
            if(settings.use_average_values)
                velocity = part.velocity_average;
            else
                velocity = part.velocity_in;
            end
    end

    part.pressure_loss_dynamic = dynamic_pressure_loss(velocity, settings);
    part.pressure_drop = part.loss_coefficient * part.pressure_loss_dynamic;
end
