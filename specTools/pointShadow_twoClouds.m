function [p1,d1,d2,sigma1,sigma2] = pointShadow_twoClouds(p1,p2,precision)
% 求一组点p1和p2连线上的垂直投影坐标pp0,以及pp0和point1，point2分别的距离d1,d2
% 两组距离分别对应的样本标准差sigma1，sigma2
% p0每一行为一个坐标
pp0=zeros(size(p0,1),2);
d1=zeros(size(p0,1),1);
d2=zeros(size(p0,1),1);
x1=p1(1,1);y1=p1(1,2);
x2=p2(1,1);y2=p2(1,2);
k = (y1-y2)/(x1-x2);
A = k;B = -1;C = y1-k*x1;
for i = 1:size(p0,1)
    x0=p0(i,1);y0=p0(i,2);
    pp0(i,1)=(B*B*x0-A*B*y0-A*C)/(A*A+B*B); %连线上的投影坐标x
    pp0(i,2)=(-A*B*x0+A*A*y0-B*C)/(A*A+B*B);%连线上的投影坐标y
    d1(i,1)=p2pdistance(pp0(i,1:2),p1,p2);
    d2(i,1)=p2pdistance(pp0(i,1:2),p2,p1);
end
sigma1 = std(d1,0);
sigma2 = std(d2,0);
end