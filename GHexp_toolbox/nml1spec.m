function [originalSpec,normalizedSpec] = nml1spec(nameOrSpec,measureTime,energyStep,plotOrNot)
% 标准化出束能谱：以511keV和2223keV刻度能谱，统一横轴
% nameOrSpec: 单列数值矩阵能谱，或spe格式能谱文件名（单位：计数/道）
% measureTime: 测量时长（单位：s）
% originalSpec: 若nameOrSpec为文件名，则为获取的单列计数能谱，若为矩阵则为横向和
% normalizedSpec: 双列能谱，第一列MeV能量，第二列计数率

maxEnergyRange = 12; % MeV
energyAxis = (energyStep:energyStep:maxEnergyRange)';
PEAKRANGE_511 =  [27,50]; %[70,120]; 
PEAKRANGE_2223 = [137,174]; %[330,400]; 
%% 导入数据
if ischar(nameOrSpec) % 是矩阵
    specStartStr = '$DATA:';
    fid = fopen(nameOrSpec,'r');
    for i =1:2100
        dataRow = fgetl(fid);
        if strncmp(dataRow,specStartStr,6)
            specStartRow = i;
            break;
        end
    end
    fclose(fid);
    fileData = importdata(nameOrSpec,'',specStartRow+1);
    spec = fileData.data;% 无刻度单列能谱，纵坐标计数count/ch
else %是能谱矩阵
    spec = sum(nameOrSpec,2);
end

%% 作原始数据图
if plotOrNot
figure;
semilogy(spec,'o-');xlabel('Channel');ylabel('Count rate(count/ch)');grid on;
end

%% 寻峰(使用计数率图)
[~,~,~,~,~,peak_511,~] = fitPeak((PEAKRANGE_511(1):PEAKRANGE_511(2))',spec(PEAKRANGE_511(1):PEAKRANGE_511(2))/measureTime,plotOrNot);
[~,~,~,~,~,peak_H2223,~] = fitPeak((PEAKRANGE_2223(1):PEAKRANGE_2223(2))',spec(PEAKRANGE_2223(1):PEAKRANGE_2223(2))/measureTime,plotOrNot);

%% 刻度
originalEScale = (2.223-0.511)*((1:size(spec,1))'-peak_511)/(peak_H2223-peak_511)+0.511;
originalSpec = spec/measureTime; % Unit of spec: cps/ch
originalSpec = originalSpec*(energyAxis(5,1)-energyAxis(4,1))/ ...
    (originalEScale(5,1)-originalEScale(4,1)); % Unit of spec: cps/enrgybin
originalSpec = [originalEScale,originalSpec];

%% 插值
normalizedSpec = spline(originalSpec(:,1),originalSpec(:,2),energyAxis);
normalizedSpec(find(normalizedSpec<1/measureTime^2))=0; % 测量总时长都无计数对应的计数率为1/measureTime^2
normalizedSpec = [energyAxis,normalizedSpec];
if plotOrNot
    figure;
    semilogy(originalSpec(:,1),originalSpec(:,2),'o');hold on;grid on;
    semilogy(normalizedSpec(:,1),normalizedSpec(:,2),'.-');
    xlabel('Energy(MeV)');ylabel(['Count rate(cps/',num2str(energyStep),'MeV)']);
    legend('Original','Normalized');
end

% disp(['原谱总计数率：',num2str(sum(spec)/measureTime),'cps']);
% disp(['标准化谱总计数率:',num2str(sum(normalizedSpec(:,2))),'cps']);

end % of function nml1spec
