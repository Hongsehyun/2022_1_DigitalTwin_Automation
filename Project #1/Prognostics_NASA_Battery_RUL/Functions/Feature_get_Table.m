function Discharge_Feature_Table = Feature_get_Table(data_number, voltage_criteria, column_Name_1, column_Name_2) 

New_column_Name = zeros(1,1)

Feature_Rmeas      = zeros(168,1);
Feature_Slope      = zeros(168,1);
Feature_Kneepoint  = zeros(168,1);
Feature_Tadd       = zeros(168,1);

Feature_Rmeas(:,1) = Feature_get_Rmeas(data_number(1,:));
[Feature_Slope(:,1), Feature_Kneepoint(:,1), Feature_Tadd(:,1)] = Feature_get_Slope_Kneepoint_Tadd(data_number(1,:), voltage_criteria(1,:), column_Name_1(1,:));
    
New_column_Name(:,1)     = string(column_Name_1(1,:)) + '_' + string(column_Name_2(:,:));

Discharge_Feature        = [Feature_Rmeas(:,1) Feature_Slope(:,1), Feature_Kneepoint(:,1) Feature_Tadd(:,1)];
Discharge_Feature_Table  = array2table(Discharge_Feature, "VariableNames", New_column_Name(:,1));

end
