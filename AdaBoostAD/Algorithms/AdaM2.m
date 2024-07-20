function [alpha,h] = AdaM2( class,C,X,Y,T )
%% precompute
n_all = length(Y);  % Number of samples
class_num = length(class);  % Number of classes

for i = 1:class_num
    [size_c(i),~] = size(C{i});
    weight{i} = n_all/size_c(i)*ones(1,size_c(i));
    ratio{i} = size_c(i)/n_all*ones(1,size_c(i));
end
% dw = exp(dw);
weight = cell2mat(weight)';
% weight = weight/min(weight);
ratio = cell2mat(ratio)';

X_train = X;
Y_train = Y;

%% initialization
d(:,:,1) = ones(n_all,class_num)/(n_all*(class_num-1));   %distribution
for i = 1:n_all
    Y_else_i = setdiff(class,Y_train(i));
    D(i,1) = sum(d(i,Y_else_i,1));
end
% D_c(:,1) = ones(class_num,1);
% for i = 1:n_all
%     Y_else_i = setdiff(class,Y_train(i));
%     D(i,Y_else_i,1) = weight(i);
% end
% D(:,1) = weight/sum(weight);

t = 1;

%% training
results_record = zeros(n_all,class_num);
while t <= T
    sum1 = 0;
    sum2 = 0;
    % tree_t
    h{t} = fitctree(X_train,Y_train,'weight',D(:,t),'Prune','on');
    results(:,t) = predict(h{t},X);
    [Gmean(t),recall(:,t),precesion(:,t)] = f_Gmean(Y,results(:,t),class);
    
    %% Compute alpha
    err = 0;
    for i = 1:n_all
        if results(i,t)~=Y(i)
            Y_else_i = setdiff(class,Y_train(i));
            err = err + (sum(d(i,Y_else_i,t))+d(i,results(i,t),t))/2;
        end
    end
    alpha(t) = log((1-err)/(err+eps));
    
    %% Update D
    for i = 1:n_all
        Y_else_i = setdiff(class,Y_train(i));
        if results(i,t)==Y(i)
            % d(i,Y_train(i),t+1) = d(i,Y_train(i),t)*exp(abs(alpha(t)));
            d(i,Y_else_i,t+1) = d(i,Y_else_i,t).*exp(-abs(alpha(t)));
        else
            % d(i,Y_train(i),t+1) = d(i,Y_train(i),t);
            d(i,Y_else_i,t+1) = d(i,Y_else_i,t).*exp(-abs(alpha(t))/2);
            d(i,results(i,t),t+1) = d(i,results(i,t),t);
        end
        D(i,t+1) = sum(d(i,Y_else_i,t));
    end
      Z = sum(D(:,t+1))+eps;
      D(:,t+1) = D(:,t+1)/Z;
      d(:,:,t+1) = d(:,:,t+1)/Z;
    
    t = t+1;
end
T = t-1;

end

