%% 计算反康后能谱
% 宜先用handle_coincurve确定tRange取值
clear;
close all;
mainCh = 1; % 主探测器序号
mainCh2 = 8192*2; % 主探测器倒数
antiCh = [2,3]; % 反康谱仪序号
tRange = [-5500,-4500];
ntRange = 50; % 在几条list记录内查找是否有反康计数
load('Pb-18.1mg.mat');

list = s.list{1,mainCh};
for i = 1:length(antiCh)
    list = [list;s.list{1,antiCh(i)}];
end
list = sortrows(list,1);
list_orgn = list(find(list(:,2)==mainCh),[1,3]); % 主探测器原始list
for i = 1:length(list)
    if list(i,2)==mainCh
        thisTime = list(i,1);
        thisList = list(max([1,i-ntRange]):min([length(list),i+ntRange]),:);
        thisList(find(thisList(:,1)>thisTime+tRange(2)),:)=[];
        thisList(find(thisList(:,1)<thisTime+tRange(1)),:)=[];
        thisList(find(thisList(:,2)==mainCh),:)=[];
        if isempty(thisList) % 没有同时被测到的情况
            list(i,2)=999;
        end
    end
    if mod(i,100)==0
        disp([num2str(i),'/',num2str(length(list))]);
    end
end

list_main = list(find(list(:,2)==999),[1,3]); % 反康后主探测器list
list_anti = list(find(list(:,2)==mainCh),[1,3]); % 被反康掉的list
figure;
[y_orgn,x]=hist(list_orgn(:,2),1:mainCh2);x=x';y_orgn=y_orgn';
semilogy(x,y_orgn,'k');hold on;
[y_main,~]=hist(list_main(:,2),1:mainCh2);y_main=y_main';
semilogy(x,y_main,'r');
[y_anti,~]=hist(list_anti(:,2),1:mainCh2);y_anti=y_anti';
semilogy(x,y_anti,'b');
xlabel('Ch');ylabel('Count/ch');
legend({'original';'anticompton spec';'anti'});
disp(['Deleted ',num2str(sum(y_anti)),' count from original spectrum']);