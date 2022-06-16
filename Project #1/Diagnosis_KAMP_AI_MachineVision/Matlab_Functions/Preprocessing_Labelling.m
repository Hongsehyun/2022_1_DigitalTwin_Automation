function [Processed_Label] = Preprocessing_Labelling(LabelData)
%%
label_unprocessed_size = size(LabelData);
label_unprocessed_size = label_unprocessed_size(1);

for i=1:label_unprocessed_size
    if (LabelData(i) < 1.5) && (LabelData(i) > 0.8)
        Processed_Label(i,1) = 1;
    else
        Processed_Label(i,1) = 0;
    end
end