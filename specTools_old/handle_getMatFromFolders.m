clear; close all;
a=dir;
for i=3:size(a,1)
    if a(i).isdir==1
        [spec,sgnl] = getMat(a(i).name);
    end
end
