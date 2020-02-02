function [FoM,stdFoM] = sbrs(spec,tpltSpec,roi)
% 尝试实现 Heider 提出的SBRS能谱处理方法
% 论文：Signature-based radiation scanning using radiation interrogation to detect explosives
% spec:N列实测能谱
% tpltSpec：M列模板谱，要求与spec统一纵轴
% roi：K行3列，K个能区的权重，起始行数和结束行数
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
        specSgnl = zeros(size(roi,1),1);
        tpltSgnl = zeros(size(roi,1),1);
        for k = 1:size(roi,1)
            specSgnl(k,1) = sum(thisSpec(roi(k,2):roi(k,3),1));
            tpltSgnl(k,1) = sum(thisTplt(roi(k,2):roi(k,3),1));
        end
        FoM(m,n) = roi(:,1)'* ...
            (((specSgnl-tpltSgnl).^2)./(specSgnl+tpltSgnl));
        stdFoM(m,n) = 2*sqrt(roi(:,1)'* ...
            (((specSgnl-tpltSgnl).^2)./(specSgnl+tpltSgnl)));
    end
end
end

