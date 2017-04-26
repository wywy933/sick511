clc;close all;clear all

B = xlsread('testoutput.xlsx');
x = medfilt1(B(1,:));
y = medfilt1(B(2,:));
z = medfilt1(B(3,:));
X = x';
Y = y';
Z = z';

plot3(x,z,y,'.');
grid on;
xlabel('x');
ylabel('y');
zlabel('z');

% fun=@(p) cos(p(1))*X+sin(p(1))*cos(p(2))*Y+sin(p(1))*sin(p(2))*Z+p(3);
% p = lsqnonlin(fun,[0 0 0]);
% A=cos(p(1));
% B=sin(p(1))*cos(p(2));
% C=sin(p(1))*sin(p(2));
% D=p(3);


% fun=@(p,xx,yy) p(1)*xx+p(2)*yy+p(3);
% para=lsqcurvefit(@(p,data) fun(p,data(:,1),data(:,2)),[1 1 1],[X Y],Z);
% %ÄâºÏÎª  Z=para(1)*X+para(2)*Y+para(3)
% plot3(X,Z,Y,'.');
% figure
% hold on;
% h=ezsurf(@(x,y)fun(para,x,y),[min(X) max(X) min(Y) max(Y)]); 
% figure
% % hold off;
% set(h,'edgecolor','none','facealpha',0.3,'FaceColor','r');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fun=@(p) cos(p(1))*X+sin(p(1))*cos(p(2))*Y+sin(p(1))*sin(p(2))*Z+p(3);
% p = lsqnonlin(fun,[0 0 0]);
% A=cos(p(1));
% B=sin(p(1))*cos(p(2));
% C=sin(p(1))*sin(p(2));
% D=p(3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% X = [ones(size(z)) z.*z z x.*x x z.*x];
% 
% [b,bint] = regress(y,X);
% plot3(z,x,y,'.');
% hold on;
% zfit = min(z):0.1:max(z);
% xfit = min(x):0.1:max(x);
% 
% [zFIT,xFIT] = meshgrid(zfit,xfit);
% yFIT = b(1) + b(2) * zFIT .* zFIT + b(3) * zFIT + b(4) * xFIT .* xFIT + ...
%     b(5) * xFIT + b(6) * zFIT .* xFIT;
% mesh(zFIT, xFIT, yFIT);