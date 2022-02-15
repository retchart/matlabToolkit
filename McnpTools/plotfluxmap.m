%% 生成fs和c卡构成的注量率图片
% 注意 调整fluxmap和fluxmap_err的方向
% 注意 数据平滑
clear;close all;
fileName = 'orgnCell-1';
load(fileName);
ePerSec = 0.9/9*1e-3/(1.6e-19); % 0.9kW,9MeV
roi_ch = 1:111; % 分析的道址区间
fluxmap = zeros(size(specCell,1),size(specCell,2));
fluxmap_err = zeros(size(specCell,1),size(specCell,2));
for i = 1:size(specCell,1)
    for j = 1:size(specCell,2)
        thisSpec = specCell{i,j};
        fluxmap(i,j) = sum(thisSpec(roi_ch,2))*ePerSec;
        fluxmap_err(i,j) = sqrt(sum((thisSpec(roi_ch,2).*thisSpec(roi_ch,3)).^2))*ePerSec;
    end
end

%% 平滑及调整fluxmap方向
% K = (1/9)*ones(3);
% fluxmap = conv2(fluxmap,K,'same');
fluxmap = fluxmap';
fluxmap = rot90(fluxmap,2);
fluxmap_err = fluxmap_err';
fluxmap_err = rot90(fluxmap_err,2);

%% 画图
figure;
subplot(211);
imagesc(param.HRZAXIS,param.VERAXIS,fluxmap);
colorbar;
xlabel('Y(cm)');ylabel('Z(cm)');
title('Total neutron flux(nv @ 0.9 kW)');
set(gca,'YDir','normal');
subplot(212);
imagesc(param.HRZAXIS,param.VERAXIS,fluxmap_err./fluxmap);
colorbar;
xlabel('Y(cm)');ylabel('Z(cm)');
title('Relative error of total neutron flux(nv @ 0.9 kW)');
set(gca,'YDir','normal');

save(['distribution-',fileName],'outputFileName','specCell', ...
    'tofspecCell','param','fluxmap','fluxmap_err','roi_ch','ePerSec');
