function [Train_Data_select, Test_Data_select, k_fold_accuracy, k_fold_accuracy_select, Loss_accuracy, Loss_accuracy_select] = Selection_SFS(TrainData,TrainLabelData,TestData,TestLabelData,Kfold)
%% Prepare Cross-Validation Data
rng(0) 
Y = height(TrainData);                   % Size of table
cv = cvpartition(Y,'KFold',Kfold)        % k-fold
%% Sequential Feature Selection
% For KNN
% Set up loss function to evaluate the performance
lossfun = 'mincost';

k = 1;
fun = @(XT,yT,Xt,yt)loss(fitcknn(XT,yT, 'NumNeighbors', k, 'Standardize',1), Xt, yt, 'Lossfun', lossfun);

% dir = 'forward';
TrainData_array       = table2array(TrainData);
TrainLabelData_array  = table2array(TrainLabelData);

dir = 'forward';   % direction of selection(forward/backward)
opts = statset('Display','iter');
[inmodel, history] = sequentialfs(fun, TrainData_array, TrainLabelData_array, 'cv', cv, 'options', opts, 'direction', dir)
%% K-fold Loss of All features vs Selected features
% K-fold Loss of all features
knn_mdl    = fitcknn(TrainData_array, TrainLabelData_array);
knn_cvmdl  = crossval(knn_mdl, k=Kfold);   % Performs stratified 10-fold cross-validation
k_fold_accuracy   = 1 - kfoldLoss(knn_cvmdl)

% K-fold Loss of selected features
TestData_array         = table2array(TestData);
TestLabelData_array  = table2array(TestLabelData);

idx_select = find(inmodel);     
Train_Data_array_select  =  TrainData_array(:, idx_select);
Test_Data_array_select   =  TestData_array(:, idx_select);
Train_Data_select  =  TrainData(:, idx_select);
Test_Data_select   =  TestData(:, idx_select);

mdl_select         = fitcknn(Train_Data_array_select, TrainLabelData_array);
cvmdl_select       = crossval(mdl_select, k=Kfold); 
k_fold_accuracy_select    = 1 - kfoldLoss(cvmdl_select)
%% Loss of Test Dataset: All features vs Selected features
% Test Loss of all  features
error         = loss(knn_mdl, TestData_array, TestLabelData_array);
Loss_accuracy = 1-error
% Test Loss of selected  features
error_select         = loss(mdl_select, Test_Data_array_select, TestLabelData_array);
Loss_accuracy_select = 1-error_select
end
