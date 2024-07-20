function [ H ] = prediction( X,Y,alpha,h,T )
[n,~] = size(X);
class = unique(Y);
m = length(class);
% sum_base = zeros(n,m);
for t = 1:T
    sum_base = zeros(n,m);
    for i = 1:m
        for j = 1:t
            if alpha(j) < 0
                alpha(j) = 0;
            end
            results(:,j) = predict(h{j},X);
            base = alpha(j).*(results(:,j)==class(i));
            sum_base(:,i) = sum_base(:,i)+base;
        end
    end
    [~,index] = max(sum_base');
    H(:,t) = class(index);
end

end

