function t = findcurrie_t(nb,nd,FPR,FNR)
% 本底计数率nb,样品净计数率nd，实现误报率FPR，漏报率FNR所需的最小测量时长t
% 联立以下方程求解t
%     Lc = a1*sqrt(2*nb*t)           % a1对应误报率要求阈值达到Lc
%     nd*t=Lc+a2*sigma(nd*t)         % a2对应漏报率要求nd*t比Lc高多少
%     sigma(nd*t)=sqrt(nd*t+2*nb*t)  % nd*t的误差
% 易算出
%     nd*t = a2*sqrt(2*nb*t)+a1*sqrt(nd*t+2*nb*t)
% Reference:
%    Knoll.P97-98

if nb<0 || nd<0 || FPR<0 || FNR<0
    t = -1; % 错误输入
    return;
end

a1 = norminv(1-FNR,0,1);
a2 = norminv(1-FPR,0,1);
t = (a2*sqrt(2*nb)+a1*sqrt(nd+2*nb))^2/nd^2;

end

