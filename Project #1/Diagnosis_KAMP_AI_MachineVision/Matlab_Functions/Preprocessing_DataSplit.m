function [TrainData, TestData] = Preprocessing_DataSplit(X, Divide_Criteria)
%% Setting
size_of_Data      = size(X);
Number_of_Data    = size_of_Data(1);
%% Data Dividing
cv = cvpartition(Number_of_Data, 'Holdout', Divide_Criteria);   % If Divide_Criteria is 0.3,   then, 70% Train Data,   30% Test Data
testData_index = test(cv);

TestData     = X(testData_index,:);
TrainData    = X(~testData_index,:);

% TestLabel    = Y(testData_index,:);
% TrainLabel   = Y(~testData_index,:);
end
