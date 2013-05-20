%%
% function new_part = add_part(wind_tunnel, parts, name, type, 
%                              height_in, width_in, height_out, width_out, 
%                              varargin)%
% 
% add_part adds the parts to represent the wind tunnel design.
% The required input per part depends on the part type and is as
% follows:
% 
% Each part requires:
%     wind_tunnel               % Wind tunnel information =taken care of
%     parts                     % Parts structure to add the part =taken care of
%     name                      % Name of the part
%     type                      % Part type (must be on of the specified parts below
%     height_in                 % Height in  (m)
%     width_in                  % Width in   (m)
%     height_out                % Height out (m)
%     width_out                 % Width out  (m)
%
% Part specific information:
%     straight_part
%         length                % Lenght               (m)
%     fetch
%         length                % Lenght               (m)
%         height_testsection    % Height test section  (m)
%     honeycomb
%         cell_length           % Cell length          (m)
%         cell_diameter         % Cell diameter        (m)
%         cell_wall_thickness   % Cellwall thickness   (m)
%         material_roughness    % Material roughness   (m)
%     screen
%         wire_diameter         % Wire diamter         (m)
%         wire_roughness        % Wire roughness       (-)
%         cell_diameter         % Cell diameter        (m)
%     corner
%         chord                 % Chord                (m)
%     corner_downstream_testsection
%         chord                 % Chord                (m)
%     contraction
%         shape                 % 'curved' or 'straight'
%         length                % Length along the center line (m)
%     diffuser               !! only give length_center_line OR length_wall
%         cross_section_shape   % 'rectangle' or 'circle'
%         length_center_line    % Length of the center line (m)
%         length_wall           % Length of the wall        (m)
%     Inlet
%         shape                 % 'rouded', 'straight', 'duct_with_wall',
%                               % or 'duct'
%     safetynet
%         loss_coefficient here always 0.2
%     sudden_expansion
%         loss_coefficient here always 1
%     Straight_inlet
%         Loss_coefficient here always 0.5
%     outlet
%         Loss_coefficient here always 1
% General part information is provided in a fixed format (see the list above),
% the part type specific information is provided using identifiers.
% For example; the additional information for a straight part is the length 
% and is given as:  
% 'length', 0.5
% where 0.5 is the length in meters. 
%
% Inspiration: http://stackoverflow.com/questions/2775263/how-to-deal-with-name-value-pairs-of-function-arguments-in-matlab
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function parts = add_part(wind_tunnel, parts, name, type, height_in, width_in, height_out, width_out, varargin)

    %% Check if the wind_tunnel inputs are correct
    checklist = {'crosssection_test_section' 'velocity_test_section'};
    for check = checklist
        if(~isfield(wind_tunnel, check))
            error(['The ' check{1} ' is not defined in the wind_tunnel variable!']);
        end
    end

    %% Calculate part independend information
    diameter_in          = sectional_diameter(height_in, width_in, 'rectangle');
    diameter_out         = sectional_diameter(height_out, width_out, 'rectangle');
    crosssection_in      = sectional_crosssection(height_in, width_in, 'rectangle');
    crosssection_out     = sectional_crosssection(height_out, width_out, 'rectangle');
    velocity_in          = sectional_velocity(wind_tunnel.crosssection_test_section, wind_tunnel.velocity_test_section, crosssection_in);
    velocity_out         = sectional_velocity(wind_tunnel.crosssection_test_section, wind_tunnel.velocity_test_section, crosssection_out);

    velocity_average     = sectional_velocity_average(wind_tunnel.crosssection_test_section, wind_tunnel.velocity_test_section, crosssection_in, crosssection_out, velocity_in);
    crosssection_average = sectional_crosssection_average(wind_tunnel, velocity_average);
    diameter_average     = sectional_diameter_average(crosssection_average);
    
    %% We need to check for some very special cases
    % Special case: if for a diffuser the radius_in and the_radius out are equal,
    % this is concidered to be a straight_part
    if (strcmp(type,'diffuser') || strcmp(type,'diffuser_with_boundary_layer_control'))
%         if ((height_in * width_in) == (height_out * width_out))
         if ( abs( (height_in * width_in) - (height_out * width_out) ) < 0.0000001) % Computer quircks, if the difference is extremely small, we consider this to be a straight part
            name = [name ' (diffuser as straight_part)'];
            type = 'straight_part';
            % Argument checks and finding the center_length
            center_length = 0;
            for i = 1:length(varargin)-1
                % Find the expected arguments
                if strcmp(varargin{i},'length_center_line') || strcmp(varargin{i},'length_wall')
                    if varargin{i+1} > 0
                        if center_length > 0
                            error('Error in part definition (%s).', type);
                        end
                        % The arguments' value is non-zero and is stored as center_length
                        center_length = varargin{i+1};
                    end
                end
            end
            varargin = [];
            varargin{1} = 'length';
            varargin{2} = center_length;
        end
    end

% Disabled. Needs to be fixed
%     velocity_average = sectional_velocity_average(wind_tunnel.crosssection_test_section, wind_tunnel.velocity_test_section, ...
%         diameter_in, diameter_out, ...
%         height_in, height_out, ...
%         width_in, width_out, ...
%         velocity_in, 'square');
    
    %% Set the part independend parameters
    new_part = struct( ...part.loss_coefficient
        'name', name, ... 
        'type', type, ...
        'crosssection_test_section', wind_tunnel.crosssection_test_section, ...
        'velocity_test_section', wind_tunnel.velocity_test_section, ...
        'height_in', height_in, ...
        'width_in', width_in, ...
        'height_out', height_out, ...
        'width_out', width_out, ...
        'diameter_in', diameter_in, ...
        'diameter_out', diameter_out, ...
        'diameter_average', diameter_average, ...
        'crosssection_in', crosssection_in, ...
        'crosssection_out', crosssection_out, ...
        'crosssection_average', crosssection_average, ...
        'velocity_in', velocity_in, ...
        'velocity_out', velocity_out, ...
        'velocity_average', velocity_average);
    
    %% Set the part specific parameters
        % Check type
    switch type
        case 'straight_part'
            required_options = struct('length',0);
        case 'fetch'
            required_options = struct('length', 0, 'height_testsection', 0);
        case 'honeycomb'
            required_options = struct('cell_length', 0, ...
                'cell_diameter', 0, 'cell_wall_thickness', 0, ...
                'material_roughness', 0);
        case 'screen'
            required_options = struct('wire_diameter', 0, ...
                'wire_roughness', 0, 'cell_diameter', 0);
        case 'corner'
            required_options = struct('chord', 0);
        case 'corner_downstream_testsection'
            required_options = struct('chord', 0);        
        case 'contraction'
            required_options = struct('shape', 0, ...
                'center_length', 0);                    % length = length along the center line
        case 'diffuser'
            required_options = struct('cross_section_shape', 0, ...
            'length_center_line', 0, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
        case 'diffuser_with_boundary_layer_control'
            required_options = struct( ...
            'length_center_line', 0, 'length_wall', 0); % Only fill in length_center_line OR length_wall, but NOT both!
        case 'inlet'
              required_options = struct('shape', 0); 
        case 'safetynet'
            required_options = struct();                % No additional options
        case 'sudden_expansion'
            required_options = struct();                % No aheight_in, width_in, height_out, width_outdditional options
        case 'outlet'
            required_options = struct();                % No additional options        
        % Wrong cases:
        case 'elevated_straight_part'
            error('Replace elevated_straight_part by fetch!');
        otherwise
            error('Wrong type definition (%s).', type);
    end
    
    
    %% Parse the arguments
    new_part = parse_arguments(new_part, required_options, varargin);
    
    %% Add the new part to the existing parts structure
    parts{length(parts)+1} = new_part;
end
