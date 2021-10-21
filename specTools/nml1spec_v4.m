function [orgnSpec,nmldSpec] = ...
    nml1spec_v4(nameOrSpec,caliParam,plotOrNot)
% 高斯拟合定位峰值并标准化gamma能谱
% 
% INPUTS：
% nameOrSpec: 单列数值矩阵能谱，或spe格式能谱文件名（单位：计数/道）
% caliParam.E(1,1)~(n,1)用以拟合的多个能量
% caliParam.Ewin(i,1)~(i,2)第i个能峰所在的大致道址区间 
% caliParam.EStep 能量步长(MeV)
% caliParam.maxE 最大能量(MeV)
% caliParam.tPerFile 每个文件的测量时长s，仅用于删除过小拟合值
%
% OUTPUTS:
% orgnSpec: 若nameOrSpec为文件名，则为获取的单列能谱，若为矩阵则为横向和
% nmldSpec: 双列能谱，第一列MeV能量，第二列计数率
%
% REFERENCE: C-12 4.945;
%            caliParam.tPerFile = 300;
%            caliParam.E(1,1) = 1.46082;caliParam.Ewin(1,:) = [2116-10,2116+10];
%            caliParam.E(2,1) = 2.614511;caliParam.Ewin(2,:) = [3782-10,3782+10];
%            caliParam.EStep = 0.0001; % MeV
%            caliParam.maxE = 12;

energyAxis = (caliParam.EStep:caliParam.EStep:caliParam.maxE)';
%% 导入数据
if ischar(nameOrSpec) % 是文件
    spec = readspe(nameOrSpec);
else %是能谱矩阵
    spec = nameOrSpec;
end

%% 作原始数据图
% if plotOrNot
%     semilogy(spec,'.-');xlabel('Channel');ylabel('Count rate(count/ch)');grid on;
% end

%% 寻峰(使用计数率图)
peakCh = zeros(length(caliParam.E),1);
if plotOrNot 
    h=figure;
    jFrame = get(h,'JavaFrame');
    set(jFrame,'Maximized',1);
end
for i = 1:length(caliParam.E)
    if plotOrNot
    subplot(ceil(length(caliParam.E)/2),2,i);
    end
    winwin = caliParam.Ewin(i,1):caliParam.Ewin(i,2);
    [~,~,~,peakCh(i),~] = fitPeak(winwin',sum(spec(winwin),2)/size(spec,2),plotOrNot);
end
pause(0.5);
%% 刻度
% originalEScale = (PeakE2-PeakE1)*((1:size(spec,1))'-peakCh)/(peak_2-peakCh)+PeakE1;
[p,~] = polyfit(peakCh,caliParam.E,1);
originalEScale = polyval(p,(1:size(spec,1))');
if plotOrNot
figure;
plot((1:size(spec,1))',originalEScale,'-');hold on;
plot(peakCh,caliParam.E,'r+');
xlabel('Channel');ylabel('Energy(MeV)');
end

%% 变换纵轴 cps/ch -> cps/energyBin
orgnSpec = spec/size(spec,2); % Unit of spec: cps/ch
orgnSpec = orgnSpec*(energyAxis(5,1)-energyAxis(4,1))/ ...
    (originalEScale(5,1)-originalEScale(4,1)); % Unit of spec: cps/enrgybin
orgnSpec = [originalEScale,orgnSpec];

%% 插值
nmldSpec = spline(orgnSpec(:,1),orgnSpec(:,2),energyAxis);
nmldSpec(find(nmldSpec<1/(size(spec,2)*caliParam.tPerFile)^2))=0; % 整个测量时长都无计数对应的计数率为1/measureTime^2
nmldSpec = [energyAxis,nmldSpec];
if plotOrNot
    figure;
    semilogy(orgnSpec(:,1),orgnSpec(:,2),'o');hold on;grid on;
    semilogy(nmldSpec(:,1),nmldSpec(:,2),'.-');
    xlabel('Energy(MeV)');ylabel(['Count rate(cps/',num2str(caliParam.EStep),'MeV)']);
    legend('Original','Normalized');
    xlim([0,caliParam.maxE]);
end

end % of function
