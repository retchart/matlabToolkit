FPR = 0.01; % Îó±¨ÂÊ
ntpr=30;
tpr = (1:ntpr)';
for i = 1:length(rocGauss)
    thisroc = rocGauss{i};
    k=[];
    for j = 2:size(thisroc,1)
        if thisroc(j,1)==thisroc(j-1,1)
            k=[k,j];
        end
    end
    thisroc(k,:)=[];
    tpr(i,2) = interp1(thisroc(:,1),thisroc(:,2),FPR);
end
plot(tpr(:,1),tpr(:,2));
