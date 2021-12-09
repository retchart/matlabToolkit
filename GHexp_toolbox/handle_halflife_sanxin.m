function [] = handle_halflife_sanxin(filename)
%% 分析特定峰在不同测量时间段的结果
load([filename,'.mat']);
load('neutronCali.mat');
rowrow = find(neutronCaliParam(:,1)==str2num(filename));
gradeRef = neutronCaliParam(rowrow,2);
mass = neutronCaliParam(rowrow,3);
param_neutronCali = neutronCaliParam(rowrow,4);
param_irr = neutronCaliParam(rowrow,5);
param_cool = neutronCaliParam(rowrow,6);
param_pkeff = neutronCaliParam(rowrow,7);
timeDet = [1,2,3,4,5,10,20,30,length(t)];
pkch = 1697;
lambda = log(2)./232761.6;% Au-198衰变常数/s
method_getnet = 1; % 计算峰净计数的方法，详见getnet.m

%% 选择研究的能谱区间
nStart = 1;
sp = orgnSpec(:,1:120); % 计数率
t_live = t_live(1:120);
t_real = t_real(1:120);
for i = 1:size(sp,2)
    sp(:,i)=sp(:,i)./t_live(i)*t_real(i);
end
t = t(1:120);

%% 微调峰道址
totalSpec = sum(orgnSpec,2);
for i = 1:length(pkch)
    tmp = totalSpec;tmp(1:pkch-10,:)=0;tmp(pkch+10:end,:)=0;
    [~,pkch(i)] = max(tmp);
end

%% 取峰区净计数
auIndex_mat = cell(length(pkch),length(timeDet));
for j = 1:length(timeDet) % 逐个单次测量时长
    n_col = floor(size(sp,2)/timeDet(j));
    [this_sp,~] = resizemat_cut(sp,[size(sp,1),n_col]);
    this_tList = t(1:timeDet(j):end);
    [this_t_real,~] = resizemat_cut(t_real,[size(t_real,1),n_col]);
    [this_t_live,~] = resizemat_cut(t_live,[size(t_live,1),n_col]);
    this_tList = this_tList(1,1:length(this_t_real));
    for i = 1:length(pkch) % 逐个峰
        auIndex_mat{i,j}(:,1)=this_tList;
        for k = 1:length(this_tList) % 逐个能谱处理
            thisSpec = this_sp(:,k);
            area = getnet(thisSpec,pkch(i),method_getnet);
            auIndex_mat{i,j}(k,2) = area/param_irr/param_cool/ ...
                (exp(-lambda(i)*this_tList(1,k))-exp(-lambda(i)*(this_tList(1,k)+this_t_real(1,k))))/ ...
                param_neutronCali/param_pkeff/mass;
            disp(['pkch No.i= ',num2str(i),'/',num2str(length(pkch)), ...
                ' Detection time No. j=',num2str(j),'/',num2str(length(timeDet)), ...
                ' time No. k=',num2str(k),'/',num2str(length(this_tList))]);
        end
        
    end
end

save(['GradeIndex-',filename,'-getnet',num2str(method_getnet)],'auIndex_mat','sp', ...
    't_real','t','t_live','neutronCaliParam','pkch','timeDet');

end