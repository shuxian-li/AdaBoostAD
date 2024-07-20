function [data,label,C,class] = data_decomposition(data,label)
data_num = length(label);
class = unique(label); % kinds of classes
class_num = length(class); % number of classes
n = zeros(class_num,1);
data_save = [];
label_save = [];
for j = 1:class_num
    for i = 1:data_num
        if label(i) == class(j)
            n(j) = n(j)+1;
            C{j}(n(j),:) = data(i,:);
            index_c{j}(n(j)) = i;
        end
    end
    data_save = [data_save;C{j}];
    label_save = [label_save;class(j)*ones(n(j),1)];
end
data = data_save;
label = label_save;

end

