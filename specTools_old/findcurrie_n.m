function nd = findcurrie_n(nb,FPR,FNR)
% 本底计数nb，实现误报率FPR，漏报率FNR所需的最小样品净计数nd
% 联立以下方程求解nd
%     Lc = a1*sqrt(2*nb)       % a1对应误报率要求阈值达到Lc
%     nd=Lc+a2*sigma(nd)       % a2 对应漏报率要求nd比Lc高多少
%     sigma(nd)=sqrt(nd+2*nb)  % nd的误差
% 
% Reference:
%    Knoll.P97-98


% syms x b a1 a2
% eq = x == a2*sqrt(2*b)+a1*sqrt(x+2*b); % 参数计算出公式后可以直接用公式
% s = solve(eq,x);

a1 = norminv(1-FNR,0,1);
a2 = norminv(1-FPR,0,1);
nd1 = a1^2/2 - (a1*(8*nb + a1^2 + 4*2^(1/2)*a2*nb^(1/2))^(1/2))/2 + 2^(1/2)*a2*nb^(1/2);
nd2 = a1^2/2 + (a1*(8*nb + a1^2 + 4*2^(1/2)*a2*nb^(1/2))^(1/2))/2 + 2^(1/2)*a2*nb^(1/2);
nd = nd2;

end

