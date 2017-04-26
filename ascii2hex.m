function Out = ascii2hex( x )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% switch x
%     case 0
%         Out = 0;
%     case 30
%         Out = 0;
%     case 31
%         Out = 1;
%     case 32
%         Out = 2;
%     case 33
%         Out = 3;
%     case 34
%         Out = 4;
%     case 35
%         Out = 5;
%     case 36
%         Out = 6;
%     case 37
%         Out = 7;
%     case 38
%         Out = 8;
%     case 39
%         Out = 9;
%     case 41
%         Out = dec2hex(10);
%     case 42
%         Out = dec2hex(11);
%     case 43
%         Out = dec2hex(12);
%     case 44
%         Out = dec2hex(13);
%     case 45
%         Out = dec2hex(14);
%     case 46
%         Out = 'Ox15';
%     otherwise
%         Out = 99;
        if x >= 30 && x <= 39
            Out = x - 30;
        else if x >= 41 && x <= 46
                Out = x - 41 + 10;
            else if x == 0
                    Out = 0;
            else
                Out = 99;
            end
        end

end

