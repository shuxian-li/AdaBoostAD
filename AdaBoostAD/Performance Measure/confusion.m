function [ N,kindY,kindH ] = confusion( testY,testH,class )
N = zeros(length(class),length(class));
for i = 1:length(testY)
    cmpY = testY(i) == class;
    kindY(i) = find(cmpY == 1);
    cmpH = testH(i) == class;
    kindH(i) = find(cmpH == 1);
    N(kindY(i),kindH(i)) = N(kindY(i),kindH(i))+1;           
end
end

