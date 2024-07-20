%% AdaNC

lam = 9;
[Alpha{t,i},Hh{t,i}] = AdaNC( class,C_train,train_data,train_label,lam,T );
test_predict{t,i} = prediction( test_data,test_label{t,i},Alpha{t,i},Hh{t,i},T );