%% goGammaCoincidence
%% 设置初始值
P0 = [0,0,0]; % source position
SIMULATION_N = 1e7;
MULTIPOLE_ORDER_1 = 1; % 1 for dipole, 2 for quadrupole
MULTIPOLE_ORDER_2 = 1;
det1Param.dis = 6.35;
det1Param.radius = 6.35;
det2Param.dis = -6.35;
det2Param.radius = 6.35;


%% 生成极化方向
%
% REFERENCES:
% https://mathworld.wolfram.com/SpherePointPicking.html?utm_source=
% wechat_session&utm_medium=social&utm_oi=656254871502721024
%
% Muller, M. E. "A Note on a Method for Generating Points Uniformly 
% on N-Dimensional Spheres." Comm. Assoc. Comput. Mach. 2, 19-20, Apr. 1959.

pd = randn(SIMULATION_N,3);
param = sqrt(pd(:,1).^2+pd(:,2).^2+pd(:,3).^2);
pd = pd./param; % unitization
clearvars param;

%% 生成伽马与极化方向夹角
% 假设产生两个伽马时极化方向未变，每个伽马与极化方向的夹角满足勒让德多项式分布
% 
% REFERENCES:
% Krane K S, Halliday D. Introductory nuclear physics[M]. 1987.330.
% 
[theta1] = randLPangle(1,SIMULATION_N);
[theta2] = randLPangle(1,SIMULATION_N);

%% 生成gamma可能方向（三维空间圆）
% 
% 
% REFERENCES:
% https://blog.csdn.net/dongzhe8/article/details/85564283
% 
v1 = gen3Ddirection(pd,theta1);
v2 = gen3Ddirection(pd,theta2);

% 下面是测试代码
% v1 = randn(SIMULATION_N,3);
% param = sqrt(v1(:,1).^2+v1(:,2).^2+v1(:,3).^2);
% v1 = v1./param; % unitization
% clearvars param;
% v2 = randn(SIMULATION_N,3);
% param = sqrt(v2(:,1).^2+v2(:,2).^2+v2(:,3).^2);
% v2 = v2./param; % unitization
% clearvars param;

%% 判断gamma是否到达探测器
% 探测器参数该怎么给呢？
% 
% 
hitFlag1 = hitornot(P0,v1,det1Param);
hitFlag2 = hitornot(P0,v2,det2Param);

%% 统计结果
% 
% 
n_yy = sum(hitFlag1 & hitFlag2);
n_yn = sum(hitFlag1 & ~hitFlag2);
n_ny = sum(~hitFlag1 & hitFlag2);
n_nn = sum(~hitFlag1 & ~hitFlag2);

disp(['P_yy = ',num2str(n_yy/SIMULATION_N)]);
disp(['P_yn = ',num2str(n_yn/SIMULATION_N)]);
disp(['P_ny = ',num2str(n_ny/SIMULATION_N)]);
disp(['P_nn = ',num2str(n_nn/SIMULATION_N)]);

%% 展示几何效率
% 顶角为2*theta的圆锥对应的立体角为2*pi*(1-cos(theta))
sr1 = 2*pi*(1-cos(atan(abs(det1Param.radius/det1Param.dis))));
sr2 = 2*pi*(1-cos(atan(abs(det2Param.radius/det2Param.dis))));

% sr1 = 2*pi*(1-cos(pi/4));
% sr2 = 2*pi*(1-cos(pi/4));

disp(['Geometric efficiency P1:',num2str(sr1/(4*pi))]);
disp(['Geometric efficiency P2:',num2str(sr2/(4*pi))]);
disp(['P1*P2=',num2str(sr1*sr2/16/pi/pi), ...
    ' should be equal to P_yy=',num2str(n_yy/SIMULATION_N)]);
