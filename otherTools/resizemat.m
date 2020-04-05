function [newmat,errorCode] = resizemat(mat,sizes)
% resize 2D matrix 'mat' into sizes(1)*sizes(2) 'newmat'
%
% INPUTS:
% mat: 2D matrix
% sizes: 1 raw 2 col
%
% OUTPUTS:
% newmat: resized matrix
% errorCode: 1 size of 'mat' can not divided by 'sizes'
%            2
%
newmat = 0;errorCode = 0;
if mod(size(mat,1),sizes(1)) > 0 || mod(size(mat,2),sizes(2)) > 0
    disp('Error: resizemat invalid input sizes');
    errorCode = 1;
    return;
end
mat(isnan(mat))=0;
newmat = zeros(sizes);
if size(mat,1)~=size(newmat,1) && size(mat,2)~=size(newmat,2)
    % normal resize
    for i = 1:sizes(1)
        for j = 1:sizes(2)
            newmat(i,j) = ...
                sum(sum(mat( ...
                size(mat,1)/sizes(1)*i-size(mat,1)/sizes(1)+1: ...
                size(mat,1)/sizes(1)*i, ...
                size(mat,2)/sizes(2)*j-size(mat,2)/sizes(2)+1: ...
                size(mat,2)/sizes(2)*j)));
        end
    end
elseif size(mat,1)~=size(newmat,1) && size(mat,2)==size(newmat,2)
    % only resize count of raws
    for i = 1:sizes(1)
        newmat(i,:) = sum(mat( ...
            size(mat,1)/sizes(1)*i-size(mat,1)/sizes(1)+1: ...
            size(mat,1)/sizes(1)*i,:),1);
    end
elseif size(mat,1)==size(newmat,1) && size(mat,2)~=size(newmat,2)
    % only resize count of columns
    for i = 1:sizes(2)
        newmat(:,i) = sum(mat(:, ...
            size(mat,2)/sizes(2)*i-size(mat,2)/sizes(2)+1: ...
            size(mat,2)/sizes(2)*i),2);
    end
elseif size(mat,1)==size(newmat,1) && size(mat,2)==size(newmat,2)
    newmat = mat;
end

end

