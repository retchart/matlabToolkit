%% 模拟伽马探测器对不同能量单能伽马射线的总效率及峰效率

% 使用方法：
% 1. 修改tplt.tplt中的源探几何及描述
% 2. 修改autoRunPeakEff中paramList，nps，tpltFileName
% 3. 直接运行autoRunPeakEff即可（自动支持linux和pc）

% effCurve: 能量（MeV) 总效率 总效率绝对误差 峰效率 峰效率绝对误差

close all;clear;
% delete('*.i');delete('*.o');delete('*.r');
tpltFileName = 'tplt.tplt';
onlyWrite = 0; % 只制作输入文件而不运行MCNP
onlyRead = 0; % 只读取output文件而不运行MCNP

radius = [1:5,10,15,20,30,40]';
height = [1:5,5.5,6,10,15,20,30,40]';
density = [0.2:0.1:3]';
energy = [0.2,0.41,0.6:0.2:6]'; % MeV

radius = 1.1111;
height = 2.222;
density = 3.333;
energy = 4.444; % MeV

%% 制作paramList
lengthList = length(radius)*length(height)*length(density)*length(energy);
paramList = zeros(lengthList,4);
j=1;
for i1 = 1:length(radius)
    for i2 = 1:length(height)
        for i3 = 1:length(density)
            for i4 = 1:length(energy)
                paramList(j,:)= [radius(i1),height(i2),density(i3),energy(i4)];
                j = j+1;
            end
        end
    end
end

%% 申请结果变量effCurve内存空间
% 能量（MeV) 总效率 总效率绝对误差 峰效率 峰效率误差
effCurve = zeros(size(paramList,1),5);

%% 制作输入文件
for i = 1:size(paramList,1)
    geninput(tpltFileName,[num2str(i),'.i'],paramList(i,:));
end
if onlyWrite
    return;
end

%% 逐文件运行
for i = 1:size(paramList,1)
    disp('---------------------------------------------');
    disp(['Processing: ',num2str(i),'/',num2str(size(paramList,1)), ...
        ' (',num2str(100*i/size(paramList,1)),'%)']);
    if ~onlyRead
        disp(['MCNP start: ',datestr(now)]);
        if isunix
            [~,~]=system(['mpirun.lsf mcnp5.mpi.impi_intel i=',num2str(i), ...
                '.i o=',num2str(i),'.o r=',num2str(i),'.r p=',num2str(i),'.p']);
        else
            [~,~]=system(['mcnp5 i=',num2str(i),'.i o=',num2str(i),'.o r=', ...
                num2str(i),'.r p=',num2str(i),'.p']);
        end
        disp(['MCNP finish: ',datestr(now)]);
    end
    [thisSpec,summary] = readOutput([num2str(i),'.o']);
    effCurve(i,2) = summary(1,1);
    effCurve(i,3) = summary(1,2);effCurve(i,3)=effCurve(i,3)*effCurve(i,2);
    % fullEnergyCh = max(find(thisSpec(:,2)~=0)); % 全能所在位置
    [~,fullEnergyCh] = min(abs(thisSpec(:,1)-paramList(i,1)));
    effCurve(i,4) = thisSpec(fullEnergyCh,2);
    effCurve(i,5) = thisSpec(fullEnergyCh,3);
    effCurve(i,5) = effCurve(i,5)*effCurve(i,4);
    if ~onlyRead
        delete([num2str(i),'.r']);
    end
    save('effResult');
    disp(['Success: ',num2str(paramList(i,1)),'MeV (',num2str(i), ...
        '/',num2str(size(paramList,1)),')',datestr(now)]);
end
if ispc
    figure;
    errorbar(effCurve(:,1),effCurve(:,4),effCurve(:,5),'-');
    hold on;
    xlabel('Energy(MeV)');ylabel('Peak Efficiency');
end

disp('==========Project done=============');

