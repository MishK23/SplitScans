%Map all .tif files from a folder into an array that can be used in other
%folders
myDir = uigetdir;
myFiles = dir(fullfile(myDir,'*.tif'));
