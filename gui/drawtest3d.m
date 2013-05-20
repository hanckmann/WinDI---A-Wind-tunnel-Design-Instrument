%%
% function drawtest3d()
%
% Testing how to draw a wind tunnel in 3D (unfinished project).
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : May 01, 2013
%%

function drawtest3d()
%  rectangle('Position', [x y w h]) adds a rectangle at the specified position.


voxel([2 3 4],[1 2 3],'r',0.7);
voxel([3 4 5],[2 3 4],'r',0.7);
voxel([3 4 5],[4 4 7],'r',0.7);

% view(3)

end
