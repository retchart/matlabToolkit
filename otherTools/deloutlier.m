function out = deloutlier(in,param)
% 删除数据的离群点
% in: 单列数据
% param: 删除几倍sigma外的数据
% out
while 1
    rowrow = find(abs(in-mean(in))>std(in)*param);
    if ~isempty(rowrow)
        in(rowrow,:)=[];
    else 
        out = in; break;
    end
end

