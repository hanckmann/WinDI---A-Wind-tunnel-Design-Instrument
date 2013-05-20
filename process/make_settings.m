
%%
% function settings = make_settings(settings_file)
%
% Build a (valid) settings struct for WinDI.
%
% Fixed setting are give here.
%
% The settings can be loaded from disk, by providing the filename of a saved
% settings struct as function argument. If that file exists, these settings will
% be loaded and will will overwrite all settings from this file (i.e. the
% settings from the loaded settingsfile only overwrites settings which are
% present here and in the file and add settings which are only in the file).
%
% If a filename is provided, the settings will always be saved to disk! This
% implies that if (somehow) new settings are added in this file, which did not
% existed in the loaded settings, the saved settings are equal to the loaded
% settings and extended with the new settings. This ensures that old settingsfiles
% can be used in newer versions of the program.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function settings = make_settings(settings_file)
    % Set settings file to load
    if (nargin < 1)
        settings_file = [];
    end

    %% Settings
    
    % Loss coefficient standard values
    settings.safetynet.loss_coefficient         = 0.2;
    settings.outlet.loss_coefficient            = 1.0;
    settings.contraction.straight_minimum_loss_coefficient = 0.01;  
    %settings.sudden_expansion.loss_coefficient  = 1.0;
         
    % Loss coefficient diffuser, advanced settings
    settings.diffuser.max_loss_coefficient = 1;
    settings.diffuser_with_boundary_layer_control.min_angle_degrees = 10;
    
    % Calculate friction factor; set the brute-force-search bandwidth and
    % interval, just info for calculation of loop friction factor. 
    settings.friction_factor.start    = 0.0001;      % start value
    settings.friction_factor.interval = 0.0000001;   % determines precission
    settings.friction_factor.finish   = 0.025;       % final value
    
    % Reynoldsnumber & dynamic pressure loss
    settings.density                  = 1.225;       % kg/m^3
    settings.dynamic_viscosity        = 1.551*10^-5; % (m^2/s) %%typing error is kinemtic viscosity!!

    % Loss coefficient ratio
    settings.use_average_values = false; % false, true , in case of false it uses inlet velocity
    
    % Total power input
    settings.total_power_input.reserve_factor = 1.1;
    
    % Validation
    settings.checks.do          = 1; % if 1 then perform validation check, else validation is skipped
    settings.check.type         = 'closed'; % is 'open' or 'closed'
    settings.checks.fid_info    = 1; %  1 (for standard output in black to screen) or 2 (for standard error in red to screen in red)
    settings.checks.fid_warning = 1; %  1 (for standard output in black to screen) or 2 (for standard error in red to screen in red)
    settings.checks.fid_error   = 2; %  1 (for standard output in black to screen) or 2 (for standard error in red to screen in red)
    
    %% Load and save settings file if requested.
    %  Only load if file exists. Always save if a filename is given.
    %  Must be done last, so ensure that new settings are being set 
    %  (even when loading an old settings file).
    if ~isempty(settings_file)
        if exist(settings_file,'file')
            load(settings_file, 'settings');
        end
        save(settings_file, 'settings');
    end
end
