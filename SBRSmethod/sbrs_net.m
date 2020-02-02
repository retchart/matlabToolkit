function [FoM,stdFoM] = sbrs_net(spec,tpltSpec,roi)
% 尝试实现 Heider 提出的SBRS能谱处理方法，输入项为net谱
% 论文：Signature-based radiation scanning using radiation interrogation to detect explosives
% spec:N列实测能谱，第一列为air谱，其它列为样品-air谱
% tpltSpec：M列模板谱，要求与spec统一纵轴
% roi：K行3列，K个能区的权重，起始行数和结束行数
%
% FoM：M行N列相似度指标,每列代表每能谱和1-M个模板的相似度
% stdFoM:M行N列相似度指标,每列代表每能谱和1-M个模板的相似度标准差
% 
FoM = zeros(size(tpltSpec,2),size(spec,2));
stdFoM = zeros(size(tpltSpec,2),size(spec,2));
for n = 1:size(spec,2)
    for m = 1:size(tpltSpec,2)
        thisSpec = spec(:,n);
        thisTplt = tpltSpec(:,m);
        specSgnl = zeros(size(roi,1),1);
        specSgnlvar = zeros(size(roi,1),1); % 信号方差
        tpltSgnl = zeros(size(roi,1),1);
        tpltSgnlvar = zeros(size(roi,1),1); %模板方差
        for k = 1:size(roi,1)
            specSgnl(k,1) = sum(thisSpec(roi(k,2):roi(k,3),1));
            specSgnlvar(k,1) = specSgnl(k,1)+sum(spec(roi(k,2):roi(k,3),1));
            tpltSgnl(k,1) = sum(thisTplt(roi(k,2):roi(k,3),1));
            tpltSgnlvar(k,1) = tpltSgnl(k,1)+sum(tpltSpec(roi(k,2):roi(k,3),1));
        end
        FoM(m,n) = roi(:,1)'* ...
            (((specSgnl-tpltSgnl).^2)./(specSgnlvar+tpltSgnlvar));
        stdFoM(m,n) = 2*sqrt(roi(:,1)'* ...
            (((specSgnl-tpltSgnl).^2)./(specSgnlvar+tpltSgnlvar)));
    end
end
end

