function s = readlist2(fileExp,saveName)
% 读取apg7400的list mode 模式形成的若干个txt文件，合并为3列矩阵，并分析能谱
% 相比readlist,拆分了不同输入道的list
% 保存能谱结构体
% list矩阵会很长，需要注意
% 目前不能读取ch0的数值,APG7400也没有第0道
%
% INPUTS：
% fileExp: 文件名正则表达式
%
% OUTPUTS：
% s.list{1}: ch1 第一列事件时刻(ns)，第二列输入道，第三列道址
% s.spec{1}: ch1 第一列为道址，第二列计数

dir1 = dir(fileExp); % 可能有多个txt文件
s.list = {};
s.spec = {};
allList = [];
tic;
disp('Start reading');
for i = 1:length(dir1)
    allList = [allList;importdata(dir1(i).name)];
    disp(['Finish reading ',dir1(i).name,'(',num2str(i),'/',num2str(length(dir1)),')']);
    toc;
end
ch_low = min(allList(:,2));ch_high = max(allList(:,2));
for i = ch_low:ch_high
    s.list{i} = allList(find(allList(:,2)==i),:);
    maxCh = max(s.list{i}(:,3));
    j = 2;
    while j < maxCh % 寻找能谱最大道址
        j = j*2;
    end
    ss = histogram(s.list{i}(:,3),0:1:j);
    s.spec{i} = [ss.BinEdges(2:end)',ss.Values'];
end
disp('Saving list data to .mat file...');
toc;
save(saveName,'s');
disp('Finish reading list data');
end % of the function
