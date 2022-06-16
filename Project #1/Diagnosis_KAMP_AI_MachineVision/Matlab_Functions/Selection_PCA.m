function [TrainData_PCA_select, Test_PCA_select, pcaCenter, coeff] = Selection_PCA(TrainData, TestData)
%% Apply PCA
rng(0)
TrainData_array = table2array(TrainData);
[coeff, Train_Data_array_PCA, ~, ~, explained, pcaCenter] = pca(TrainData_array);
%% Select  PCA coefficient with 95% importance
% Returns Explained, the percentage of the total variance explained by each principal component
explained
% The number of components required to account for at least 95% variability. Let's see where the cumulative sum is 95.
explain_standard = .95;     
num = find(cumsum(explained)/sum(explained) >= explain_standard, 1)
%% Feature Reduction Analysis
coeff = coeff(:,1:num);
TrainData_PCA_select = Train_Data_array_PCA(:,1:num);

[n,p] = size(TrainData);
meanX = mean(TrainData_array,1);  

% Xfit: in original coordinate system
Xfit = repmat(meanX,n,1) + Train_Data_array_PCA(:,1:num)*coeff(:,1:num)';
%% Convert Test data to PCA reduced dimension
% Convert Test data from originial coordinate to PCA vectors
%  X_pca=(X-meanX)*inv(coeff')
TestData_array = table2array(TestData);

[ntest,~]        = size(TestData);
mu               = repmat(pcaCenter, ntest, 1);
Test_PCA_select  = (TestData_array - mu)/coeff';
end
