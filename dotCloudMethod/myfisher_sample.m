function [result,vec] = myfisher_sample(set1,set2,sample)
% Use Fisher Linear Discriminant Analysis to found the best projection
% diretion of input sets. 
% 
% Inputs:
% set1/set2: each column is a spectrum
% 
% Outputs:
% result: each column is the classification result of each column of sample 
% vec: Best projection vector

if size(set1,1) ~= size(set2,1)
    error('Error: Input data sets have different number of features');
end

% Delete the rows which are all zero
set10=set1;set20=set2;
for i = size(set1,1):-1:1
    if sum(set1(i,:))+sum(set2(i,:)) == 0
        set1(i,:)=[];
        set2(i,:)=[];
        disp(num2str(i));
    end
end
disp(['Notice: Data > channel-',num2str(size(set1,1)),' is deleted since they are zero']);

n1 = size(set1,2);
n2 = size(set2,2);
meanVec1 = mean(set1,2);
meanVec2 = mean(set2,2);
withinClassMat1 = cov(set1')*(n1-1); % should we mutiply n1-1 ?
withinClassMat2 = cov(set2')*(n2-1);
sw = withinClassMat1 + withinClassMat2;
vec = inv(sw)*(meanVec2-meanVec1)*(n1+n2-2); % should we mutiply *(r1+r2-2)?
vec = [vec;zeros(size(set10,1)-size(vec,1),1)];
index1 = vec'*set10;
index2 = vec'*set20;
th = (mean(index1)*n1+mean(index2)*n2)/(n1+n2); % threshold

result = zeros(1,size(sample,2));
for i=1:size(sample,2)
    result(i)=vec'*sample(:,i);
    if result(i)>th
        result(i)=1;
    else
        result(i)=0;
    end
end

end
