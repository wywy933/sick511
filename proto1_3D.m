clc; close all; clear all;
tic;
ScanAngle_min = -45;
ScanAngle_max = 225;


plot_switch = 0;
%%%%%%%%%%%%%%%%filter switch%%%%%%%%%%%%%%%%%%%%%%%%%
Gf = 0;
Af = 0;
Mf = 0;
Wf = 0;
doubleMf =0;
midanimate = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ScanAngle_min = ScanAngle_min * pi / 180;
ScanAngle_max = ScanAngle_max * pi / 180;
ScanAngle_total = abs(ScanAngle_min) + abs(ScanAngle_max);


%%%%%%%%%%%%%%%%%%import and rerange%%%%%%%%%%%%%%%%%%%%%%%%

Imported = rerange(importdata('2.txt'));

[Xmax,Ymax] = size(Imported);

for x = 1:Xmax
    for y = 1:Ymax
        Imported(x,y) = ascii2hex(Imported(x,y));
    end
end

Imported = ShiftM(Imported);

decDist = zeros(1,Xmax);
for x = 1:Xmax
    decDist(1,x) = 0;
    for y = 1:Ymax
        decDist(1,x) = decDist(1,x) + Imported(x,y)*(16^(Ymax - y));
    end
end

decDist = decDist ./ 1000;

if plot_switch
    
    theta = ScanAngle_min + ScanAngle_total / Xmax:ScanAngle_total  / Xmax:...
        ScanAngle_max;
    polar(theta,decDist,'.')
    
end

% new_decDist_1 = zeros(1,Xmax);
% new_decDist_2 = zeros(1,Xmax);
% for n = 1:1:Xmax
%     new_decDist_1(n) = decDist(n) + rand(1)/25 - 0.05;
%     new_decDist_2(n) = decDist(n) + rand(1)/25 - 0.05;
% end

B = xyzmodify_parallel(decDist,ScanAngle_max,ScanAngle_min,0);
x = B(1,:);
y = B(2,:);
z = B(3,:);
plot3(x,z,y,'--.r');
title('origenal');
grid on;


% figure;
if midanimate
while 1
  medfilterC = 1;
medfilterstep = 2;  
    
for i = 1:50

    medfilterC = medfilterC + medfilterstep;
xx = medfilt1(x,medfilterC);
yy = medfilt1(y,medfilterC);
zz = medfilt1(z,medfilterC);

plot3(x,z,y,'.b');
hold on;
plot3(xx,zz,yy,'--.r');
grid on;
pause(0.05);
clf
end
plot3(x,z,y,'.b');
hold on;
plot3(xx,zz,yy,'--.r');
grid on;
end
end
% 
% B = xyzmodify_parallel(new_decDist_1,ScanAngle_max,ScanAngle_min,0);
% x = B(1,:);
% y = B(2,:);
% z = B(3,:);
% figure;
% plot3(x,z,y,'.');
% title('man made noise 1');
% grid on;
% x = medfilt1(x);
% y = medfilt1(y);
% z = medfilt1(z);
% figure;
% plot3(x,z,y,'.');
% title('after med filter 1');
% grid on;
% 
% gausFilter = fspecial('gaussian');
% x = filter2(gausFilter,x);
% y = filter2(gausFilter,y);
% figure;
% plot3(x,z,y,'.');
% title('after gaussian filter 2');
% grid on;
% 
% x = medfilt1(x);
% y = medfilt1(y);
% z = medfilt1(z);
% figure;
% plot3(x,z,y,'.');
% title('after med filter 3');
% grid on;
% B = xyzmodify_parallel(new_decDist_2,ScanAngle_max,ScanAngle_min,0);
% x = B(1,:);
% y = B(2,:);
% z = B(3,:);
% figure;
% plot3(x,z,y,'.');
% title('man made noise 2');
% grid on;
% x = medfilt1(x);
% y = medfilt1(y);
% z = medfilt1(z);
% figure;
% plot3(x,z,y,'.');
% title('after med filter 2');
% grid on;
% 
% gausFilter = fspecial('gaussian');
% x = filter2(gausFilter,x);
% y = filter2(gausFilter,y);
% figure;
% plot3(x,z,y,'.');
% title('after gaussian filter 2');
% grid on;

%%%%%%%%%%%%%%%%%%%%%%gaussian filter%%%%%%%%%%%%%%%%%%%%%%%%%%
if Gf
gausFilter = fspecial('gaussian');
xx = filter2(gausFilter,x);
yy = filter2(gausFilter,y);
figure;
plot3(xx,z,yy,'.--');
title('gaussian filter');
grid on;


xx = filter2(gausFilter,xx);
yy = filter2(gausFilter,yy);
figure;
plot3(xx,z,yy,'.--');
title('2nd gaussian filter');
grid on;



end

%%%%%%%%%%%%%%%%%%%%%%average filter%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Af
averFilter = fspecial('average');
xxx = filter2(averFilter,x);
yyy = filter2(averFilter,y);
figure;
plot3(xxx,z,yyy,'.--');
title('average filter');
grid on;
end
%%%%%%%%%%%%%%%%%%%%%%med filter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Mf
xxxx = medfilt1(x);
yyyy = medfilt1(y);
z = medfilt1(z);
figure;
plot3(xxxx,z,yyyy,'.--');
title('med filter');
grid on;
end

if doubleMf
    xx = medfilt1(x);
    yy = medfilt1(y);
    xxx = medfilt1(xx);
    yyy = medfilt1(yy);
    figure;
    plot3(xxx,z,yyy,'.--');
    title('double med filter');
    grid on;
    
end




%%%%%%%%%%%%%%%%%%%%%%wiener filter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Wf
xxxxx = wiener2(x,[3 3]);
yyyyy = wiener2(y,[3 3]);
figure;
plot3(xxxxx,z,yyyyy,'.--');
title('winener filter');
grid on;
end

toc;

% 
% z = zeros(1,Xmax);
% plot3(x,z,y,'.--');
% grid on;
% % hold on;
% z = z + 0.1;
% plot3(x,z,y,'.--');
% z = z + 0.1;
% plot3(x,z,y,'.--');
% z = z + 0.1;
% plot3(x,z,y,'.--');
% z = z + 0.1;
% plot3(x,z,y,'.--');
% z = z + 0.1;
% plot3(x,z,y,'.--');
% z = z + 3;
% plot3(x,z,y,'.--');
% z = z - 6;
% plot3(x,z,y,'.--');
%%%%%%%%%%%%%%%%ascii to hex%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%