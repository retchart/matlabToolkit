function [pks,area] = myfindpeak(yin,varargin)
% 3次多项式5点光滑一阶数值微商找峰

area = 0;

plotOrNot = sum(strcmp(varargin,'plot'));
% matlab 内置寻峰函数灵敏度很高且不可调
[~,pks] = findpeaks(yin);

% 三阶导数上升沿过零法
yin_gra3 = gradient(gradient(gradient(yin)));
figure;
plot(yin_gra3);


if plotOrNot 
    figure
    semilogy(yin);
    hold on;
    semilogy(pks,spline((1:size(yin,1))',yin,pks),'v');
end
end
