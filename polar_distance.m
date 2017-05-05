function [ distance_between ] = polar_distance( A_r, A_theta, B_r, B_theta )
% algorithm:
% AB^2 = OA^2 + OB^2 - 2 * OA * OB * cos(AOB)
%      = r1^2 + r2^2 - 2 * r1 * r2 * cos(theta2 - theta1)

angle_between = B_theta - A_theta;

distance = A_r * A_r + B_r * B_r - 2 * A_r * B_r * cos(angle_between);

distance_between = sqrt(distance);


end

