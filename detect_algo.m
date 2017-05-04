clc;close all;clear all;

raw = xlsread('limitedangletest1.xlsx','','','basic');

dis = raw(1,:);
angle = raw(2,:);

ScanAngle_min = -5;
ScanAngle_min = ScanAngle_min * pi / 180;
given_angle = 85;
given_angle = given_angle * pi / 180;


angle_step = abs((angle(1) - (angle(end)))) / length(dis);


% angle = given_angle + angle;
%%%%%%%%%%%%%plot polar form%%%%%%%%%%%%%%%%%%%%
polar(angle,dis)
grid on;
[A,B] = peakdetect(dis,0.005);
hold on;

for i = 1:size(A)
polar([0 angle(A(i,2))] , [0 A(i,1)]);
end

for i = 1:size(B)
polar([0 angle(B(i,2))] , [0 B(i,1)]);
end

%%%%%%%%%%%%%%%%%%xyz plot%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = zeros(1,length(dis));
y = zeros(1,length(dis));
for i = 1:length(dis)
    x(i) = dis(i) * cos(angle(i));
    y(i) = dis(i) * sin(angle(i));
end
% figure
% plot(x,y)