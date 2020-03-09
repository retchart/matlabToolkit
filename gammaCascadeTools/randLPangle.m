function theta = randLPangle(multipoleOrder,number)
% Generate a column of random angles(unit:rad) from Legendre Polynomial
% 
% multipoleOrder = 1
% 0.5*(3*(cos(theta))^2-1)
% 
% multipoleOrder = 2
% 0.125*(35*(cos(theta))^2-30*(cos(theta))^2+3)
%
% NOTE: Is the radiation only one order?
% 
if multipoleOrder == 1
    % do something
elseif multipoleOrder == 2
    % do something
else
    error('Input multipoleOrder do not support');
end

% 调试用：在球面随机产生点，给出其与z轴的夹角theta
directions = randn(number,3);
param = sqrt(directions(:,1).^2+directions(:,2).^2+directions(:,3).^2);
directions = directions./param;

theta = directions*[0 0 1]';
theta = acos(theta);



end

