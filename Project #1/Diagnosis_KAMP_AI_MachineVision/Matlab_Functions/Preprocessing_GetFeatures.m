function [FeatureTable] = Preprocessing_GetFeatures(Data, Breakpoint, ColumnIndex)
%%
Size_data            = size(Data);
RowSize_data         = Size_data(1);

data_AAV             = zeros(RowSize_data,1);
data_PEAK            = zeros(RowSize_data,1);

data_SRA             = zeros(RowSize_data,1);
data_KV              = zeros(RowSize_data,1);
data_SK              = zeros(RowSize_data,1);
data_P2P             = zeros(RowSize_data,1);
data_IF              = zeros(RowSize_data,1);
data_MF              = zeros(RowSize_data,1);

data_MEAN            = zeros(RowSize_data,1);
data_MAX             = zeros(RowSize_data,1);
data_MIN             = zeros(RowSize_data,1);

for i=1:RowSize_data
    data_sliced    = Data(i,1:Breakpoint(i));
    
    N=length(data_sliced);
    data_AAV(i,1)  = sum(abs(data_sliced))/N;
    data_PEAK(i,1) = max(abs(data_sliced));
    
    % Statistical Features
    data_SRA(i,1)  = (sum( sqrt(abs(data_sliced)))/N).^2; 
    data_KV(i,1)   = kurtosis(data_sliced);            
    data_SK(i,1)   = skewness(data_sliced);
    data_P2P(i,1)  = peak2peak(data_sliced);
    data_IF(i,1)   = data_P2P(i,1)/data_AAV(i,1);
    data_MF(i,1)   = data_PEAK(i,1)/data_SRA(i,1);

    % Additional Statistical Features
    data_MEAN(i,1) = mean(data_sliced); 
    data_MAX(i,1)  = max(data_sliced);
    data_MIN(i,1)  = min(data_sliced);
end

FeatureTable   = [data_SRA data_KV data_SK data_P2P data_IF data_MF data_MEAN data_MAX data_MIN];
FeatureTable   = array2table(FeatureTable, 'VariableNames',"L_"+ColumnIndex);

end