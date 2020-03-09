x = -1:0.001:1;
p2 = 0.5*(3*x.^2-1);
p4 = 0.125*(35*x.^4-30*x.^2+3);
plot(x,p2,'-.','LineWidth',3);
hold on
plot(x,p4,'-.','LineWidth',3);
plot([-1,1],[0,0],'k-','LineWidth',3);
legend('P2','P4');
xlabel('cos(theta)');
