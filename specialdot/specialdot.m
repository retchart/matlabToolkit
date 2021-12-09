function [intint,speWithXs] = specialdot(spe,xs,plotOrNot)
% 计算注量率直方图与截面曲线的乘积
% spe 射线能谱,第一列能量，第二列通量
% xs  截面，第一列的单位需和spe第一列一致
% 若截面能点间隔很大，使用specialdot2可能更好

if max(spe(:,1))<min(xs(:,1)) ||min(spe(:,1))>max(xs(:,1))
    % 若能量范围不交叠，直接返回0
    intint = 0;speWithXs=0;
    return
end
xs = [0,0;xs];[~,dd]=unique(xs(:,1));xs = xs(dd,:); % 删除xs重复行
spe(:,3) = interp1(xs(:,1),xs(:,2),spe(:,1)); % 在能谱点内插截面数据
spe(:,4) = spe(:,2).*spe(:,3);
speWithXs = spe; 
intint = spe(:,2)'*spe(:,3);
if plotOrNot
    figure;
    yyaxis left
    semilogx(spe(:,1),spe(:,2),'b.-');hold on;
    xlabel('Energy');
    ylabel('Ray intensity');
    yyaxis right
    loglog(xs(:,1),xs(:,2),'r.-');
    ylabel('Cross section (b)');
    title(['Integration:',num2str(intint)]);
end
end
