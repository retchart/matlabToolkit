function [xs_mean,mat] = specialdot(spe,xs)
% spe X射线能谱
% xs  截面
if max(spe(:,1))<min(xs(:,1))
    xs_mean = 0;
    return
end
xs = [0,0;xs];
[~,dd]=unique(xs(:,1));
xs = xs(dd,:); % 删除重复行
spe(:,3) = interp1(xs(:,1),xs(:,2),spe(:,1)); % 截面
mat = spe(:,[1,2,3]);
xs_mean = spe(:,2)'*spe(:,3);
figure;
yyaxis left
plot(spe(:,1),spe(:,2));hold on;
xlabel('Energy (MeV)');
ylabel('X-ray intensity');
yyaxis right
plot(xs(:,1),xs(:,2),'.-');
ylabel('Cross section (b)');
title(['Average cross section:',num2str(xs_mean),' b']);
end
