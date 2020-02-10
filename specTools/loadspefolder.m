function seq = loadspefolder(folderName,displayOrNot)
% Read a folder of ".spe" spectrum to a single variable
% which every column is a original spectrum
%
% Outputs:
% folderName: folder name, only ".spe" files should be inside
% displayOrNot: show the waitbar or not. 
%
% Inputs:
% seq: each column is a original spectrum from single ".spe" file
%
% Author: yxtccty
% Date: 2020FEB10

dir1=dir(folderName);
seq=[];
if displayOrNot
    f = waitbar(0,['Loading from folder ',folderName]);
end
for i = 3:size(dir1,1)
    if exist('specFirstRowNo','var')
        [thisSpec,specFirstRowNo] = ...
            load1spe([folderName,'\',dir1(i).name],specFirstRowNo);
        seq = thisSpec;
    else
        [thisSpec,specFirstRowNo] = ...
            load1spe([folderName,'\',dir1(i).name]);
    end
    seq = [seq,thisSpec]; 
    % It's faster than pre allocated memory on my PC, WHY?
    if displayOrNot
        waitbar(i/size(dir1,1),f,['Loading ',num2str(i), ...
            '/',num2str(size(dir1,1)),' from folder ',folderName]);
    end
end

end % of the function