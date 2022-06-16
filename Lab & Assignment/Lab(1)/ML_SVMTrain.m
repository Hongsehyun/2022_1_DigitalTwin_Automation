function [SVM_CrossValication_Error, SVM_Train_Loss, SVM_Test_Loss, fig] = ML_SVMTrain(TrainDataTable, TrainLabelTable, TestDataTable, TestLabelTable, kFold)
%% SVM - Train
% t                         = templateSVM('Standardize',true,'KernelFunction','gaussian');
% SVM_Mdl                   = fitcecoc(TrainDataTable,TrainLabelTable,'Learners',t,'FitPosterior',true);
SVM_Mdl                   = fitcecoc(TrainDataTable,TrainLabelTable);

TrainLabelTable_cell      = table2cell(TrainLabelTable);
rng('default');
SVM_cv                    = cvpartition(TrainLabelTable_cell, 'KFold', kFold);  % Prepare for k-fold.   First parameter Should be 'Cell' Type.
SVM_cvml                  = crossval(SVM_Mdl, 'CVPartition', SVM_cv);

SVM_predictClass_Train    = resubPredict(SVM_Mdl); 
% SVM_predictClass_Train    = predict(SVM_Mdl, TrainDataTable); 
%% SVM - Predict test data
SVM_predictClass_Test     = predict(SVM_Mdl, TestDataTable); 
TestLabelTable_cell       = table2cell(TestLabelTable);
%% Print
SVM_CrossValication_Error = kfoldLoss(SVM_cvml)

SVM_Train_Loss            = resubLoss(SVM_Mdl)
% SVM_Train_Loss            = loss(SVM_Mdl, TrainDataTable, TrainLabelTable)
SVM_Test_Loss             = loss(SVM_Mdl, TestDataTable, TestLabelTable)

fig = figure;
subplot(2,1,1);   confusionchart(TrainLabelTable_cell, SVM_predictClass_Train);
subplot(2,1,2);   confusionchart(TestLabelTable_cell, SVM_predictClass_Test);
end