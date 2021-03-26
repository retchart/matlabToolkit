function spec2input(spec,nnn,mmm)
% 将能谱转换为mcnp输入文件中的分布
% spec:两列
% nnn: 输出的x每行有多少个值
% mmm: 输出的y每行有多少个值
% REF:
%    si参数： L离散值分布 A描点概率密度

disp('c *-1----*----2----*----3----*----4----*----5----*----6----*----7----*----8----*');
a = spec(:,1)';
% H 区间内均匀分布；L离散值分布；A描点概率密度函数
disp(['si1 L ',num2str(a(1:nnn),'%g ')]);
i = nnn;
while i+nnn < length(spec)
    disp(['      ',num2str(a(i+1:i+nnn),'%g ')]);
    i=i+nnn;
end
disp(['      ',num2str(a(i+1:end),'%g ')]);

a = spec(:,2)';
disp(['sp1 ',num2str(a(1:mmm),'%g ')]);
i = mmm;
while i+mmm < length(spec)
    disp(['      ',num2str(a(i+1:i+mmm),'%g ')]);
    i=i+mmm;
end
disp(['      ',num2str(a(i+1:end),'%g ')]);
disp('c *-1----*----2----*----3----*----4----*----5----*----6----*----7----*----8----*');
end

