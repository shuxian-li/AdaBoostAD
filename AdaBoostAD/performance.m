%% Performance
for data_i = 1:length(data_set)
    %% load data
    data_name = data_set{data_i};
    save_path_data = ['results_save/',data_name,'/'];
    
    for samp_i = 1:length(Sampling_name_set)
        sampling_name = Sampling_name_set{samp_i}; 
        save_path_samp = [save_path_data,sampling_name,'/'];
        
        for Method_i = 1:length(Method_name_set)
           %% Save performance of every algorithm
            Method_name = Method_name_set{Method_i};
            save_path_method = [save_path_samp,Method_name,'/']; % algorithm folder in sampling folder
            %%%%%%
%             test_file = [save_path_samp,sampling_name,'_test_data'];
%             load([save_path_samp,sampling_name,'_test_data']);
            %%%%%%
            results_file = [save_path_method,data_name,'_',Method_name,'_results'];
            load(results_file); % load training results
            [re,k] = size(test_predict);
            class = unique(test_label{1,1});
            for t = 1:re
                for i = 1:k
                    if strcmp(Method_name, 'tkde')
                        [gmean(t,i),f1(t,i),Auc(t,i),Rp(t,i),recall{t,i},precision{t,i},acc(t,i)] = f_Gmean(test_label{t,i},test_predict{t,i},class);
                    else
                        for j = 1:T
    %                         test_data = save_test_data{t,i};
    %                         test_data = test_data(:,1:end-1);
    %                         test_predict{t,i} = prediction( test_data,test_label{t,i},Alpha{t,i},Hh{t,i},T );
                            [gmean(t,i,j),f1(t,i,j),Auc(t,i,j),Rp(t,i,j),recall{t,i,j},precision{t,i,j},acc(t,i,j)] = f_Gmean(test_label{t,i},test_predict{t,i}(:,j),class);
                        end
                    end
                end
            end
            % save(results_file,'par','Alpha','Hh','test_label','test_predict');
            
            % recall_save
            save_name = [data_name,'_',Method_name,'_recall'];
            save([save_path_method,save_name],'recall');
            
            % Gmean_save
            save_name = [data_name,'_',Method_name,'_gmean'];
            save([save_path_method,save_name],'gmean');
%             xlswrite([save_path_method,save_name],gmean);

            % Fmeasure_save
            save_name = [data_name,'_',Method_name,'_f1'];
            save([save_path_method,save_name],'f1');
            
            % Auc_save
            save_name = [data_name,'_',Method_name,'_Auc'];
            save([save_path_method,save_name],'Auc');
%             xlswrite([save_path_method,save_name],gmean);

            % Rp_save
            save_name = [data_name,'_',Method_name,'_Rp'];
            save([save_path_method,save_name],'Rp');

          %% Average（save in data folder）
            % recall
            class_num = length(class);
            recall_50 = zeros(re,k,class_num);
            for t = 1:re
                for i=1:k
                    recall_50(t,i,:) = recall{t,i,50};
                end
            end
            recall_avg_50{data_i,Method_i} = squeeze(mean(mean(recall_50,1),2));
            recall_std_50{data_i,Method_i} = std(reshape(recall_50,[re*k,class_num]));
            
            

            % Gmean
            [gmean_50{data_i,Method_i},gmean_avg_50(data_i,Method_i),gmean_std_50(data_i,Method_i)] = save_pf(gmean, sampling_name, data_i, Method_i, re, k, 50);

            % Fmeasure
            [f1_50{data_i,Method_i},f1_avg_50(data_i,Method_i),f1_std_50(data_i,Method_i)] = save_pf(f1, sampling_name, data_i, Method_i, re, k, 50);

            % Auc
            [Auc_50{data_i,Method_i},Auc_avg_50(data_i,Method_i),Auc_std_50(data_i,Method_i)] = save_pf(Auc, sampling_name, data_i, Method_i, re, k, 50);

            % Rp
            [Rp_50{data_i,Method_i},Rp_avg_50(data_i,Method_i),Rp_std_50(data_i,Method_i)] = save_pf(Rp, sampling_name, data_i, Method_i, re, k, 50);

            % acc
            [acc_50{data_i,Method_i},acc_avg_50(data_i,Method_i),acc_std_50(data_i,Method_i)] = save_pf(acc, sampling_name, data_i, Method_i, re, k, 50);
                
            
        end
    end
end
