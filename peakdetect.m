function [ max,min,i_order ] = peakdetect( array,threshold )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
max = [];
min = [];
i_order = [];

max_value = -Inf;
min_value = Inf;
max_i = NaN;
min_i = NaN;

lookingformax = 1;

for i = 1:length(array)
    this = array(i);
    if this > max_value, max_value = this; max_i = i; end
    if this < min_value, min_value = this; min_i = i; end
    
    if lookingformax
        if this < max_value - threshold
            max = [max; max_value max_i];
            i_order = [i_order , max_i];
            min_value = this;
            lookingformax = 0;
        end
    else
        if this > min_value + threshold
            min = [min; min_value min_i];
            i_order = [i_order , min_i];
            max_value = this;
            lookingformax = 1;
        end
    end
    
    
    
end

