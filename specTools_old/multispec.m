function mat = multispec(oldmat,multi)
% 将每列为一个能谱的多列能谱，每multi个加和
mat = [];
i = 1;
while 1
    mat = [mat,sum(oldmat(:,multi*i-multi+1:multi*i),2)];
    i = i + 1;
    if(multi*i>size(oldmat,2))
        break;
    end
end
end