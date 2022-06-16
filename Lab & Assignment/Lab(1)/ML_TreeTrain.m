function [Tree_CrossValication_Error, Tree_Train_Loss, Tree_Test_Loss, fig] = ML_TreeTrain(TrainDataTable, TrainLabelTable, TestDataTable, TestLabelTable, kFold)
%% Decision Tree - Train
Tree_Mdl                    = fitctree(TrainDataTable, TrainLabelTable);
 
TrainLabelTable_cell        = table2cell(TrainLabelTable);
rng('default');
Tree_cv                     = cvpartition(TrainLabelTable_cell, 'KFold', kFold);  % Prepare for k-fold.   First parameter Should be 'Cell' Type.
Tree_cvml                   = crossval(Tree_Mdl, 'CVPartition', Tree_cv);

Tree_predictClass_Train     = resubPredict(Tree_Mdl); 
% Tree_predictClass_Train     = predict(Tree_Mdl, TrainDataTable); 
%% Decision Tree - Predict test data
Tree_predictClass_Test      = predict(Tree_Mdl, TestDataTable);  % 내가 구한 모델에 대해 Predict
TestLabelTable_cell         = table2cell(TestLabelTable);
%% Print
Tree_CrossValication_Error = kfoldLoss(Tree_cvml)

Tree_Train_Loss            = resubLoss(Tree_Mdl)
% Tree_Train_Loss             = loss(Tree_Mdl, TrainDataTable, TrainLabelTable)
Tree_Test_Loss             = loss(Tree_Mdl, TestDataTable, TestLabelTable)

fig = figure;
subplot(2,1,1);   confusionchart(TrainLabelTable_cell, Tree_predictClass_Train);
subplot(2,1,2);   confusionchart(TestLabelTable_cell, Tree_predictClass_Test);
end
