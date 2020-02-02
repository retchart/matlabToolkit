function [FoM,stdFoM] = sbrs_netv2(spec,tpltSpec,roi)
% 尝试实现 Heider 提出的SBRS能谱处理方法
% 论文：Signature-based radiation scanning using radiation interrogation to detect explosives
% spec:N列实测能谱，第一列为air谱，其它列为样品-air谱
% tpltSpec：M列模板谱，第一列为air谱，要求与spec统一纵轴
% roi：与能谱道数一致的单列向量
%
% FoM：M行N列相似度指标,每列代表每能谱和1~M个模板的相似度
% stdFoM:M行N列相似度指标,每列代表每能谱和1~M个模板的相似度标准差
% 
FoM = zeros(size(tpltSpec,2),size(spec,2));
stdFoM = zeros(size(tpltSpec,2),size(spec,2));
for n = 1:size(spec,2)
    for m = 1:size(tpltSpec,2)
        thisSpec = spec(:,n);
        thisTplt = tpltSpec(:,m);
        chFoM = (((thisSpec-spec(:,1)-thisTplt+tpltSpec(:,1)).^2)./ ...
            (thisSpec+spec(:,1)+thisTplt+tpltSpec(:,1))); % 每一道的FoM
        chFoM(isnan(chFoM)) = 0; % 分母为0的道置0
        FoM(m,n) = roi(:,1)'* chFoM;
        stdFoM(m,n) = 2*sqrt(roi(:,1)'* chFoM);
    end
end
end

