function [positions,distance,countresult]=Get_e_Positions(ptrac,remmiter,r0,rinsulator,rcollector)
% 快速得到电子位置
% 注意：需要手工去掉ptrac的文件头并以文件名ptrac导入MATLAB工作区才可使用本函数
% 
% ptrac：文件矩阵    remmiter:发射体半径（cm）
% r0:空间电场临界半径（cm）该值为0时，根据均匀空间电荷电场计算临界半径
% rinsulator:绝缘体外半径（cm）   rcollector:收集体外半径（cm）
% 
% 参考设计：remmiter=0.05 r0=0.068 rinsulator=0.087 rcollector=0.1015
% 版本迭代：20171206 20171228
if(r0==0)
    ratio = remmiter/rinsulator;
    r0 = rinsulator*sqrt((ratio^2-1)/(2*log(ratio)));
end
lines = size(ptrac,1);
j=1;
positions = zeros(lines,4);
for i = 1:lines
    if isnan(ptrac(i,4))
        if ~isnan(ptrac(i,3))
            positions(j,1:3)=ptrac(i,1:3);
            disp(j);
            j = j+1;
        end
    end
end
positions(j:end,:)=[];
positions(:,4) = (positions(:,1).^2+positions(:,2).^2).^(1/2);
distance=positions(:,4);
countresult = zeros(1,5);
countresult(1,1) = sum(distance<remmiter);
countresult(1,2) = sum(distance<r0)-sum(distance<remmiter);
countresult(1,3) = sum(distance<rinsulator)-sum(distance<r0);
countresult(1,4) = sum(distance<rcollector)-sum(distance<rinsulator);
countresult(1,5) = sum(distance>=rcollector);
disp(num2str(countresult));
disp(['请检查总行数:',num2str(j-1)]);
disp(['上一行的数字应等于总事件数:',num2str(sum(countresult))]);
end
