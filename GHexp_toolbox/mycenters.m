function vec = mycenters(set1,set2)
% Give the normalized from the center of set1 to center of set2
%
% Inputs:
% set1/set2: each column is a spectrum
% 
% Outputs:
% vec: Projection vector which is the line between two centers here

vec = mean(set2,2)-mean(set1,2);
vec = vec/sqrt(sum(vec.^2));
end

