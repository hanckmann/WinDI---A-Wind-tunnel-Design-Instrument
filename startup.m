%%
% function startup()
%
% Run this file before using the windtunnel toolbox.
% Add all subdirectories to the working directory
%
% Copyright (c) 2012, 2013 All Right Reserved
% License : TBD
% Authors : Rinka van Dommelen,     Patrick Hanckmann
% E-mail  : rvdommelen@hotmail.com, hanckmann@gmail.com
% Version : WinDI, version 1
% Date    : June 20, 2012
%%

function startup()
% Run this file before using the windtunnel toolbox.
% Add all subdirectories to the working directory

    clear all;
    currPath = pwd;
    filePath = fileparts( mfilename('fullpath') );
    cd( filePath );

    add_all_paths_without_git();

    cd(currPath);
    
    disp('Startup finished');
end

%% Add all subdirectories to the working directory
function add_all_paths_without_git()
    % Get all recursive folders
    fullpath = genpath( pwd );

    % Split the folders using the ; seperator
    paths = regexp( fullpath, pathsep, 'split' );

    % Remove the .git folders
    index_of_used_paths = cellfun( @(x) isempty(x), strfind( paths, '.git' ) );
    paths = {paths{index_of_used_paths}};

    % Join all the path into one string using the ; seperator
    joined_paths = sprintf( '%s;', paths{:} );

    % Add all remaing folders to the working directory
    addpath( joined_paths );

end
