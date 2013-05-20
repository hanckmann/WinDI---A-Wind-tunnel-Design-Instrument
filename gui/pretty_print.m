%%
% function pretty_print(parts, wind_tunnel)
%
% Pretty printing the table containging per part:
%     loss_coefficient
%     pressure_loss_dynamic
%     pressure_drop
%     loss_coefficient_ratio
%     loss_percentage
% and for the whole wind tunnel:
% 	  a number of totals
%     power_input
%     power_fan
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function pretty_print(parts, wind_tunnel)

%% Print parts details

    columns{1} = 'nr';
    columns{2} = 'Part name';
    columns{3} = 'K';
    columns{4} = 'q';
    columns{5} = 'delta p';
    columns{6} = 'Kts';
    columns{7} = '%';
    
%     2     9     1     1     7     3     1
%     [length(columns{1}) length(columns{2}) length(columns{3}) length(columns{4}) length(columns{5}) length(columns{6}) length(columns{7})]
    total_loss_coefficient       = 0;
    total_pressure_loss_dynamic  = 0;
    total_pressure_drop          = 0;
    total_loss_coefficient_ratio = 0;
    total_loss_percentage        = 0;

        fprintf('%-2s \t %-22s \t %-9s \t %-9s \t %-9s \t %-9s \t %-9s\n', ...
        columns{1}, columns{2}, columns{3}, columns{4}, columns{5}, columns{6}, columns{7});
        fprintf('--------------------------------------------------------------------------------------\n');
    for i = 1:length(parts)
        fprintf('%2i \t %-18s \t % 9.4f \t % 9.1f \t % 9.2f \t % 9.4f \t % 9.1f\n', ...
            i, parts{i}.name, parts{i}.loss_coefficient, parts{i}.pressure_loss_dynamic, parts{i}.pressure_drop, parts{i}.loss_coefficient_ratio, parts{i}.loss_percentage);
        
        % Calculate totals
        total_loss_coefficient       = total_loss_coefficient       + parts{i}.loss_coefficient;
        total_pressure_loss_dynamic  = total_pressure_loss_dynamic  + parts{i}.pressure_loss_dynamic;
        total_pressure_drop          = total_pressure_drop          + parts{i}.pressure_drop;
        total_loss_coefficient_ratio = total_loss_coefficient_ratio + parts{i}.loss_coefficient_ratio;
        total_loss_percentage        = total_loss_percentage        + parts{i}.loss_percentage;
    end
        fprintf('--------------------------------------------------------------------------------------\n');
        fprintf('   \t %-20s \t \t         \t        % 9.2f   % 9.4f   % 9.1f\n', ...
            'Total', total_pressure_drop, total_loss_coefficient_ratio, total_loss_percentage);
   
        
%% Print wind tunnel details
    fprintf('\n');
    fprintf('  Wind tunnel information:\n');
    fprintf('---------------------------------------\n');
    fprintf('% 18s = % 11.1f \n', 'efficiency_fan', wind_tunnel.efficiency_fan);
    fprintf('% 18s = % 11.1f \n', 'efficiency_motor', wind_tunnel.efficiency_motor);
    fprintf('% 18s = % 11.1f \n', 'reserve_factor', wind_tunnel.reserve_factor);
    fprintf('% 18s = % 9.0f \n', 'power_input', wind_tunnel.power_input);
    fprintf('% 18s = % 9.0f \n', 'power_fan', wind_tunnel.power_fan);
    
end
