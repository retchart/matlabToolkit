function [deadinV,targetEvents]=Get_n_Positions(ptrac,z,radius)
% 较快速度得到V吸收中子个数
% 注意：需要手工去掉ptrac的文件头，导入MATLAB工作区才可使用本函数
% deadinV为位置>z，与中轴距离<radius
lines = size(ptrac,1);
j=1;
new=zeros(lines,4);
for i = 1:lines 
    if ~isnan(ptrac(i,8))
        if ~isnan(ptrac(i,9))
            new(j,1:3)=ptrac(i,1:3);
            j = j+1;
        end
    end
end
new(j:end,:)=[];
new(:,4) = (new(:,1).^2+new(:,2).^2).^(1/2);
new2 = new(find(new(:,4)<=radius),:);
targetEvents = new2(find(new2(:,3)>=z),:);
deadinV = size(targetEvents,1);
end
