%% 用中子计数率校正.mat格式的能谱
%  目前需逐个能谱校正
clear;close all
neutronRef = 15000;
smplSymbol = 'OCT13-P21-H2O1650ml';
gammaSymbol = 'CH0-';
neutronSymbol = 'CH2-';
% load([gammaSymbol,smplSymbol,'-step0.01MeV-nml.mat']);
load([gammaSymbol,smplSymbol,'.mat']);
a = sgnl;
load([neutronSymbol,smplSymbol,'.mat']);
b = sum(sgnl,1);
b = repmat(b,size(a,1),1);
sgnl = neutronRef./b.*a;
spec = sum(sgnl,2)/size(sgnl,2);
figure;
subplot(311)
plotwhat = sum(a,1);
plot(plotwhat);ylabel('Gamma count');
title(['mean=',num2str(mean(plotwhat)),' root=',num2str(sqrt(mean(plotwhat))),' std=',num2str(std(plotwhat))]);
subplot(312)
plotwhat = b(1,:);
plot(plotwhat);ylabel('Neutron count');
title(['mean=',num2str(mean(plotwhat)),' root=',num2str(sqrt(mean(plotwhat))),' std=',num2str(std(plotwhat))]);
subplot(313)
plotwhat = sum(sgnl,1);
plot(plotwhat);hold on;
plot([0,length(plotwhat)],[1,1]*mean(plotwhat));
xlabel('spec No.');
ylabel(['Calibrated gamma to neutron count = ',num2str(neutronRef)]);
title(['mean=',num2str(mean(plotwhat)),' root=',num2str(sqrt(mean(plotwhat))),' std=',num2str(std(plotwhat))]);

save(['cali-',gammaSymbol,smplSymbol],'sgnl','spec');
