function [orgnSpec,nmldSpec] = ...
    nml1spec_v3(nameOrSpec,measureTime,energyStep,plotOrNot, ...
    PeakE1,PeakRange1,PeakE2,PeakRange2)
% 标准化出束能谱：以511keV和2223keV刻度能谱，统一横轴
% nameOrSpec: 单列数值矩阵能谱，或spe格式能谱文件名（单位：计数/道）
% measureTime: 测量时长（单位：s）
% originalSpec: 若nameOrSpec为文件名，则为获取的单列能谱，若为矩阵则为横向和
% normalizedSpec: 双列能谱，第一列MeV能量，第二列计数率
% REFERENCE: C-12 4.945;
% [orgnSpec,nmldSpec]=nml1spec_v2(nameOrSpec,600,0.01,1,0.478,[65,79],2.223,[300,359])

maxEnergyRange = 12; % MeV
energyAxis = (energyStep:energyStep:maxEnergyRange)';
%% 导入数据
if ischar(nameOrSpec) % 是文件
    spec = readspe(nameOrSpec);
else %是能谱矩阵
    spec = sum(nameOrSpec,2);
end

%% 作原始数据图
if plotOrNot
    h=figure;subplot(221);
    jFrame = get(h,'JavaFrame');
    set(jFrame,'Maximized',1);
    semilogy(spec,'.-');xlabel('Channel');ylabel('Count rate(count/ch)');grid on;
end

%% 寻峰(使用计数率图)
if plotOrNot
    subplot(223);
end
[~,~,~,~,~,peak_1,~] = fitPeak((PeakRange1(1):PeakRange1(2))',spec(PeakRange1(1):PeakRange1(2))/measureTime,plotOrNot);
if plotOrNot
    subplot(224);
end
[~,~,~,~,~,peak_2,~] = fitPeak((PeakRange2(1):PeakRange2(2))',spec(PeakRange2(1):PeakRange2(2))/measureTime,plotOrNot);
%% 刻度
originalEScale = (PeakE2-PeakE1)*((1:size(spec,1))'-peak_1)/(peak_2-peak_1)+PeakE1;
orgnSpec = spec/measureTime; % Unit of spec: cps/ch
orgnSpec = orgnSpec*(energyAxis(5,1)-energyAxis(4,1))/ ...
    (originalEScale(5,1)-originalEScale(4,1)); % Unit of spec: cps/enrgybin
orgnSpec = [originalEScale,orgnSpec];

%% 插值
nmldSpec = spline(orgnSpec(:,1),orgnSpec(:,2),energyAxis);
nmldSpec(find(nmldSpec<1/measureTime^2))=0; % 测量总时长都无计数对应的计数率为1/measureTime^2
nmldSpec = [energyAxis,nmldSpec];
if plotOrNot
    subplot(222);
    semilogy(orgnSpec(:,1),orgnSpec(:,2),'o');hold on;grid on;
    semilogy(nmldSpec(:,1),nmldSpec(:,2),'.-');
    xlabel('Energy(MeV)');ylabel(['Count rate(cps/',num2str(energyStep),'MeV)']);
    legend('Original','Normalized');
    xlim([0,maxEnergyRange]);
    pause(0.5);
end

end % of function
