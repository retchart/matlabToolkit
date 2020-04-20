clear; close all;
folderNameExp = 'APR16-P33*';
a=dir(folderNameExp);
for i=1:size(a,1)
    if a(i).isdir==1
        [spec,sgnl] = getMat(a(i).name);
    end
end
