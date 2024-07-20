function [alpha,h] = AdaBoostAD( class,C,X,Y,lam,T,rou )
%% precompute
n_all = length(Y);  % Number of samples
class_num = length(class);  % Number of classes

rou = rou'/mean(rou);  % density normalization

for i = 1:class_num
    [size_c(i),~] = size(C{i});
    weight{i} = n_all/size_c(i)*ones(1,size_c(i));
    ratio{i} = size_c(i)/n_all*ones(1,size_c(i));
    ratio_c(i) = size_c(i)/n_all;
    
    y_index = find(Y == i);

    if lam ~= 0
        dp(y_index) = softmax(-rou(y_index)*lam);
        if max(dp(y_index))~=0
            dw(y_index) = (dp(y_index))./mean(dp(y_index));
        else
            dw(y_index) = 1;
        end
    else
        dw(y_index) = 1;
    end
end

dw = dw';
weight = cell2mat(weight)';
ratio = cell2mat(ratio)';

X_train = X;
Y_train = Y;

%% initialization
D(:,1) = ones(n_all,1);  % distribution
D(:,1) = D(:,1)/(sum(D(:,1))+eps);
eta(:,1) = ones(n_all,1);

t = 1;

%% training
while t <= T
    sum1 = 0;
    sum2 = 0;
    %% tree_t
    h{t} = fitctree(X_train,Y_train,'weight',D(:,t),'Prune','on');
    results(:,t) = predict(h{t},X);
    
    %% Compute alpha
    for i = 1:n_all
        if results(i,t)==Y(i)
            sum1 = sum1 + D(i,t);
        else
            sum2 = sum2 + D(i,t);
        end
    end
    alpha(t) = log(sum1/(sum2+eps)); 
    
    %% ensemble
    sum_base = zeros(n_all,class_num);
    sum_corr = zeros(n_all,class_num);
    for i = 1:class_num
        for tt = 1:t
            if alpha(tt) < 0
                alpha(tt) = 0;
            end
        end
    end
    alphaN = alpha;
    for i = 1:class_num
        for tt = 1:t
            base(:,i,tt) = alphaN(tt).*(results(:,tt)==class(i));
            sum_base(:,i) = sum_base(:,i) + base(:,i,tt);
            corr(:,i,tt) = results(:,tt)==class(i);
            sum_corr(:,i) = sum_corr(:,i) + corr(:,i,tt);
        end
    end
    p = softmax(sum_base');
    p = p';

    for i = 1:n_all
        Y_else_i = setdiff(class,Y_train(i));
        delta(i,t+1) = p(i,Y_train(i))-max(p(i,Y_else_i))+1;
        w(i) = ratio_c(Y_train(i))./min(ratio_c);
    end
    w = reshape(w,n_all,1);
    eta(:,t+1) = exp(-delta(:,t+1).*w.*dw);
    
    
    %% Update D
    for i = 1:n_all
        Y_else_i = setdiff(class,Y_train(i));
        if results(i,t)==Y(i)
            D(i,t+1) = eta(i,t+1).*D(i,t)*exp(-abs(alpha(t)));
        else
            D(i,t+1) = eta(i,t+1).*D(i,t);
        end
    end
      D(:,t+1) = D(:,t+1)/(sum(D(:,t+1))+eps);

    %%
    [~,index_t] = max(p');
    H(:,t) = class(index_t);

    correct_rate = sum(H(:,t) == Y)/n_all;
    N = confusion( Y,H(:,t),class );
    for i = 1:class_num
        Recall(i) = N(i,i)/sum(N(i,:));
        precision(i) = N(i,i)/sum(N(:,i));
    end
    Gmean(t) = prod(Recall)^(1/class_num);
    
    t = t+1;
end
T = t-1;

end

