function FeatureTable = Wavelet_Packet_FeatureTable(DE,FE,DataNumber,DevideNumber,Level,Daubechies_Wavelet_Mode,RowIndex)
%% Define Tables
FeatureTable       = table;
%% Data Slicing
slicing_length      = floor(DataNumber/DevideNumber);   % 120,000/15 = 8,000

    for i = 1 : DevideNumber
        sliced_data        = slicing_length*(i-1)+1 : slicing_length*i;
        sliced_DEdata      = DE(sliced_data, :);
        sliced_FEdata      = FE(sliced_data, :);
        
        % Wavelet Packet Decomposition Features
        wpt_DE             = wpdec(sliced_DEdata,Level,Daubechies_Wavelet_Mode); 
        wpt_FE             = wpdec(sliced_FEdata,Level,Daubechies_Wavelet_Mode); 
        Energy_DE          = wenergy(wpt_DE);
        Energy_FE          = wenergy(wpt_FE);
        EnergyDE_temp      = array2table(Energy_DE);
        EnergyFE_temp      = array2table(Energy_FE);
             
        ColumnIndex_EnergyDE    = string(EnergyDE_temp.Properties.VariableNames);      % Get EnergyDE Column Names
        ColumnIndex_EnergyFE    = string(EnergyFE_temp.Properties.VariableNames);      % Get EnergyFE Column Names
        
        Feature_temp       = [EnergyDE_temp, EnergyFE_temp];
        Feature_temp       = [table2array(Feature_temp)];
        Feature_temp       = array2table(Feature_temp,'RowNames',string(RowIndex)+'_'+string(i),'VariableNames',[ColumnIndex_EnergyDE,ColumnIndex_EnergyFE]);
               
        FeatureTable       = [FeatureTable ; Feature_temp];
    end
end