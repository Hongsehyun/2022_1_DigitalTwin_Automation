function [Knn_Test_Loss, SVM_Test_Loss, Tree_Test_Loss] = KNN_SVM_TREE(TrainDataTable, TrainLabelTable, TestDataTable, TestLabelTable, kFold)
%% KNN - Train
k = 3
Knn_Mdl                   = fitcknn(TrainDataTable, TrainLabelTable,'NumNeighbors',k);
% Knn_Mdl                   = fitcknn(TrainDataTable, TrainLabelTable);
TrainLabelTable_cate      = table2array(TrainLabelTable);
TestLabelTable_cate       = table2array(TestLabelTable);
rng('default');
Knn_cv                    = cvpartition(TrainLabelTable_cate, 'KFold', kFold);  % Prepare for k-fold.   First parameter Should be 'Cell' Type.
Knn_cvml                  = crossval(Knn_Mdl, 'CVPartition', Knn_cv);
Knn_predictClass_Train    = predict(Knn_Mdl, TrainDataTable); 

% KNN - Predict test data
Knn_predictClass_Test     = predict(Knn_Mdl, table2array(TestDataTable)); 

% Print
Knn_CrossValication_Error = kfoldLoss(Knn_cvml)
Knn_Train_Loss            = resubLoss(Knn_Mdl);
Knn_Train_Loss            = loss(Knn_Mdl, TrainDataTable, TrainLabelTable)
Knn_Test_Loss             = loss(Knn_Mdl,  table2array(TestDataTable), TestLabelTable_cate)

figure;
subplot(2,3,1);   confusionchart(TrainLabelTable_cate, Knn_predictClass_Train);   title("KNN Train")
subplot(2,3,4);   confusionchart(TestLabelTable_cate, Knn_predictClass_Test);     title("KNN Test")
%% SVM - Train
t                         = templateSVM('Standardize',true,'KernelFunction','gaussian');
SVM_Mdl                   = fitcecoc(TrainDataTable,TrainLabelTable,'Learners',t,'FitPosterior',true);

TrainLabelTable_cate      = table2array(TrainLabelTable);
TestLabelTable_cate       = table2array(TestLabelTable);

rng('default');
SVM_cv                    = cvpartition(TrainLabelTable_cate, 'KFold', kFold);  % Prepare for k-fold.   First parameter Should be 'Cell' Type.
SVM_cvml                  = crossval(SVM_Mdl, 'CVPartition', SVM_cv);
SVM_predictClass_Train    = predict(SVM_Mdl, TrainDataTable); 

% SVM - Predict test data
SVM_predictClass_Test     = predict(SVM_Mdl,  table2array(TestDataTable)); 

% Print
SVM_CrossValication_Error = kfoldLoss(SVM_cvml)
SVM_Train_Loss            = resubLoss(SVM_Mdl);
SVM_Train_Loss            = loss(SVM_Mdl, TrainDataTable, TrainLabelTable)
SVM_Test_Loss             = loss(SVM_Mdl,  table2array(TestDataTable), TestLabelTable_cate)

subplot(2,3,2);   confusionchart(TrainLabelTable_cate, SVM_predictClass_Train);   title("SVM Train")
subplot(2,3,5);   confusionchart(TestLabelTable_cate, SVM_predictClass_Test);     title("SVM Test")
%% Decision Tree - Train
Tree_Mdl                    = fitctree(TrainDataTable, TrainLabelTable);

TrainLabelTable_cate      = table2array(TrainLabelTable);
TestLabelTable_cate       = table2array(TestLabelTable);

rng('default');
Tree_cv                     = cvpartition(TrainLabelTable_cate, 'KFold', kFold);  % Prepare for k-fold.   First parameter Should be 'Cell' Type.
Tree_cvml                   = crossval(Tree_Mdl, 'CVPartition', Tree_cv);
Tree_predictClass_Train     = predict(Tree_Mdl, TrainDataTable); 

% Decision Tree - Predict test data
Tree_predictClass_Test      = predict(Tree_Mdl, table2array(TestDataTable));  % 내가 구한 모델에 대해 Predict

% Print
Tree_CrossValication_Error = kfoldLoss(Tree_cvml)
Tree_Train_Loss            = resubLoss(Tree_Mdl);
Tree_Train_Loss            = loss(Tree_Mdl, TrainDataTable, TrainLabelTable)
Tree_Test_Loss             = loss(Tree_Mdl, table2array(TestDataTable), TestLabelTable_cate)

subplot(2,3,3);   confusionchart(TrainLabelTable_cate, Tree_predictClass_Train);   title("Tree Train")
subplot(2,3,6);   confusionchart(TestLabelTable_cate, Tree_predictClass_Test);     title("Tree Test")
end
