clc; close all; clear all;

rand('state',0);
x = rand(1,8);
y = rand(1,8);
TRI = delaunay(x,y);
triplot(TRI,x,y);%»æÍ¼
figure; 
xmin = min(x(:)); xmax = max(x(:));
ymin = min(y(:)); ymax = max(y(:));
xl = xmax - xmin; yl = ymax - ymin;
axis([xmin-xl*0.1, xmax+xl*0.1,...
    ymin-yl*0.1, ymax+yl*0.1]);
hold on;
for i = 1 : size(TRI, 1)
    t1 = TRI(i, :);
    for j = 1 : length(t1)-1
        xt = [x(t1(j)) x(t1(j+1))];
        yt = [y(t1(j)) y(t1(j+1))];
        plot(xt, yt, 'k-', 'LineWidth', 2);
        pause(0.1);
    end
    xt = [x(t1(end)) x(t1(1))];
    yt = [y(t1(end)) y(t1(1))];
    plot(xt, yt, 'k-', 'LineWidth', 2);
    pause(0.1);
end