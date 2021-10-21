%% 模拟伽马探测器对不同能量单能伽马射线的总效率及峰效率

% 使用方法：
% 1. 修改tplt.tplt中的源探几何及描述
% 2. 修改autoRunPeakEff中paramList，nps，tpltFileName
% 3. 直接运行autoRunPeakEff即可（自动支持linux和pc）

% effCurve: 能量（MeV) 总效率 总效率绝对误差 峰效率 峰效率绝对误差
close all;clear;
paramList = (0.1:0.1:9)'; % MeV
nps = 1e5;
tpltFileName = 'ccrt.tplt';
effCurve = zeros(size(paramList,1),5);
% 能量（MeV) 总效率 总效率绝对误差 峰效率 峰效率误差
effCurve(:,1)=paramList;
onlyRead = 1; % 只读取output文件而不运行MCNP

if ~onlyRead
    delete('*.i');delete('*.o');delete('*.r');
end

for i = 1:size(paramList,1)
    disp('---------------------------------------------');
    disp(['Current: var1=',num2str(paramList(i,1)),'(',num2str(i), ...
        '/',num2str(size(paramList,1)),')']);
    if ~onlyRead
        workName = [num2str(i),'.i'];
        geninput(tpltFileName,workName,[paramList(i,:),nps]);
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
    delete([num2str(i),'.r']);
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

