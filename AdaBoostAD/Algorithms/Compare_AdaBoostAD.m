%% AdaBoostAD

lam = 1; % default value for density factor
[Alpha{t,i},Hh{t,i}] = AdaBoostAD( class,C_train,train_data,train_label,lam,T,rou );
test_predict{t,i} = prediction( test_data,test_label{t,i},Alpha{t,i},Hh{t,i},T );