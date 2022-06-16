function [Knn_CrossValication_Error, Knn_Train_Loss, Knn_Test_Loss, fig] = ML_KnnTrain(TrainDataTable, TrainLabelTable, TestDataTable, TestLabelTable, kFold)
%% KNN - Train
k                         = 1;
Knn_Mdl                   = fitcknn(TrainDataTable, TrainLabelTable);

TrainLabelTable_cell      = table2cell(TrainLabelTable);
rng('default');
Knn_cv                    = cvpartition(TrainLabelTable_cell, 'KFold', kFold);  % Prepare for k-fold.   First parameter Should be 'Cell' Type.
Knn_cvml                  = crossval(Knn_Mdl, 'CVPartition', Knn_cv);

Knn_predictClass_Train    = resubPredict(Knn_Mdl); 
% Knn_predictClass_Train    = predict(Knn_Mdl, TrainDataTable); 
%% KNN - Predict test data
Knn_predictClass_Test     = predict(Knn_Mdl, TestDataTable); 
TestLabelTable_cell       = table2cell(TestLabelTable);
%% Print
Knn_CrossValication_Error = kfoldLoss(Knn_cvml)

Knn_Train_Loss            = resubLoss(Knn_Mdl)
% Knn_Train_Loss            = loss(Knn_Mdl, TrainDataTable, TrainLabelTable)
Knn_Test_Loss             = loss(Knn_Mdl, TestDataTable, TestLabelTable)

fig = figure;
subplot(2,1,1);   confusionchart(TrainLabelTable_cell, Knn_predictClass_Train);
subplot(2,1,2);   confusionchart(TestLabelTable_cell, Knn_predictClass_Test);
end
