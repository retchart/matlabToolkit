function discParam = cclFoM(dataSet1,dataSet2)
% Calcuate variance and FoM factor of two dot clouds
% Assume center of dataSet1 and dataSet2 in n-Dimension space is A and B
% index of point C can be calculated to be AC.AB 
% higher value means C is more similiar with dataSet2
% 
% Inputs:
% dataSet1: Each col is a coordinate of a background spectrum
% dataSet2: Each col is a coordinate of a spectrum with illicit object
% 
% Outputs:
% discParam.center
% discParam.dis
% discParam.index
% discParam.FoM (factor of measurement) = d/2.355*(std1+std2)
% 

discParam.center1 = mean(dataSet1,2);
discParam.center2 = mean(dataSet2,2);
discParam.dis = sum((discParam.center2-discParam.center1).^2);
discParam.index1 = (discParam.center2-discParam.center1)'*dataSet1;
discParam.index2 = (discParam.center2-discParam.center1)'*dataSet2;
discParam.FoM = discParam.dis/(2.355*(std(discParam.index1,1)+std(discParam.index2,1)));

end
