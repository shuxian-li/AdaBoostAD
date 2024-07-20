clc;clear

% Delete classes which contain samples less than 10 for all datasets
% data_set = {'balance','contraceptive','ecoli','glass','hayesroth','newthyroid','pageblocks','penbased','shuttle','thyroid','wine','yeast'};
% 'ecoli01','ecoli1','ecoli2','ecoli3','haberman','newthyroid1','newthyroid2','yeast3'
% Sampling_name_set = {'none','ADASYN'};
% Method_name_set = {'AdaM1','AdaM2','AdaNC9','AdaBoostAD'};
data_set = {'balance'};
Sampling_name_set = {'none'};
Method_name_set = {'AdaBoostAD'};

for data_i = 1:length(data_set)
    data_name = data_set{data_i};
    save_path_data = ['results_save/',data_name,'/'];
    
    %% load data
    dataset_path = 'dataset/';
    load([dataset_path data_name]);

    %% data info
    [~,~,label] = unique(label);
    data = [data,label];  % Combine data and label for later process
    [data,label,C,class] = data_decomposition(data,label);  % data is sorted by label from small to large
    data_num = size(data, 1);
    class_num = length(class);

    T = 50;  % Training epoch
    re = 10;  % Times of repetition
    k = 5;  % k-fold
    
    %% check data
    if exist(save_path_data)==0  % If data folder doesn't exist
        mkdir(save_path_data);  % Creat data folder
        
        %% k-fold
        for t = 1:re
            for j = 1:class_num
                indices_c{t,j} = crossvalind('Kfold',length(C{j}),k);
                if length(indices_c{t,j})>size(C{j},1)
                    n = length(indices_c{t,j})-size(C{j},1);
                    indices_c{t,j} = indices_c{t,j}(1:end-n);
                end
            end
        end
        save([save_path_data,data_name,'_indices'],'indices_c');

        %% train
        train
    else
        %% train
        train
    end
    clc;clearvars -EXCEPT data_set Method_name_set Sampling_name_set T
end

performance