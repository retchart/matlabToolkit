function sgnl = nmlAndSave1Spec(matFileName,plotOrNot,energyStep)
load(matFileName);

%% ±ê×¼»¯
[orgnSpecsgnl,nmlSpecsgnl] = nml1spec(sum(sgnl,2),size(sgnl,2),energyStep,0);
if plotOrNot
    figure;
    semilogy(nmlSpecsgnl(:,1),nmlSpecsgnl(:,2),'.-');hold on;grid on;
    title(matFileName);
    xlabel('Energy(MeV)');
    ylabel(['Count rate(cps/',num2str(nmlSpecsgnl(2,1)-nmlSpecsgnl(1,1)),'MeV']);
end

sgnl = nmlSpecs(sgnl,orgnSpecsgnl(:,1),nmlSpecsgnl(:,1));
save([matFileName(1:length(matFileName)-4),'-step',num2str(energyStep),'MeV-nml.mat',],'sgnl');

end
