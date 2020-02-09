function [orgnSpec,nmldSpec] = nml1spec(nameOrSpec,measureTime,energyStep,plotOrNot)
% 标准化出束能谱：以511keV和2223keV刻度能谱，统一横轴
% nameOrSpec: 单列数值矩阵能谱，或spe格式能谱文件名（单位：计数/道）
% measureTime: 测量时长（单位：s）
% originalSpec: 若nameOrSpec为文件名，则为获取的单列能谱，若为矩阵则为横向和
% normalizedSpec: 双列能谱，第一列MeV能量，第二列计数率
% REFERENCE: C-12 4.945;
maxEnergyRange = 12; % MeV
energyAxis = (energyStep:energyStep:maxEnergyRange)';
PEAKENERGY_1 = 4.945;
PEAKENERGY_2 = 2.223;
PEAKRANGE_1 = [598,647];
PEAKRANGE_2 = [254,307];

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
[~,~,~,~,~,peak_511,~] = fitPeak((PEAKRANGE_1(1):PEAKRANGE_1(2))',spec(PEAKRANGE_1(1):PEAKRANGE_1(2))/measureTime,plotOrNot);
[~,~,~,~,~,peak_H2223,~] = fitPeak((PEAKRANGE_2(1):PEAKRANGE_2(2))',spec(PEAKRANGE_2(1):PEAKRANGE_2(2))/measureTime,plotOrNot);

%% 刻度
originalEScale = (PEAKENERGY_2-PEAKENERGY_1)*((1:size(spec,1))'-peak_511)/(peak_H2223-peak_511)+PEAKENERGY_1;
orgnSpec = spec/measureTime; % Unit of spec: cps/ch
orgnSpec = orgnSpec*(energyAxis(5,1)-energyAxis(4,1))/ ...
    (originalEScale(5,1)-originalEScale(4,1)); % Unit of spec: cps/enrgybin
orgnSpec = [originalEScale,orgnSpec];

%% 插值
nmldSpec = spline(orgnSpec(:,1),orgnSpec(:,2),energyAxis);
nmldSpec(find(nmldSpec<1/measureTime^2))=0; % 测量总时长都无计数对应的计数率为1/measureTime^2
nmldSpec = [energyAxis,nmldSpec];
if plotOrNot
    figure;
    semilogy(orgnSpec(:,1),orgnSpec(:,2),'o');hold on;grid on;
    semilogy(nmldSpec(:,1),nmldSpec(:,2),'.-');
    xlabel('Energy(MeV)');ylabel(['Count rate(cps/',num2str(energyStep),'MeV)']);
    legend('Original','Normalized');
end

% disp(['原谱总计数率：',num2str(sum(spec)/measureTime),'cps']);
% disp(['标准化谱总计数率:',num2str(sum(normalizedSpec(:,2))),'cps']);

end % of function
