function output = add_ascii_frame( s )
% add ascii STX and ETX at the beginning n end of the given cmd string.

output = [char(02),s,char(03)];
end

