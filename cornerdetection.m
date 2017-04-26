function [ isthereA, isthereV, Avalue_out, Aat_out, Vvalue_out, Vat_out ] =...
    cornerdetection(rerangedDistance,rerangedTheta)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

flag_threshold = 5;

[maxVal maxat] = max(rerangedDistance);
[minVal minat] = min(rerangedDistance);

isthereA = 0;
isthereV = 0;
Avalue_out = [];
Vvalue_out = [];
Aat_out = [];
Vat_out = [];
flag = 0;
if maxat >= 5 && maxat <= length(rerangedDistance) - 5
    isthereA = 1;
    Avalue = maxVal;
    Aat = maxat;
end

if minat >= 5 && minat <= length(rerangedDistance) - 5
    isthereV = 1;
    Vvalue = minVal;
    Vat = minat;
end

if isthereA ~= 0
    for i = 0:1:Aat - 2
        if max(rerangedDistance(1+i:Aat)) == Avalue
            flag = flag + 1;
        end
    end
    
    for i = Aat + 1:1:length(rerangedDistance)
        if max(rerangedDistance(Aat:i)) == Avalue
            flag = flag + 1;
        end
    end
    
    if flag >= flag_threshold
        Avalue_out = [Avalue_out Avalue];
        Aat_out = [Aat_out Aat];
    else
        Avalue_out = [Avalue_out 0];
        Aat_out = [Aat_out 0];
    end    
    
end

