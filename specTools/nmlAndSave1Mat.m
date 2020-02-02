function sgnl = nmlAndSave1Mat(matFileName,plotOrNot,energyStep)
load(matFileName);

%% 刻度能谱
[orgnSpecsgnl,nmlSpecsgnl] = nml1spec(sum(sgnl,2),size(sgnl,2),energyStep,0);
if plotOrNot
    figure;
    semilogy(nmlSpecsgnl(:,1),nmlSpecsgnl(:,2),'.-');hold on;grid on;
    title(matFileName);
    xlabel('Energy(MeV)');
    ylabel(['Count rate(cps/',num2str(nmlSpecsgnl(2,1)-nmlSpecsgnl(1,1)),'MeV']);
end

%% 标准化
sgnl = nmlMats(sgnl,orgnSpecsgnl(:,1),nmlSpecsgnl(:,1));

%% 保存
save([matFileName(1:length(matFileName)-4),'-step',num2str(energyStep),'MeV-nml.mat',],'sgnl');

end


function nmlspecMat = nmlMats(orgnSpecMat,orgnEaxis,nmlEaxis)
% specMat: 为逐列计数率能谱
% orgnEaxis: specMat 的能量横轴（单位：MeV）
% nmlEaxis: 标准化目标能量横轴（单位：MeV）
% nmlspecMat: 标准化逐列计数率能谱矩阵

%% 变换纵轴 cps/ch -> cps/energyBin
specMat = orgnSpecMat*(nmlEaxis(5,1)-nmlEaxis(4,1))/ ...
    (orgnEaxis(5,1)-orgnEaxis(4,1)); % Unit of spec: cps/enrgybin

%% 插值
nmlspecMat = zeros(size(nmlEaxis,1),size(specMat,2));
for i = 1:size(specMat,2)
    nmlspecMat(:,i) = spline(orgnEaxis,specMat(:,i),nmlEaxis);
end

%% 删除过小的值
nmlspecMat(find(nmlspecMat<(1/size(specMat,2)^2))) = 0;

%% 作图及输出检验信息
% colcol = 5;
% figure; 
% semilogy(orgnEaxis,specMat0(:,colcol),'o');hold on;grid on;
% semilogy(nmlEaxis,nmlspecMat(:,colcol),'.-');
% xlabel('Energy(MeV)');
% ylabel(['Count rate(cps/',num2str(nmlEaxis(2,1)-nmlEaxis(1,1)),'MeV']);
% title('Normalized 1s spectrum');

% disp(['原1s谱总计数率：',num2str(sum(specMat(:,colcol))),'cps']);
% disp(['标准化1s谱总计数率：',num2str(sum(nmlspecMat(:,colcol))),'cps'])
end
