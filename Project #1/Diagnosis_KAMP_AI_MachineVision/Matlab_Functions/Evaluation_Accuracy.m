function [Accuracy_Table_L, Accuracy_Table_R] = Evaluation_Accuracy(KNN_TestLoss_L, SVM_TestLoss_L, TREE_TestLoss_L, ColumnIndex_L, KNN_TestLoss_R, SVM_TestLoss_R, TREE_TestLoss_R, ColumnIndex_R)
%%
Accuracy_Knn_Test_Loss_L   = (1 - KNN_TestLoss_L)*100;
Accuracy_SVM_Test_Loss_L   = (1 - SVM_TestLoss_L)*100;
Accuracy_Tree_Test_Loss_L  = (1 - TREE_TestLoss_L)*100;
Accuracy_Array_L           = [Accuracy_Knn_Test_Loss_L ; Accuracy_SVM_Test_Loss_L ; Accuracy_Tree_Test_Loss_L ];

Accuracy_Knn_Test_Loss_R   = (1 - KNN_TestLoss_R)*100;
Accuracy_SVM_Test_Loss_R   = (1 - SVM_TestLoss_R)*100;
Accuracy_Tree_Test_Loss_R  = (1 - TREE_TestLoss_R)*100;
Accuracy_Array_R           = [Accuracy_Knn_Test_Loss_R ; Accuracy_SVM_Test_Loss_R ; Accuracy_Tree_Test_Loss_R ];

RowIndex = ['KNN ' ; 'SVM ' ; 'Tree' ];
Accuracy_Table_L = array2table(Accuracy_Array_L ,'RowNames',string(RowIndex),'VariableNames',string(ColumnIndex_L) );
Accuracy_Table_R = array2table(Accuracy_Array_R ,'RowNames',string(RowIndex),'VariableNames',string(ColumnIndex_R) );
end
