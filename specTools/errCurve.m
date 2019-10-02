function [falsePosCurve,falseNegCurve,falseNeg] = ...
    errCurve(bkgdFileName,sgnlFilename,measureTime,falsePos,plotOrNot)
close all;
load(bkgdFileName);bkgd = sgnl;
load(sgnlFilename);

%% 作能谱直观图
if plotOrNot
    bkgd4plot = sum(bkgd,2)/size(bkgd,2);
    sgnl4plot = sum(sgnl,2)/size(sgnl,2);
    figure;
    semilogy(bkgd4plot);hold on;grid on;
    semilogy(sgnl4plot);
    xlabel('Channel');ylabel('Count/s');
end

%% 组合测量时间
bkgd = multispec(bkgd,measureTime);
sgnl = multispec(sgnl,measureTime);
[x,y] = specIndex(sgnl);
psgnl = [x,y];
[x,y] = specIndex(bkgd);
pbkgd = [x,y];
% plot(pbkgd(:,1),pbkgd(:,2),'.');
% hold on;
% plot(psgnl(:,1),psgnl(:,2),'.');
% hold off;

%% 计算错误率
[nbkgd,nsgnl,falsePosCurve,falseNegCurve,ii] = findFalse(pbkgd,psgnl);
if plotOrNot
    figure;
    plot(nbkgd(:,1),nbkgd(:,2),'.');
    hold on;
    plot(nsgnl(:,1),nsgnl(:,2),'.');
    title(['Best rotate angle:',num2str(ii),' degree']);
    figure;
    plot(falseNegCurve(:,1),falseNegCurve(:,2));hold on; grid on;
    plot(falsePosCurve(:,1),falsePosCurve(:,2));
end

for j = 1:size(falsePosCurve,1)-1
    if falsePosCurve(j+1,2)<falsePos && falsePosCurve(j,2)>falsePos
        indexTh = mean([falsePosCurve(j,1),falsePosCurve(j+1,1)]);
    elseif falsePosCurve(j,2)==falsePos
        indexTh = mean(falsePosCurve(find(falsePosCurve(:,2)==falsePos),1));
    end
end
falseNeg = spline(falseNegCurve(:,1),falseNegCurve(:,2),indexTh);



end % of function errCurve

function [x,y] = specIndex(mat)
% mat 为多列，1024行的能谱
[x,y] = index_1(mat);
end

function [x,y] = index_1(mat)
nullmat = zeros(size(mat,1),1);

x1 = nullmat; x1(508:690,1)=1; % Cl
x2 = nullmat; x2(207:245,1)=1; % H
y1 = nullmat; y1(743:785,1)=1; % Fe
y2 = nullmat; y2(207:245,1)=1; % H

x = mat'*x1./(mat'*x2);
y = mat'*y1./(mat'*y2);
%x = mat'*x1;
%y = mat'*y1;
end

function [nbkgd,nsgnl,falseP,falseN,ii] = findFalse(pbkgd,psgnl)
fom = zeros(90,1);
for i = 0:89
    theta = i*pi/180;
    rot = [cos(theta),-sin(theta);sin(theta),cos(theta)];
    bb = pbkgd*rot;
    ss = psgnl*rot;
    fom(i+1,1)=abs(mean(bb(:,1))-mean(ss(:,1)))/(std(bb(:,1),1)*std(ss(:,1),1));
% 画分布直方图
%     [y1,x1]=hist(bb(:,1),100);[y2,x2]=hist(ss(:,1),100);
%     plot(x1,y1);hold on;axis([min([x1,x2]),max([x1,x2]),0,max([y1,y2])]);
%     plot(x2,y2);title(['theta=',num2str(i)]);hold off;
%     pause(0.001); % 两分布图停留时间
end
ii = find(fom(:,1)==max(fom)); % 最佳旋转角度
theta = (ii-1)*pi/180;
rot = [cos(theta),-sin(theta);sin(theta),cos(theta)];
nbkgd = pbkgd*rot; bb = nbkgd(:,1);
nsgnl = psgnl*rot; ss = nsgnl(:,1);

i = 1;nPoint = 1000;
for thresh = min([ss;bb]):(max([ss;bb])-min([ss;bb]))/nPoint:max([ss;bb])
    falseP(i,1) = thresh;
    falseN(i,1) = thresh;
    falseP(i,2) = sum(bb>thresh)/size(bb,1);
    falseN(i,2) = sum(ss<thresh)/size(ss,1);
    i = i+1;
end

end

function mat = multispec(oldmat,multi)
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