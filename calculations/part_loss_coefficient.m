%%
% function part = part_loss_coefficient(part, settings)
%
% Calculates the pressure loss coefficient for the parts
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function part = part_loss_coefficient(part, settings)

    %% For diffuing and contracting parts we calculate the 'wall to center line' angles. These are the equivalent conical angles, and equivalent conical radius! based on A = pi * R^2
    switch part.type
        case 'contraction'
            part.radius_in      = sqrt((part.width_in * part.height_in) / pi);
            part.radius_out     = sqrt((part.width_out * part.height_out) / pi);
            [part.angle_radian, part.length_center_line] = wall_central_line_angle(part.radius_in, part.radius_out, 0, part.center_length);
            part.angle_radian   = -part.angle_radian;
            part.angle_degrees  = radian2degrees(part.angle_radian);
        case 'diffuser'
            part.radius_in      = sqrt((part.width_in * part.height_in) / pi);
            part.radius_out     = sqrt((part.width_out * part.height_out) / pi);
            [part.angle_radian, part.length_center_line] = wall_central_line_angle(part.radius_in, part.radius_out, part.length_wall, part.length_center_line);
            part.angle_degrees  = radian2degrees(part.angle_radian);
        case 'diffuser_with_boundary_layer_control'
            part.radius_in      = sqrt((part.width_in * part.height_in) / pi);
            part.radius_out     = sqrt((part.width_out * part.height_out) / pi);
            [part.angle_radian, part.length_center_line] = wall_central_line_angle(part.radius_in, part.radius_out, part.length_wall, part.length_center_line);
            part.angle_degrees  = radian2degrees(part.angle_radian);
    end
    
    if(isfield(part, 'angle_radian'))
        if (part.angle_radian < 0)
            error(['Angle is negative (' num2str(part.angle_radian) ')!']);
        end
    end

    %% Do nothing if the loss_coefficient has been provided as argument
    if(isfield(part, 'loss_coefficient'))
        return;
    end

    %% Check type and calculate the relevant information
    switch part.type
        case 'straight_part'    % reference Barlow 1999, Eckert 1978
            part.reynolds_number = reynolds_number(part.velocity_in, part.diameter_in, settings);
            part.friction_factor = friction_factor(part.reynolds_number, settings);
            part.loss_coefficient = part.friction_factor * part.length / part.diameter_in;
            
         case 'fetch'           % Gousseau 2009
            part.reynolds_number = reynolds_number(part.velocity_in, part.diameter_in, settings);
            part.friction_factor = friction_factor(part.reynolds_number, settings);
            part.loss_coefficient = (part.height_testsection / part.height_in)^2 - (part.height_testsection / part.height_out)^2;
            
        case 'honeycomb'        % reference Barlow 1999
            part.porosity = calc_porosity(part.cell_wall_thickness, part.cell_diameter, part.type);
            part.reynolds_number = reynolds_number(part.velocity_in, part.material_roughness, settings);
            lambda = calc_lambda(part.material_roughness, part.reynolds_number, part.cell_diameter);
            part.loss_coefficient = lambda * ((part.cell_length / part.cell_diameter) + 3) * (1 / part.porosity)^2 + ((1 / part.porosity) - 1)^2;
       
        case 'screen'           % reference Barlow 1999
            part.porosity = calc_porosity(part.wire_diameter, part.cell_diameter, 'honeycomb'); % Porosity only defined for honeycombs
            part.reynolds_number = reynolds_number(part.velocity_in, part.wire_diameter, settings);
            part.loss_coefficient_Re = calc_loss_Re(part.reynolds_number, part.type);
            part.loss_coefficient = part.wire_roughness * part.loss_coefficient_Re * (1 - part.porosity) + ((1 - part.porosity) / part.porosity)^2;
        
        case 'corner'           % reference Barlow 1999, Eckert 1978
            part.reynolds_number = reynolds_number(part.velocity_in, part.chord, settings);
            part.loss_coefficient = 0.1 + (4.55 / log10(part.reynolds_number)^2.58);
       
        case 'corner_downstream_testsection'
            part.reynolds_number = reynolds_number(part.velocity_in, part.chord, settings);
            part.loss_coefficient = 1.1 * (0.1 + (4.55 / log10(part.reynolds_number)^2.58));
        
        case 'contraction'      % reference Barlow 1999, Eckert 1978, pope 1966
            % Test is the provided shape is recognised
            if(not( strcmp( 'straight', part.shape) || strcmp( 'curved', part.shape)) )
                print_error(['Contraction shape (' part.shape ') not recognised (part: ' part.name ')!'], settings);
            end
            % Start pressure loss coeffcient calc
            part.reynolds_number = reynolds_number(part.velocity_average, part.diameter_average, settings);
            part.friction_factor = friction_factor(part.reynolds_number, settings);
            part.loss_coefficient = 0.32 * part.friction_factor * part.center_length / part.diameter_out;

            % A special case is valid for a straight contraction realstion
            % via reference Abdullah 2005, Bloomer 2000, Daly 1978 and Munson 2009
            if(strcmp( 'straight', part.shape))
               part.loss_coefficient = 0.045 + ((part.angle_degrees-45)* 1.66666666666667 * 0.001) ;
               if(part.loss_coefficient < settings.contraction.straight_minimum_loss_coefficient)
                   part.loss_coefficient = settings.contraction.straight_minimum_loss_coefficient;
               end
            end
            
        case 'diffuser'     % !!!!!!NOTE: UPDATED EQUATION FROM BARLOW, PRINTED EQUATION IN BARLOW 1999 IS INCORRECT!!!!!!
            % Test if the special case occurs of a diffuser with length=0
            if part.length_center_line == 0
                part.loss_coefficient = 0;
                return;
            end
            % Test if the provided shape is recognised
            if(not( strcmp( 'rectangle', part.cross_section_shape) || ...
                    strcmp( 'circle', part.cross_section_shape)) )
                print_error(['Cross section shape (' part.cross_section_shape ') not recognised (part: ' part.name ')!'], settings);
            end
            % Start loss calculation
            part.area_ratio = area_ratio(part.crosssection_in, part.crosssection_out);
            part.reynolds_number = reynolds_number(part.velocity_average, part.diameter_average, settings);
            part.friction_factor = friction_factor(part.reynolds_number, settings);
            [loss_coefficient, part.loss_friction, part.loss_e, part.loss_expansion] = calc_loss_diffusor(part.cross_section_shape, part.area_ratio, part.friction_factor, part.angle_radian, part.angle_degrees);
            loss_coefficient = min(loss_coefficient, settings.diffuser.max_loss_coefficient);
            part.loss_coefficient = loss_coefficient;
            
        case 'diffuser_with_boundary_layer_control'     % reference Rennels and Hudson 2012
            if(part.angle_degrees < settings.diffuser_with_boundary_layer_control.min_angle_degrees)
                print_error(['Angle in ' part.name ' (diffuser) smaller than ' num2str(settings.diffuser_with_boundary_layer_control.min_angle_degrees) ' degrees!'], settings);
            end
            part.loss_coefficient = 0.29 + (part.angle_degrees - 10) * 0.012;
            
        case 'safetynet'
            part.loss_coefficient = settings.safetynet.loss_coefficient;
            
        case 'sudden_expansion'                     % reference Cengel 2012, Munson 2009
            if ((part.height_in == part.height_out) && (part.width_in == part.width_out))
                part.loss_coefficient = 0;
            else
                %part.loss_coefficient = settings.sudden_expansion.loss_coefficient;
                part.loss_coefficient = 1 - (part.crosssection_in / part.crosssection_out)^2;
            end
            
        case 'outlet'
            part.loss_coefficient = settings.outlet.loss_coefficient;
            
        case 'inlet'  % reference bloomer 2000, Cengel 2012, Munson 1998, Nakayama 1998, Post 2011.
            if(strcmp( 'rounded', part.shape))
                part.loss_coefficient = 0.1 ;
            end
            if(strcmp( 'straight', part.shape))
                part.loss_coefficient = 0.5 ;
            end
            if(strcmp( 'duct_with_wall', part.shape))
                part.loss_coefficient = 0.8 ;
            end
            if(strcmp( 'duct', part.shape))
                part.loss_coefficient = 1 ;
            end
        otherwise
            error('Wrong type definition (%s).', part.type);
    end
