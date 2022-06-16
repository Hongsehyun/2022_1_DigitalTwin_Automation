function [X_trainData, Y_trainData, X_testData, Y_testData] = Divide_Train_Test(Table, Divide_Criteria)
%% Setting
size_of_Table     = size(Table);
Number_of_Columns = size_of_Table(2);
Number_of_Data    = size_of_Table(1);
%% Data Dividing
cv = cvpartition(Number_of_Data, 'Holdout', Divide_Criteria);   % If Divide_Criteria is 0.3,   then, 70% Train Data,   30% Test Data
testData_index = test(cv);

TestData    = Table(testData_index,:);
TrainData   = Table(~testData_index,:);

X_trainData = TrainData(:,1:Number_of_Columns-1);
Y_trainData = TrainData(:,Number_of_Columns);
X_testData  = TestData(:,1:Number_of_Columns-1);
Y_testData  = TestData(:,Number_of_Columns);
end
