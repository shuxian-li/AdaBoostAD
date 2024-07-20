function [alpha,h] = AdaM1( class,C,X,Y,T )
%% precompute
n_all = length(Y);  % Number of samples
class_num = length(class);  % Number of classes

for i = 1:class_num
    [size_c(i),~] = size(C{i});
%     weight{i} = patch_size{i}*size_c/sum(patch_size{i});
    class_size{i} = size_c(i)*ones(1,size_c(i));
    weight{i} = n_all/size_c(i)*ones(1,size_c(i));
end
class_size = cell2mat(class_size)/min(size_c);
weight = cell2mat(weight);

X_train = X;
Y_train = Y;

%% initialization
D(:,1) = 1/n_all*ones(n_all,1);  %distribution
% D(:,1) = weight/sum(weight);

t = 1;
Gmean(t) = 0;
threshold = 1;

%% training
while t <= T
    sum1 = 0;
    sum2 = 0;
    % tree_t
    h{t} = fitctree(X_train,Y_train,'weight',D(:,t),'Prune','on');
    results(:,t) = predict(h{t},X);
    [Gmean(t),recall(:,t),precesion(:,t)] = f_Gmean(Y,results(:,t),class);
    
    %% Compute alpha
    for i = 1:n_all
        if results(i,t)==Y(i)
            sum1 = sum1 + D(i,t);
        else
            sum2 = sum2 + D(i,t);
        end
    end
    alpha(t) = log(sum1/(sum2+eps)); 
    

    for i = 1:n_all
        if results(i,t)==Y(i)
            D(i,t+1) = D(i,t)*exp(-abs(alpha(t)));
        else
            D(i,t+1) = D(i,t);
        end
    end

    D(:,t+1) = D(:,t+1)/(sum(D(:,t+1))+eps);
    
    %% ensemble
    sum_base = zeros(n_all,class_num);
    for i = 1:class_num
        for tt = 1:t
            if alpha(tt) < 0
                alpha(tt) = 0;
            end
            base(:,i,tt) = alpha(tt).*(results(:,tt)==class(i));
            sum_base(:,i) = sum_base(:,i) + base(:,i,tt);
        end
    end
    [~,index_t] = max(sum_base');
    H(:,t) = class(index_t);

    correct_rate = sum(H(:,t) == Y)/n_all;
    N = confusion( Y,H(:,t),class );
    for i = 1:class_num
        Recall(i) = N(i,i)/sum(N(i,:));
        precision(i) = N(i,i)/sum(N(:,i));
    end
    Gmean(t) = prod(Recall)^(1/class_num);
    
    if t == 1
        threshold = Gmean(t);
    else
        threshold = abs(Gmean(t) - Gmean(t-1));
    end
    
    t = t+1;
end
T = t-1;

end

