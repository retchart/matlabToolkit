function [originalSpec,normalizedSpec] = quicknml(nameOrSpec,measureTime,cali_table,energyStep,plotOrNot)
%

energyAxis = (energyStep:energyStep:12)';

% 导入文件
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

% 刻度
if size(cali_table,2)==2
    ch_1 = cali_table(1,1);
    ch_2 = cali_table(2,1);
    energy_1 = cali_table(1,2);
    energy_2 = cali_table(2,2);
    originalEScale = (energy_2-energy_1)*((1:size(spec,1))'-ch_1)/(ch_2-ch_1)+energy_1; %换横轴为能量
elseif size(cali_table,2)==1
    originalEScale = cali_table;
end
originalSpec = spec/measureTime; % Unit of spec: cps/ch
originalSpec = originalSpec*(energyAxis(5,1)-energyAxis(4,1))/ ...
    (originalEScale(5,1)-originalEScale(4,1)); % Unit of spec: cps/enrgybin
originalSpec = [originalEScale,originalSpec];

% 插值
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


end