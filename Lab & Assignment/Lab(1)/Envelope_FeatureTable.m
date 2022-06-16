function FeatureTable = Envelope_FeatureTable(DE_DE,DE_FE,FE_DE,FE_FE,DataNumber,DevideNumber,Fs,DE_BPFI,DE_BPFO,DE_BSF,FE_BPFI,FE_BPFO,FE_BSF,RowIndex)
%% Define Tables
FeatureTable       = table;

DEDE_BPFI_6Harmonics = zeros(1,6);  DEDE_BPFO_6Harmonics = zeros(1,6);  DEDE_BSF_6Harmonics  = zeros(1,6);
DEFE_BPFI_6Harmonics = zeros(1,6);  DEFE_BPFO_6Harmonics = zeros(1,6);  DEFE_BSF_6Harmonics  = zeros(1,6);
FEDE_BPFI_6Harmonics = zeros(1,6);  FEDE_BPFO_6Harmonics = zeros(1,6);  FEDE_BSF_6Harmonics  = zeros(1,6);
FEFE_BPFI_6Harmonics = zeros(1,6);  FEFE_BPFO_6Harmonics = zeros(1,6);  FEFE_BSF_6Harmonics  = zeros(1,6);  

ColumnName = cell(4,18);
%% Data Slicing
slicing_length      = floor(DataNumber/DevideNumber);   % 120,000/15 = 8,000

    for i = 1 : DevideNumber
        sliced_data          = slicing_length*(i-1)+1 : slicing_length*i;
        sliced_DEDEdata      = DE_DE(sliced_data, :);
        sliced_DEFEdata      = DE_FE(sliced_data, :);
        sliced_FEDEdata      = FE_DE(sliced_data, :);
        sliced_FEFEdata      = FE_FE(sliced_data, :);
        
        [p_EnvDEDE, f_EnvDEDE, ~, ~] = envspectrum(sliced_DEDEdata, Fs);
        [p_EnvDEFE, f_EnvDEFE, ~, ~] = envspectrum(sliced_DEFEdata, Fs);
        [p_EnvFEDE, f_EnvFEDE, ~, ~] = envspectrum(sliced_FEDEdata, Fs);
        [p_EnvFEFE, f_EnvFEFE, ~, ~] = envspectrum(sliced_FEFEdata, Fs);
       
        
        for j = 1 : 6
            DEDE_BPFI_harmonics_index    = find( f_EnvDEDE > (DE_BPFI*0.99)*j   &   f_EnvDEDE < (DE_BPFI*1.01)*j );
            DEDE_BPFO_harmonics_index    = find( f_EnvDEDE > (DE_BPFO*0.99)*j   &   f_EnvDEDE < (DE_BPFO*1.01)*j );
            DEDE_BSF_harmonics_index     = find( f_EnvDEDE > (DE_BSF*0.99)*j    &   f_EnvDEDE < (DE_BSF*1.01)*j );
            
            DEFE_BPFI_harmonics_index    = find( f_EnvDEFE > (FE_BPFI*0.99)*j   &   f_EnvDEFE < (FE_BPFI*1.01)*j );
            DEFE_BPFO_harmonics_index    = find( f_EnvDEFE > (FE_BPFO*0.99)*j   &   f_EnvDEFE < (FE_BPFO*1.01)*j );
            DEFE_BSF_harmonics_index     = find( f_EnvDEFE > (FE_BSF*0.99)*j    &   f_EnvDEFE < (FE_BSF*1.01)*j );
            
            FEDE_BPFI_harmonics_index    = find( f_EnvFEDE > (DE_BPFI*0.99)*j   &   f_EnvFEDE < (DE_BPFI*1.01)*j );
            FEDE_BPFO_harmonics_index    = find( f_EnvFEDE > (DE_BPFO*0.99)*j   &   f_EnvFEDE < (DE_BPFO*1.01)*j );
            FEDE_BSF_harmonics_index     = find( f_EnvFEDE > (DE_BSF*0.99)*j    &   f_EnvFEDE < (DE_BSF*1.01)*j );
            
            FEFE_BPFI_harmonics_index    = find( f_EnvFEFE > (FE_BPFI*0.99)*j   &   f_EnvFEFE < (FE_BPFI*1.01)*j );
            FEFE_BPFO_harmonics_index    = find( f_EnvFEFE > (FE_BPFO*0.99)*j   &   f_EnvFEFE < (FE_BPFO*1.01)*j );
            FEFE_BSF_harmonics_index     = find( f_EnvFEFE > (FE_BSF*0.99)*j    &   f_EnvFEFE < (FE_BSF*1.01)*j );
            
            
            DEDE_BPFI_6Harmonics(j) = rms(p_EnvDEDE(DEDE_BPFI_harmonics_index));
            DEDE_BPFO_6Harmonics(j) = rms(p_EnvDEDE(DEDE_BPFO_harmonics_index));
            DEDE_BSF_6Harmonics(j)  = rms(p_EnvDEDE(DEDE_BSF_harmonics_index));
            
            DEFE_BPFI_6Harmonics(j) = rms(p_EnvDEFE(DEFE_BPFI_harmonics_index));
            DEFE_BPFO_6Harmonics(j) = rms(p_EnvDEFE(DEFE_BPFO_harmonics_index));
            DEFE_BSF_6Harmonics(j)  = rms(p_EnvDEFE(DEFE_BSF_harmonics_index));

            FEDE_BPFI_6Harmonics(j) = rms(p_EnvFEDE(FEDE_BPFI_harmonics_index));
            FEDE_BPFO_6Harmonics(j) = rms(p_EnvFEDE(FEDE_BPFO_harmonics_index));
            FEDE_BSF_6Harmonics(j)  = rms(p_EnvFEDE(FEDE_BSF_harmonics_index));
            
            FEFE_BPFI_6Harmonics(j) = rms(p_EnvFEFE(FEFE_BPFI_harmonics_index));
            FEFE_BPFO_6Harmonics(j) = rms(p_EnvFEFE(FEFE_BPFO_harmonics_index));
            FEFE_BSF_6Harmonics(j)  = rms(p_EnvFEFE(FEFE_BSF_harmonics_index));   % Total 72 Features  
            

            ColumnName(1,j)    = {"Env_DEDE_BPFI_Harmonic_"+string(j)};     % DEDE Column Name
            ColumnName(1,j+6)  = {"Env_DEDE_BPFO_Harmonic_"+string(j)};
            ColumnName(1,j+12) = {"Env_DEDE_BSF_Harmonic_"+string(j)};
            
            ColumnName(2,j)    = {"Env_DEFE_BPFI_Harmonic_"+string(j)};     % DEFE Column Name
            ColumnName(2,j+6)  = {"Env_DEFE_BPFO_Harmonic_"+string(j)};
            ColumnName(2,j+12) = {"Env_DEFE_BSF_Harmonic_"+string(j)};
            
            ColumnName(3,j)    = {"Env_FEDE_BPFI_Harmonic_"+string(j)};     % FEDE Column Name
            ColumnName(3,j+6)  = {"Env_FEDE_BPFO_Harmonic_"+string(j)};
            ColumnName(3,j+12) = {"Env_FEDE_BSF_Harmonic_"+string(j)};
            
            ColumnName(4,j)    = {"Env_FEFE_BPFI_Harmonic_"+string(j)};     % FEFE Column Name
            ColumnName(4,j+6)  = {"Env_FEFE_BPFO_Harmonic_"+string(j)};
            ColumnName(4,j+12) = {"Env_FEFE_BSF_Harmonic_"+string(j)};
         end
        
        DEDE_temp      = [DEDE_BPFI_6Harmonics DEDE_BPFO_6Harmonics DEDE_BSF_6Harmonics];
        DEFE_temp      = [DEFE_BPFI_6Harmonics DEFE_BPFO_6Harmonics DEFE_BSF_6Harmonics];
        FEDE_temp      = [FEDE_BPFI_6Harmonics FEDE_BPFO_6Harmonics FEDE_BSF_6Harmonics];
        FEFE_temp      = [FEFE_BPFI_6Harmonics FEFE_BPFO_6Harmonics FEFE_BSF_6Harmonics];

        ColumnName_DEDE = string(ColumnName(1,:));     ColumnName_DEFE = string(ColumnName(2,:));
        ColumnName_FEDE = string(ColumnName(3,:));     ColumnName_FEFE = string(ColumnName(4,:));

        Feature_temp   = [DEDE_temp DEFE_temp FEDE_temp FEFE_temp];
        Feature_temp   = array2table(Feature_temp, 'RowNames',string(RowIndex)+'_'+string(i), 'VariableNames',[ColumnName_DEDE ColumnName_DEFE ColumnName_FEDE ColumnName_FEFE]);
        FeatureTable   = [FeatureTable ; Feature_temp];
    end
end