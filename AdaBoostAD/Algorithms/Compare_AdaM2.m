%% AdaM2

lam = -1;
[Alpha{t,i},Hh{t,i}] = AdaM2( class,C_train,train_data,train_label,T );
test_predict{t,i} = prediction( test_data,test_label{t,i},Alpha{t,i},Hh{t,i},T );