function [FOM,err,centers,dis,sigma_bkgd,sigma_sigl]=cclFoM(bkgd,sigl)
% 计算两个点云各自的标准差和FOM因子
% bkgd和sig每一行是一个点的位置坐标
% FOM (factor of measurement) = d/2.355*(sigma1+sigma2)
% central_bkgd = 无毒品点云的中心
% central_sigl = 有毒品点云的中心
% dis = 中心距
% sigma_bkgd = 本底点云在连线投影后，和中心的距离标准差
% sigma_sigl = 毒品点云在连线投影后，和中心的距离标准差
% bkgd = 本底点集，每行为一个点的坐标(x,y)，行数应>1
% sigl = 毒品点集，每行为一个点的坐标(x,y)，行数应>1
% err = 区分时的错误率，第一列起分别为：仅以第x轴做区分，仅以y轴做区分，后续待定
central_bkgd = mean(bkgd,1);
central_sigl = mean(sigl,1);
centers = [central_bkgd;central_sigl];
% 计算标准差
[~,set1,~,sigma_bkgd,~]=pointShadow(bkgd,central_bkgd,central_sigl);
[~,~,set2,~,sigma_sigl]=pointShadow(sigl,central_bkgd,central_sigl);
dis = abs(p2pdistance(central_bkgd,central_sigl,central_sigl));
FOM = dis/(2.355*(sigma_bkgd+sigma_sigl));
if isnan(FOM)
    err = nan;
    return;
else 
    [~,err,~,~] = cclGaussErr(set1,set2+dis);
    % 取最小非0值
    err = min(err(err>0));
    if isempty(err)
        err = nan;
    end
end
end
