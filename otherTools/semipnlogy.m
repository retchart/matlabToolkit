function [handle,ax] = semipnlogy(x,y,minmin)
% Plot a figure with positive and negative value in log
%
% Input:
% x: one column
% y: several columns
% minmin: lower than which are regarded as 0
if size(x,2)>size(x,1)
    x=x';
end
if size(x,1)~=size(y,1) || size(x,2)~=1
    error('Cannot plot (y,x) with different dimension');
end
if minmin<=0
    error('Input minmin or maxmax <=0');
end

for i = 1:size(y,1)
    for j = 1:size(y,2)
        if y(i,j)>minmin
            yy(i,j) = log10(y(i,j)/minmin);
        elseif y(i,j) <= minmin && y(i,j) >= -minmin
            yy(i,j) = 0;
        elseif y(i,j)<-minmin
            yy(i,j) = log10(-minmin/y(i,j));
        end
    end
end
figure;hold on;
for i = 1:size(yy,2)
    handle = plot(x,yy(:,i),'.');
end
ax = axis;
axis([ax(1),ax(2),-max([abs(ax(3)),abs(ax(4))]),max([abs(ax(3)),abs(ax(4))])]);
% axis([ax(1),ax(2),log10(minmin),log10(1/minmin)]);
ax = axis;
j = 1;
for i = floor(ax(3):floor(ax(4)))
    if i < 0
        thisylabel(j) = -minmin/10^i;
    elseif i == 0
        thisylabel(j) = minmin;
    elseif i>0
        thisylabel(j) = 10^(i)*minmin;
    end
    j = j+1;
end
set(gca,'ytick',floor(ax(3):floor(ax(4))), ...
    'yticklabel',thisylabel);
legend;
end

