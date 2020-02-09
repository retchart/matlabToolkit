close all;
sumCh = 64;
inputSpec = normalizedSpec;
for i = sumCh:sumCh:size(inputSpec,1)
    inputSpec(i,2:end) = sum(inputSpec(i-sumCh+1:i,2:end),1);
end
outputSpec = inputSpec(sumCh:sumCh:size(inputSpec,1),:);
semilogy(outputSpec(:,1),outputSpec(:,2),'o-');
hold on;grid on;
xlabel('Energy(MeV)');
ylabel(['Count rate(cps/',num2str(inputSpec(1,1)*sumCh*1000),'keV)']);
