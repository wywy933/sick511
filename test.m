close all; clear all;clc;

A = [1 0 1 1 0 0;1 0 2 0 0 0]
A = ShiftM(A);
A
% 
% [Xmax,Ymax] = size(A);
% 
% for x = 1:Xmax
% ycountdown = Ymax - 1;
% while A(x,Ymax) == 0 && ycountdown ~= 0
%     for y = 0:1:Ymax - 2
%         A(x,Ymax - y) = A(x,Ymax - y - 1);
%         
%     end
%       A(x,1) = 0;
%      ycountdown = ycountdown -1;
% end
% end
% A