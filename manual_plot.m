clc;
close all;
clear all;

scan6 = xlsread('scan6.xlsx');
scan7 = xlsread('scan7.xlsx');
scan8 = xlsread('scan8.xlsx');
scan9 = xlsread('scan9.xlsx');
scan10 = xlsread('scan10.xlsx');
scan11 = xlsread('scan11.xlsx');
scan12 = xlsread('scan12.xlsx');
scan13 = xlsread('scan13.xlsx');
scan14 = xlsread('scan14.xlsx');
scan15 = xlsread('scan15.xlsx');


plot3(scan6(:,1),scan6(:,2),scan6(:,3),'.r');
hold on;
grid on;
plot3(scan7(:,1),scan7(:,2),scan7(:,3),'.r');
hold on;
plot3(scan8(:,1),scan8(:,2),scan8(:,3),'.r');
hold on;
plot3(scan9(:,1),scan9(:,2),scan9(:,3),'.r');
hold on;
plot3(scan10(:,1),scan10(:,2),scan10(:,3),'.r');
hold on;
plot3(scan11(:,1),scan11(:,2),scan11(:,3),'.r');
hold on;
plot3(scan12(:,1),scan12(:,2),scan12(:,3),'.r');
hold on;
plot3(scan13(:,1),scan13(:,2),scan13(:,3),'.r');
hold on;
plot3(scan14(:,1),scan14(:,2),scan14(:,3),'.r');
hold on;
plot3(scan15(:,1),scan15(:,2),scan15(:,3),'.r');
hold on;
grid on;