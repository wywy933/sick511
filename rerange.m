function R = rerange( A )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
readcounter = 1;
xcounter = 1;
ycounter = 1;

if A(readcounter) == 20
        readcounter = readcounter + 1;
end

while(readcounter <= length(A))
    if A(readcounter) == 20
        readcounter = readcounter + 1;
        xcounter = 1;
        ycounter = ycounter + 1;
    else
        R(ycounter,xcounter) = A(readcounter);
        xcounter = xcounter + 1; 
        readcounter = readcounter + 1;
    end   
   
end

end

