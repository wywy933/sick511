clc; close all; clear all;
tic;
ScanAngle_min = -45;
ScanAngle_max = 225;


plot_switch = 0;

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

% if plot_switch
%     
%     theta = ScanAngle_min + ScanAngle_total / Xmax:ScanAngle_total  / Xmax:...
%         ScanAngle_max;
%     polar(theta,decDist,'.')
%     
% end
% 
% new_decDist_1 = zeros(1,Xmax);
% new_decDist_2 = zeros(1,Xmax);
% for n = 1:1:Xmax
%     new_decDist_1(n) = decDist(n) + rand(1) - 0.5;
%     new_decDist_2(n) = decDist(n) + rand(1) - 0.5;
% end
    
B = xyzmodify_parallel(decDist,ScanAngle_max,ScanAngle_min,0);
x = B(1,:);
y = B(2,:);
z = B(3,:);
% plot3(x,z,y,'.');
% title('origenal');
% grid on;

for n = 1:15
    E = xyzmodify_parallel(decDist,ScanAngle_max,ScanAngle_min,rand(1));
    B = [B E];
end

xlswrite('testoutput.xlsx',B);
    







toc;