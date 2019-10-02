function [t,dis,errorcode] = FindT(sig,bkgd,err,tprecision)
% 为使t*n1和t*n2两个泊松分布的交点作为判别未知数属于哪个分布时，
% 误报率和漏报率均小于err，所要求的的最小t（使用二分法寻找）
% 要求n1>n2
% errorcode=0正常区分 errorcode=1输入有误 errorcode=2无法在合理时间内区分 
% 参考：err=0.05,tprecision=0.00001

errorcode = 0;
if sig==0 || bkgd==0 
    t=0;dis=0;
    disp('Error:寻找倍数的输入有0');
    errorcode = 1;
    return;
end
if sig<=bkgd
    t=0;dis=0;
    disp('Error:信号小于本底');
    errorcode = 2;
    return;
end
t1 = 1e-10;t2 = 1e12;
[flagflag,~]=fun1(sig*t2,bkgd*t2,err);
if flagflag == 0 %倍数最大时也无法分开
    t=0;dis=0;
    disp('Warning：此种信本比无法在合理时间内区分');
    errorcode = 3;
    return;
end
while 1
    t3=0.5*t1+0.5*t2;
    % disp(['try multi-times t=',num2str(t3)]);
    [flag,disc]=fun1(sig*t3,bkgd*t3,err);
    if flag
        %t3大了
        t2=t3;
    else
        %t3小了
        t1=t3;
    end
    if abs(t1-t2)<tprecision
        t=0.5*t1+0.5*t2;
        dis=disc;
        disp('Success:已得到最小区分倍率');
        break;
    end
end
end


function [flag,dis] = fun1(n1,n2,err)
% 得到n1>n2的情况，两图像交点横坐标以及是否满足错误率要求
%
dis1=n1;dis2=n2;
while 1 
    dis3 = 0.5*dis1+0.5*dis2;
    if poisspdf(dis3,n1)-poisspdf(dis3,n2)<0
        dis2=dis3;
    elseif poisspdf(dis3,n1)-poisspdf(dis3,n2)>0
        dis1=dis3;
    end
    if abs(dis1-dis2)<0.1 || poisspdf(dis3,n1)-poisspdf(dis3,n2)==0
        dis3=0.5*dis1+0.5*dis2;
        if poisscdf(dis3,n1)<=err && poisscdf(dis3,n2,'upper')<=err
            flag = 1;dis = dis3;
            break;
        else
            flag = 0;dis = 0;
            break;
        end
    end
end
end