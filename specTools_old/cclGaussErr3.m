function [FNR,crossPoint,err,errEqualPoint,errEqual] = cclGaussErr3(u1,sigma1,u2,sigma2,FPR)
% 
% 
% crossPoint：分布曲线交点
% err:err(1)右侧分布在crossPoint左侧面积(FNR),左侧分布在crossPoint右侧面积(FPR)
% errEqualPoint：两侧面积相等时横坐标(同错误率阈值)
% errEqual：两侧面积相等时的面积（错误率）
crossPoint=0;err=[0,0];errEqualPoint=0;errEqual=0;
errPrecision = 1e-2;

if u1>u2 %交换使u2>u1
    u3=u1;u1=u2;u2=u3;
    sigma3=sigma1;sigma1=sigma2;sigma2=sigma3;
end
if u1 == u2 || u1 == 0|| u2 == 0
    return;
end

% 误报率下的漏报率
thisTh = norminv(1-FPR,u1,sigma1);
FNR = normcdf(thisTh,u2,sigma2);

% 找交点
dis1=u1;dis2=u2;
while 1
    dis3 = 0.5*dis1+0.5*dis2;
    if normpdf(dis3,u1,sigma1)<normpdf(dis3,u2,sigma2)
        dis2=dis3;
    elseif normpdf(dis3,u1,sigma1)>normpdf(dis3,u2,sigma2)
        dis1=dis3;
    end
    if abs(dis1-dis2)<errPrecision || normpdf(dis3,u1,sigma1)==normpdf(dis3,u2,sigma2)%退出条件
        crossPoint=0.5*dis1+0.5*dis2;
        err(1,1) = normcdf(crossPoint,u2,sigma2);
        err(1,2) = normcdf(crossPoint,u1,sigma1,'upper');
        break;
    end
end
% 找累计概率相同的点
dis1=u1;dis2=u2;
while 1
    dis3 = 0.5*dis1+0.5*dis2;
    if normcdf(dis3,u1,sigma1,'upper')<normcdf(dis3,u2,sigma2)
        dis2=dis3;
    elseif normcdf(dis3,u1,sigma1,'upper')>normcdf(dis3,u2,sigma2)
        dis1=dis3;
    end
    if abs(dis1-dis2)<errPrecision || normpdf(dis3,u1,sigma1)==normpdf(dis3,u2,sigma2)%退出条件
        errEqualPoint = 0.5*dis1+0.5*dis2;
        errEqual = normcdf(errEqualPoint,u2,sigma2);
        break;
    end
end

end