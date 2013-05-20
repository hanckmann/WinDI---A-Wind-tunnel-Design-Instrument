%%
% function drawtest()
%
% Testing how to draw a wind tunnel (unfinished project).
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%


% Draw test

function drawtest()
%  rectangle('Position', [x y w h]) adds a rectangle at the specified position.

% 4 | 1
%-------
% 3 | 2

q = 1;

center_connect = [0, 0];

%% blok
width  = 2.5;
height = 3.5;
[center_connect q] = new_block(center_connect, width, height, q);
[center_connect q] = new_block(center_connect, width, height, q);
[center_connect q] = new_corner(center_connect, width, height, q);
[center_connect q] = new_block(center_connect, width, height, q);
[center_connect q] = new_block(center_connect, width, height, q);
[center_connect q] = new_corner(center_connect, width, height, q);
[center_connect q] = new_block(center_connect, width, height, q);
[center_connect q] = new_block(center_connect, width, height, q);
[center_connect q] = new_block(center_connect, width, height, q);
[center_connect q] = new_block(center_connect, width, height, q);
[center_connect q] = new_corner(center_connect, width, height, q);
[center_connect q] = new_block(center_connect, width, height, q);
[center_connect q] = new_block(center_connect, width, height, q);
[center_connect q] = new_corner(center_connect, width, height, q);
[center_connect q] = new_block(center_connect, width, height, q);


end

function [center_connect q] = new_block(center_connect, width, height, q)
    rectangle('Position',[center_connect, width, height]);
    center_connect = new_center_connect(center_connect, width, height, q);
end

function [center_connect q] = new_corner(center_connect, width, height, q)
    rectangle('Position',[center_connect, width, height]);
    q = q + 1;
    if q > 4
        q = 1;
    end
    center_connect = new_center_connect(center_connect, width, height, q);
end

function center_connect = new_center_connect(center_connect, width, height, q)
    switch q
        case 1
            center_connect = [center_connect(1) + width, center_connect(2)];
        case 2
            center_connect = [center_connect(1), center_connect(2) - height];
        case 3
            center_connect = [center_connect(1) - width, center_connect(2)];
        case 4
            center_connect = [center_connect(1), center_connect(2) + height];
        otherwise
            error('Wrong quadrant');
    end
end
