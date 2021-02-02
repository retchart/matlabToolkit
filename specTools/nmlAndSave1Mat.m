function [sgnl,eAxisOld,eAxisNew] = nmlAndSave1Mat(sgnl,caliParam,plotOrNot)
% 标准化matFileName指示的.mat文件中sgnl能谱矩阵
% 单列能谱无峰特征而合能谱有峰特征时宜使用本函数
%
% Inputs：
% sgnl: 待标准化的矩阵，每列为一个计数率能谱
% plotOrNot: 是否画图
% energyStep:能量bin的宽度（MeV）
% caliParam.E(1)~(n)用以拟合的多个能量
% caliParam.Ewin(i,1)~(i,2)第i个能峰所在的大致区间
% caliParam.EStep 能量步长(MeV)
% caliParam.maxE 最大能量(MeV)
%
% Outputs：
% sgnl： 标准化后能谱，列数与matFileName中一致，该能谱将保存至新的mat文件中
% eAxisOld: 标准化后能量轴
% eAxisNew: 标准化前能量轴
%

%% 刻度
[orgnSpecsgnl,nmlSpecsgnl] = ...
    nml1spec_v4(sum(sgnl,2),caliParam,plotOrNot);
eAxisOld = orgnSpecsgnl(:,1);
eAxisNew = nmlSpecsgnl(:,1);
%% 变换纵轴
sgnl = nmlmat(sgnl,eAxisOld,eAxisNew,caliParam.tPerFile);

end


function nmldMat = nmlmat(orgnSpecMat,orgnEaxis,nmlEaxis,tCol)
% specMat: 为逐列计数率能谱
% orgnEaxis: specMat 的能量横轴（单位：MeV）
% nmlEaxis: 标准化目标能量横轴（单位：MeV）
% nmlspecMat: 标准化逐列计数率能谱矩阵
% tCol: 每列的测量时长（单位：s）

%% 变换纵轴 cps/ch -> cps/energyBin
specMat = orgnSpecMat*(nmlEaxis(5,1)-nmlEaxis(4,1))/ ...
    (orgnEaxis(5,1)-orgnEaxis(4,1)); % Unit of spec: cps/enrgybin

%% 插值
nmldMat = zeros(size(nmlEaxis,1),size(specMat,2));
for i = 1:size(specMat,2)
    nmldMat(:,i) = spline(orgnEaxis,specMat(:,i),nmlEaxis);
end

%% 删除过小的值
nmldMat(find(nmldMat<(1/(size(specMat,2)*tCol)^2))) = 0;

end