function [intint,xss,spee] = specialdotnew2(spe,xs,plotOrNot)
%function [int_total,int_thermal,int_resonance,int_roi] = specialdotnew2(spe,xs,plotOrNot)
% 计算注量率直方图与截面曲线的乘积
% 注意：仅验证了适用于中子活化Au的计算，能谱和截面数据点间隔都较均匀
%       中子活化其它核素的计算需注意数据点是否均匀
% 注意：光子活化过程能谱数据点和截面数据点一般不均匀且不一致
% Input：
% spe 射线能谱,第一列MeV能量，第二列通量,第三列该bin内的平均截面
% xs  (n,g)截面，第一列MeV能量，第二列截面；第一列的单位需和spe第一列一致
% Output:
% intint(1): 截面与注量的数值积分
% intint(2): 0.5eV以下的中子和注量率的数值积分
% intint(3): 0.5eV以上的中子和注量率的积分
% intint(4): 4.9eV+-0.1eV的中子和注量率积分
% spee 调试用，射线能谱,第一列能量，第二列通量,第三列该bin内的平均截面
% xss  调试用，(n,g)截面，第一列能量，第二列截面，第三列注量率密度
intint = zeros(1,4);
xss = [];spee=[];
if max(spe(:,1))<min(xs(:,1)) ||min(spe(:,1))>max(xs(:,1))
    return;
end
xs = [0,0;xs];[~,dd]=unique(xs(:,1));xs = xs(dd,:); % 删除xs重复行
spe = [0,0;spe];
xs(:,3) = interp1(spe(:,1),spe(:,2),xs(:,1)); % 在截面点内插注量率作为权重
for i = 2:size(spe,1)
    thisXs = xs(find(xs(:,1)<=spe(i,1)),:);
    thisXs = thisXs(find(thisXs(:,1)>spe(i-1,1)),:);
    spe(i,3) = thisXs(:,2)'*thisXs(:,3)/sum(thisXs(:,3)); % Energybin的平均截面
end
spe(isnan(spe))=0;
xss = xs; 
spee = spe;
intint(1) = spe(:,2)'*spe(:,3);
th = max(find(spe(:,1)<0.5e-6));
intint(2) = spe(1:th,2)'*spe(1:th,3);
intint(3) = spe(th+1:end,2)'*spe(th+1:end,3);
th1 = max(find(spe(:,1)<4e-6));th2 = min(find(spe(:,1)>6e-6));
intint(4) = spe(th1:th2,2)'*spe(th1:th2,3);
if plotOrNot
    figure;
    yyaxis left
    semilogx(spe(:,1),spe(:,2),'b.-');hold on;
    xlabel('Energy');
    ylabel('Ray intensity');
    yyaxis right
    loglog(xs(:,1),xs(:,2),'r.-');
    loglog(spe(:,1),spe(:,3),'g.-');
    ylabel('Cross section (b)');
    title(['Total integration:',num2str(intint(1))]);
    legend({'Intensity','Cross section','Mean cross section'});
end
end
