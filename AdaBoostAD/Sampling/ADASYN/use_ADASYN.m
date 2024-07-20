function [C] = use_ADASYN(C)

adasyn_beta                     = [];   %let ADASYN choose default
adasyn_kDensity                 = [];   %let ADASYN choose default
adasyn_kSMOTE                   = [];   %let ADASYN choose default
adasyn_featuresAreNormalized    = false;    %false lets ADASYN handle normalization

class_num = length(C);
for i = 1:class_num
    [size_c(i),~] = size(C{i});
end
[max_c,max_i] = max(size_c);
features1 = C{max_i}(:,1:end-1);
labels1 = ones(max_c,1);
for i = 1:class_num
    if size_c(i) < max_c
        features0 = C{i}(:,1:end-1);
        label = unique(C{i}(:,end));
        labels0 = zeros(size_c(i),1);

        adasyn_features = [features0; features1];
        adasyn_labels = [labels0; labels1];
        [adasyn_featuresSyn, adasyn_labelsSyn] = ADASYN(adasyn_features, adasyn_labels, adasyn_beta, adasyn_kDensity, adasyn_kSMOTE, adasyn_featuresAreNormalized);
        I  = find(adasyn_labelsSyn == 0);
        C_nolabel{i} = adasyn_featuresSyn(I,:);
        C{i} = [C{i};[C_nolabel{i},label*ones(length(I),1)]];
        
    end
end

end

