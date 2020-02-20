function [Jrule,auc] = estimatevector(set1,set2,vec)
% Give the Jrule value and auc value when set1/set2 are projected to vec
% 
% Inputs:
% set1/set2: Each column is a spectrum
% vec: To which direction should projected,One column
% 
% Outputs:
% Jrule: (mean(1)-mea(2))^2/(var(1)+var(2))
% auc: area under ROC curve. ROC are made based on Gauss assumption

if size(vec,1)~=1 && size(vec,2)~=1
    error('Error: Projection direction is not a vector');
end
if size(vec,1)<size(vec,2)
    vec = vec';
end
index1 = vec'*set1;
index2 = vec'*set2;
Jrule = (mean(index2)-mean(index1))^2/(var(index1)+var(index2));
[~,auc] = rocgauss(index1,index2,1000);

end

