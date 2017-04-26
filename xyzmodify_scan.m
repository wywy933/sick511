function [ output ] = xyzmodify_scan( distance,angle_min,angle_max,scan_angle )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Num_total = length(distance);
Angle_step = (angle_max - angle_min) / Num_total;
Angle_stack = angle_min + Angle_step;

output = zeros(Num_total,3);

for n = 1:1:Num_total
    pjr = distance(n) * cos(scan_angle); % pjr stands for projected r
    
    output(n,1) = pjr * cos(Angle_stack);
    output(n,2) = pjr * sin(Angle_stack);
    output(n,3) = distance(n) * sin(scan_angle);
    Angle_stack = Angle_stack + Angle_step;
end


end

