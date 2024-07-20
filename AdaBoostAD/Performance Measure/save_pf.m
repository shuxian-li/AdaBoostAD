function [input_epo_all, input_avg, input_std] = save_pf(input, sampling_name, data_i, Method_i, re, k, T)
input_name = inputname(1);
for t = 1:re
    for i=1:k
        input_epo(t,i) = input(t,i,T);
    end
end
input_avg = mean(mean(input_epo,2));
save_period_gmean = input_avg;

input_std = std(input_epo(:));
save_period_gstd = input_std;

input_epo_all = input_epo(:);
end

