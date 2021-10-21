function s = readlist(fileExp,varargin)
% 读取apg7400的list mode 模式形成的若干个txt文件，据输入参数输出能谱或list
% 保存能谱结构体
% list矩阵会很长，需要注意
% 目前不能读取ch0的数值
%
% INPUTS：
% fileExp: 文件名正则表达式
% 'sep'：s.list将拆为各道list
% 'spec': 计算各输入道能谱s.spec
% 'save': 保存
%
% OUTPUTS：
% s.list{i}: 第一列事件时刻(APG7400:ns)，第二列输入道，第三列道址
% s.spec{i}: ch1 第一列为道址，第二列计数
%
flag_sep = sum(strcmp(varargin,'sep')); % 是否将list拆为各自道
flag_spec = sum(strcmp(varargin,'spec')); % 是否计算各道能谱
dir1 = dir(fileExp);
allList = [];
tic;
for i = 1:length(dir1)
    disp(['Reading ',dir1(i).name,'(',num2str(i),'/',num2str(length(dir1)),')']);
    toc;
    allList = [allList;importdata(dir1(i).name)];
end
allList = sortrows(allList); % 按时刻从小到大排序
ch_low = min(allList(:,2));ch_high = max(allList(:,2));

if flag_spec || flag_sep
    for i = ch_low:ch_high
        s.list{i} = allList(find(allList(:,2)==i),:);
        maxCh = max(s.list{i}(:,3));
        j = 2;
        while j < maxCh % 寻找最大道址j
            j = j*2;
        end
        ss = histogram(s.list{i}(:,3),0:1:j);
        s.spec{i} = [ss.BinEdges(2:end)',ss.Values'];
    end
else
    s.list = allList;
end

if ~flag_sep
    s.list = allList; % 合并list
end

if sum(strcmp(varargin,'save'))
    saveName = strsplit(dir1(1).name,'.');
    saveName = strsplit(saveName{1},'-');
    disp('Saving to .mat file...');
    save(saveName{1},'s');
end
disp('Finish reading list data');
end % of the function