end

%% Calculation functions

function lambda = calc_lambda(delta, Re_delta, cell_diameter)
    lambda = 0.375 * (delta / cell_diameter)^.4 * Re_delta^-.1;
end

function porosity = calc_porosity(cell_wall_thickness, cell_diameter, type)
    porosity = [];
    switch type
        case 'honeycomb'
            porosity = (1 - cell_wall_thickness * (1 / cell_diameter))^2;
        otherwise
            error('Wrong type definition (%s).', type);
    end
end

function loss_Re = calc_loss_Re(reynolds_number, type)
    loss_Re = [];
    switch type
        case 'screen'
            loss_Re = 0.785 * ((reynolds_number / 241) + 1)^-4 + 1.01;
        otherwise
            error('Wrong type definition (%s).', type);
    end
end


function [loss_coefficient, loss_friction, loss_e, loss_expansion] = calc_loss_diffusor(cross_section_shape, area_ratio, f, angle_radian, angle_degrees)
    
    % deel 1
    loss_friction = (1 - (1 / area_ratio^2)) * (f / (8 * sin(angle_radian)));

    % deel 2
    % Check type
    switch cross_section_shape
        case 'rectangle'
            if angle_degrees > 0 && angle_degrees <= 1.5
                loss_e = 0.096227 - 0.00415164 * angle_degrees; % Eckert
            else if angle_degrees > 1.5 && angle_degrees <= 5
                    loss_e = 0.122156 - 0.0458960 * angle_degrees + 0.02202816 * (angle_degrees)^2 - 0.003269152 * (angle_degrees)^3 - 0.0006144896 * (angle_degrees)^4 + 0.00027999008 * (angle_degrees)^5 - 0.000023373888 * (angle_degrees)^6; % Update Barlow
                    %loss_e = 0.122156 - 0.0229480 * 2*angle_degrees + 0.00550704 * (2*angle_degrees)^2 - 0.000408644 * (2*angle_degrees)^3 - 0.0000384056 * (2*angle_degrees)^4 + 0.00000874969 * (2*angle_degrees)^5 - 0.000000365217 * (2*angle_degrees)^6; % Eckert
                    %loss_e = 0.1222 - 0.04590 * angle_degrees + 0.02203 * angle_degrees^2 + 0.003269 * angle_degrees^3 - 0.0006145 * angle_degrees^4 - 0.00002800 * angle_degrees^5 + 0.00002337 * angle_degrees^6; % Barlow
                else if angle_degrees > 5
                        loss_e = -0.1321685 + 0.0586630 * angle_degrees; % Eckert / Barlow update
                        %loss_e = -0.01322 + 0.05866 * angle_degrees; % Barlow
                    else
                        error('Invalid angle provided (%s)', num2str(angle_degrees));
                    end

                end
            end
        case 'circle'
            if angle_degrees > 0 && angle_degrees <= 1.5
                loss_e = 0.1033 - 0.002389 * angle_degrees;
            else if angle_degrees > 1.5 && angle_degrees <= 5
                    loss_e = 0.1709 - 0.1170 * angle_degrees + 0.03260 * angle_degrees^2 + 0.001078 * angle_degrees^3 - 0.0009076 * angle_degrees^4 - 0.00001331 * angle_degrees^5 + 0.00001345 * angle_degrees^6;
                else if angle_degrees > 5
                        loss_e = -0.09661 + 0.04672 * angle_degrees;
                    else
                        error('Invalid angle provided (%s)', num2str(angle_degrees));
                    end

                end
            end
    end

    % deel 3
    loss_expansion = loss_e * ((area_ratio - 1) / area_ratio)^2;
    
    loss_coefficient = loss_friction + loss_expansion;
end
