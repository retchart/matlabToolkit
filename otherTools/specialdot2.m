function [xs_int,spe2] = specialdot2(spe,xs,plotOrNot)
% 计算spe每个能点的截面并梯形积分
% spe 射线能谱,第一列能量，第二列通量
% xs  截面，和spe单位一致
if max(spe(:,1))<min(xs(:,1)) ||min(spe(:,1))>max(xs(:,1))
    xs_int = 0;spe2=0;
    return
end
xs = [0,0;xs];
[~,dd]=unique(xs(:,1));
xs = xs(dd,:); % 删除重复行
spe = [spe,zeros(size(spe,1),1)];
for i = 2:size(spe,1)
    thisrange = find(xs(:,1)>=spe(i-1,1));
    if thisrange(1)>1
        thisrange = [thisrange(1)-1;thisrange];
    end
    thisxs = xs(thisrange,:);
    thisxs = thisxs(find(thisxs(:,1)<spe(i,1)),:);
    if isempty(thisxs)||size(thisxs,1)==1
        disp(['empty bin:',num2str(i)]);
        spe(i,3)=0;
    else
        spe(i,3) = trapz(thisxs(:,1),thisxs(:,2))/(thisxs(end,1)-thisxs(1,1));
    end
end
xs_int = spe(:,2)'*spe(:,3);
spe2 = spe;

if plotOrNot
    figure;
    yyaxis left
    loglog(spe(:,1),spe(:,2));hold on;
    xlabel('Energy (MeV)');
    ylabel('Ray intensity');
    yyaxis right
    loglog(xs(:,1),xs(:,2),'.-');
    ylabel('Cross section (b)');
    title(['Average cross section:',num2str(xs_int),' b']);
end
end
