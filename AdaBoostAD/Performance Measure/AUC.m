function [mauc] = AUC(Y,P,Uc)
numcls = length(Uc);
auc = zeros(numcls,numcls-1);
for i = 1:numcls
    auc_tmp = zeros(1,numcls);
    for j = 1:numcls 
        if j ~= i
            idx_p = find(Y==i);
            idx_n = find(Y==j);
            yp = Y(idx_p);
            yn = Y(idx_n);
            pp = P(idx_p);
            pn = P(idx_n);
            sum = 0;
            for k = 1:length(yp)
                for m = 1:length(yn)
                    if pp(k) > pn(m)
                        sum = sum + 1;
                    end
                    if pp(k) == pn(m)
                        sum = sum + 0.5;
                    end
                end
            end
            auc_tmp(j) = sum/(length(yp)*length(yn));
        end
    end
    auc_tmp(i) = [];
    auc(i,:) = auc_tmp;
end
mauc = mean(mean(auc));

end

