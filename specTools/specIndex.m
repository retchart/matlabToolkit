function [x,y] = specIndex(mat)
% mat 为多列，1024行的能谱
[x,y] = index_1(mat);
end

function [x,y] = index_1(mat)
nullmat = zeros(size(mat,1),1);

x1 = nullmat; x1(508:690,1)=1; % Cl
x2 = nullmat; x2(207:245,1)=1; % H
y1 = nullmat; y1(743:785,1)=1; % Fe
y2 = nullmat; y2(207:245,1)=1; % H

x = mat'*x1./(mat'*x2);
y = mat'*y1./(mat'*y2);
%x = mat'*x1;
%y = mat'*y1;
end