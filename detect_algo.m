clc;close all;clear all;

raw = xlsread('limitedangletest11.xlsx','','','basic');

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
% hold on;
% 
% for i = 1:size(A)
% polar([0 angle(A(i,2))] , [0 A(i,1)]);
% end
% 
% for i = 1:size(B)
% polar([0 angle(B(i,2))] , [0 B(i,1)]);
% end

%%%%%%%%%%%%%%%%%%xyz plot%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x = zeros(1,length(dis));
% y = zeros(1,length(dis));
% for i = 1:length(dis)
%     x(i) = dis(i) * cos(angle(i));
%     y(i) = dis(i) * sin(angle(i));
% end
% figure
% plot(x,y)
% grid on;
% hold on;
% 
% for i = 1:size(A)
%     plot(x(A(i,2)),y(A(i,2)),'o');
% end
% 
% for i = 1:size(B)
%     plot(x(B(i,2)),y(B(i,2)),'o');
% end


%%%%%%%%%%%%%rotate%%%%%%%%%%%%%%%%%%%
x = zeros(1,length(dis));
y = zeros(1,length(dis));
rotate_angle = -45 * pi / 180;
for i = 1:length(dis)
    x(i) = dis(i) * cos(angle(i) + rotate_angle);
    y(i) = dis(i) * sin(angle(i) + rotate_angle);
end

figure
plot(x,y)
grid on;
hold on;
[AA,BB,CC] = peakdetect(y,0.005);
for i = 1:size(AA)
    plot(x(AA(i,2)),y(AA(i,2)),'o');
end

for i = 1:size(BB)
    plot(x(BB(i,2)),y(BB(i,2)),'o');
end

%%%%%%%%%%%feed rotated detection back to origenal%%%%%%%%%%%%%
figure;
polar(angle,dis)
grid on;
hold on;
% for i = 1:size(A)
% polar([0 angle(A(i,2))] , [0 A(i,1)]);
% end
% 
% for i = 1:size(B)
% polar([0 angle(B(i,2))] , [0 B(i,1)]);
% end

for i = 1:size(AA)
    polar(angle(AA(i,2)),dis(AA(i,2)),'o');
end

for i = 1:size(BB)
    polar(angle(BB(i,2)),dis(BB(i,2)),'o');
end

%%%%%%%%calculate distance between each two peaks%%%%%%%%%%%%%%%%%%%%%%%
peak_distance = zeros(1,length(CC) - 1);
for i = 1:length(CC) - 1
    peak_distance(i) = polar_distance(dis(CC(i)),angle(CC(i)),dis(CC(i+1)),angle(CC(i+1)));

end

peak_distance


