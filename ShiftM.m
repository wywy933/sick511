function B = ShiftM(A)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

[Xmax,Ymax] = size(A);

for x = 1:Xmax
    ycountdown = Ymax - 1;
    while A(x,Ymax) == 0 && ycountdown ~= 0
        for y = 0:1:Ymax - 2
            A(x,Ymax - y) = A(x,Ymax - y - 1);
            
        end
        A(x,1) = 0;
        ycountdown = ycountdown -1;
    end
end
B = A;

end

