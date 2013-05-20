%%
% function new_part = parse_arguments(new_part, required_options, varargin)
%
% Parsing commandline arguments. It requires the struct in which to put the
% parsed argument, converted as a part (if the arguments where valid), the
% required arguments, and the list of arguments.
%
% Errors and warnings are raised if problems are detected.
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%


function new_part = parse_arguments(new_part, required_options, varargin)

    optionNames      = fieldnames(required_options);
    optionArguments  = varargin{1};

    % count arguments
    nArgs = length(optionArguments);
    if round(nArgs/2)~=nArgs/2
        error('Options need propertyName/propertyValue pairs')
    end

    % set the required options
    filled_options = 0;
    for pair = reshape(optionArguments,2,[])   % pair is {propName;propValue}
        inpName = pair{1};
        if any(strmatch(inpName,optionNames))
            % Overwrite/add options.
            new_part.(inpName) = pair{2};
            if required_options.(inpName) < 1
                filled_options = filled_options + 1;
                required_options.(inpName) = required_options.(inpName) + 1;
            end
        else
            % Hack to enable hardcoded loss_coefficient values
            if(strmatch(inpName,'loss_coefficient'))
                settings.checks.fid_info = 1; % We have no settings here, so we set the relevant variable here
                print_info(['Loss coefficient is provided as input for "' new_part.name '"!'], settings);
                new_part.(inpName) = pair{2};
            else
                warning('%s is not a recognized parameter name',inpName)
            end
        end
    end

    % check if all options are provided
    if size(optionNames,1) ~= filled_options
        error('Not all required options provided.');
    end
end
