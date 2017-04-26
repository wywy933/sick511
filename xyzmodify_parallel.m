function output = xyzmodify_parallel( A, Angle_max, Angle_min , z_offset)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Num_total = length(A);
Angle_step = (Angle_max - Angle_min) / Num_total;

Angle_stack = Angle_min + Angle_step;

output = zeros(3,Num_total);

for n = 1:1:Num_total
    
    output(1,n) = A(n) * cos(Angle_stack);
    output(2,n) = A(n) * sin(Angle_stack);
    output(3,n) = z_offset;
    Angle_stack = Angle_stack + Angle_step;

end

