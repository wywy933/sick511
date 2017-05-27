function [ output_distance, output_angle] = HighLight_detect( RSSI,distance,angle )
%HighLight_detect checking RSSI value of 255, output HLed distance n angle
%
output_angle = [];
output_distance = [];

for i = 1:1:length(RSSI)
    if RSSI(i) == 255
        output_angle = [output_angle,angle(i)];
        output_distance = [output_distance,distance(i)];
    end
end

output = [output_distance;output_angle];

