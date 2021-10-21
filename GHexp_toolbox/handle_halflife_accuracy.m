%% 分析特定峰在不同测量时间段的结果

clear;close all;
filename = 'st740.mat';load(filename);
if strncmp(filename,'st851',5)
    tirr = 4500; tcool = 62700; more = 600; n_flux = 6.04e6;% ST851
end
if strncmp(filename,'st827',5)
    tirr = 1783; tcool = 26640; more = 465; n_flux = 6.05e6;% ST851
end
if strncmp(filename,'st490',5)
    tirr = 2500; tcool = 24540; more = 355; n_flux = 6.03e6;% ST851
end
if strncmp(filename,'st740',5)
    tirr = 2445; tcool = 27180; more = 475; n_flux = 6.04e6;% ST851
end

pkch = [3119;7856;11096]; % 分析的峰所在大概道址,Au(411keV)，Br(1044,1475keV)
lambda = log(2)./[232761.6;127008;127008];% 核素半衰期s
eff = [0.04;0.04;0.04]; % 峰源探测效率
effbranch = [0.9562;0.28273;0.16597]; %产生伽马分支比
xs = [98.65;2.36;2.36]; % 中子俘获截面b
timeDet = [1,2,5,10,20,30,60,size(orgnSpec,2)]; % 分析哪些测量时间下的结果准确性
method_getnet = 3; % 计算峰净计数的方法，详见getnet.m


%% 有样品的第一个能谱序号
f=figure;
plot(sum(orgnSpec,1),'.-');xlabel('No.');ylabel('Total count');
title('Please enter the first activation spec No.');
nStart = input('Enter the first spec No. to be fit: ');
close(f);

%% 删起始的本底谱
sp = orgnSpec(:,nStart:end); % 计数率
t_livetime = t_livetime(nStart:end);
t_realtime = t_realtime(nStart:end);
t = t(nStart:end);
t = t-t(1); % 开始测量时刻
% sp:每列为待分析的原始能谱，t：每列的开始测量时刻
% t_realtime:测量实时间s，t_livetime：测量活时间s

%% 取峰区净计数
n_mat = cell(length(pkch),length(timeDet));
for j = 1:length(timeDet)
    n_col = floor(size(sp,2)/timeDet(j));
    [this_sp,~] = resizemat_cut(sp,[size(sp,1),n_col]);
    this_t = t(1:timeDet(j):end);
    [this_t_real,~] = resizemat_cut(t_realtime,[size(t_realtime,1),n_col]);
    [this_t_live,~] = resizemat_cut(t_livetime,[size(t_livetime,1),n_col]);
    this_t = this_t(1,1:length(this_t_real));
    for i = 1:length(pkch)
        n_mat{i,j}(:,1)=this_t;
        for k = 1:length(this_t)
            thisSpec = this_sp(:,k);
            area = getnet(thisSpec,pkch(i),method_getnet)/this_t_live(k)*this_t_real(k);
            n_mat{i,j}(k,2) = get_n(area,lambda(i), ...
                n_flux,tirr,tcool+this_t(k),this_t_real(k),xs(i),eff(i),effbranch(i));
            disp(['pkch i No.',num2str(i),'/',num2str(length(pkch)), ...
                'timeDet j No.',num2str(j),'/',num2str(length(timeDet)), ...
                'time k No.',num2str(k),'/',num2str(length(this_t))]);
        end
        
    end
end

save(['timeAccuracy-',filename],'eff','effbranch','lambda', ...
    'method_getnet','more','n_flux','n_mat','nStart','orgnSpec', ...
    'pkch','t','t_realtime','t_livetime','timeDet','tirr','xs');

function n = get_n(area,lambda,flux,tirr,tcool,tmeas,xs,eff,effbranch)
% 由峰净计数计算靶核数，area为经过死时间校正的测量时段内峰净计数

% 照射结束的活化核数    =O4/$I$2/M4/(EXP(-Q4*$K$1)-EXP(-Q4*($K$1+$M$1)))
n1 = area/eff/effbranch/(exp(-lambda*tcool)-exp(-lambda*(tcool+tmeas)));
% 靶核数   =R4*Q4/(P4*1E-24)/$K$2/(1-EXP(-Q4*$I$1))
n = n1*lambda/(xs*1e-24)/flux/(1-exp(-lambda*tirr));

end
