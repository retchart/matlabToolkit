clear; close all;
foldersNameExp = 'g*';
a=dir(foldersNameExp);
for i=1:size(a,1)
    if a(i).isdir==1
        [spec,sgnl] = getMat(a(i).name);
    end
end
