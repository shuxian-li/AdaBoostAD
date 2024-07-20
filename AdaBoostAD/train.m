hwait=waitbar(0,'Computing...');

%% train
load([save_path_data,data_name,'_indices'],'indices_c');

for samp_i = 1:length(Sampling_name_set)
    sampling_name = Sampling_name_set{samp_i};
    save_path_samp = [save_path_data,sampling_name,'/'];
    if exist(save_path_samp)==0  % If sampling folder doesn't exist
        mkdir(save_path_samp); % Creat sampling folder
    end
        
    for Method_i = 1:length(Method_name_set)
        Method_name = Method_name_set{Method_i};
        save_path_method = [save_path_samp,Method_name,'/'];
%         if exist(save_path_method)==0  % If algorithm folder doesn't exist
%             mkdir(save_path_method); % Creat algorithm folder
%         end
        if exist(save_path_method)==0  % If algorithm folder doesn't exist
            mkdir(save_path_method); % Creat algorithm folder

            results_file = [save_path_method,data_name,'_',Method_name,'_results'];

            for t = 1:re
                rng(re)
                for i = 1:k
                    value = 100 * ((t-1)*k+i) / (re*k);
                    waitbar(((t-1)*k+i) / (re*k), hwait, sprintf([data_name,'(',sampling_name,')','(',Method_name,')','Computing:%3.2f%%'],value));
                  %% k-fold generation
                    for j = 1:class_num
                        C_test{j} = C{j}(indices_c{t,j} == i,:);
                        C_Train{j} = C{j}(indices_c{t,j} ~= i,:);
                    end
                    test_data = cell2mat(C_test');
                    test_file = [save_path_samp,sampling_name,'_test_data'];
                    if exist([test_file,'.mat'])==0
                        save_test_data{t,i} = test_data;
                    else
                        load([save_path_samp,sampling_name,'_test_data']);
                        test_data = save_test_data{t,i};
                    end
                    test_label{t,i} = test_data(:,end);
                    test_data = test_data(:,1:end-1);
                    
                  %% sampling
                    C_train = C_Train;
                    sampling_file = [save_path_samp,sampling_name,'_train_data'];
                    if exist([sampling_file,'.mat'])==0
                        run(['run_',sampling_name,'.m']);
                        save_train_data{t,i} = train_data;
                    else
                        load([save_path_samp,sampling_name,'_train_data']);
                        train_data = save_train_data{t,i};
                    end
                    train_label = train_data(:,end);
                    train_data = train_data(:,1:end-1);

                 %% precompute
                    [train_data,train_label,C_train,class] = data_decomposition(train_data,train_label); 
                    data_dist = pdist2(train_data,train_data);
                    [sort_distance,index] = sort(data_dist,2);
                    rou = density(train_label,sort_distance,index,5);
                    run(['Compare_',Method_name,'.m']);
                end
                
            end
            % results save
            save(sampling_file,'save_train_data');
            save(test_file,'save_test_data');
            save(results_file,'lam','Alpha','Hh','test_label','test_predict');
        end
        clearvars gmean f_measure recall precision N
    end
end

close(hwait);

