clear;close all;
dir1 = {'4857','gbw16'};
dirs = dir1;
for i = 1:length(dirs)
    readspeinfolder(dirs{i});
end
