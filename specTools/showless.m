function specwithenergy = showless(spec0,k,plotOrNot)
% 输入带横轴能谱，输出及显示相邻道址合并的能谱
% 

eA_orgn = spec0(:,1);
spec = spec0(:,2:end);

eA = eA_orgn(k:k:end);
spec = resizemat_cut(spec,[floor(size(spec,1)/k),size(spec,2)]);
if plotOrNot
semilogy(eA,spec,'.-');
xlabel('Ch');
ylabel('Count');
title(['Original ',num2str(k),' ch = new 1 ch']);
end
specwithenergy = [eA,spec];
end