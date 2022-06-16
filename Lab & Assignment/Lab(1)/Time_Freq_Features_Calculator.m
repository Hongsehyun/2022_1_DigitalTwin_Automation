function feature = Time_Freq_Features_Calculator(DE, FE)
%% Function Setting
feature = table;
N=length(DE);
%% getFFT
DE_fft = getFFT(DE, N); 
FE_fft = getFFT(FE, N);
%% DE Time Features
% Average of Absolute Value
DE_aav     = sum(abs(DE))/N;
% Energy (sum of power_2)
DE_energy  = sum(DE.^2);
% Peak
DE_peak    = max(abs(DE));

% 1. RMS
feature.DE_rms = rms(DE);
% 2. Square Root Average
feature.DE_sra = ( sum( sqrt(abs(DE)) ) / N ).^2;
% 3. Kurtosis Value
feature.DE_kv  = kurtosis(DE);
% 4. Skewness Value
feature.DE_sk  = skewness(DE);
% 5. Peak2Peak
feature.DE_ppv = peak2peak(DE);
% 6. Crest Factor
feature.DE_cf  = DE_peak/feature.DE_rms;
% 7. Impulse Factor
feature.DE_if  = DE_peak/DE_aav;
% 8. Marginal(Clearance) Factor
feature.DE_mf  = DE_peak/feature.DE_sra;
% 9. Shape Factor
feature.DE_sf  = feature.DE_rms/DE_aav;
% 10. Kurtosis Factor
feature.DE_kf  = feature.DE_kv/(feature.DE_rms^4);
%% DE Frequency Features
% 11. mean[Frequency Center]
feature.DE_fc   = mean(DE_fft);
% 12. RMS[RMS Frequency]
feature.DE_rmsf = rms(DE_fft);
% 13. Root Variance Frequency
feature.DE_rvf  = (sum((DE_fft-feature.DE_fc).^2)/N).^(1/2);
%% FE Time Features
% Average of Absolute Value
FE_aav     = sum(abs(FE))/N;
% Energy (sum of power_2)
FE_energy  = sum(FE.^2);
% Peak
FE_peak    = max(abs(FE));

% 1. RMS
feature.FE_rms  = rms(FE);
% 2. Square Root Average
feature.FE_sra  = ( sum( sqrt(abs(FE)) ) / N ).^2;
% 3. Kurtosis Value
feature.FE_kv   = kurtosis(FE);
% 4. Skewness Value
feature.FE_sk   = skewness(FE);
% 5. Peak2Peak
feature.FE_ppv  = peak2peak(FE);
% 6. Crest Factor
feature.FE_cf   = FE_peak/feature.FE_rms;
% 7. Impulse Factor
feature.FE_if   = FE_peak/FE_aav;
% 8. Marginal(Clearance) Factor
feature.FE_mf   = FE_peak/feature.FE_sra;
% 9. Shape Factor
feature.FE_sf   = feature.FE_rms/FE_aav;
% 10. Kurtosis Factor
feature.FE_kf   = feature.FE_kv/(feature.FE_rms^4);
%% FE Frequency Features
% 11. mean[Frequency Center]
feature.FE_fc    = mean(FE_fft);
% 12. RMS[RMS Frequency]
feature.FE_rmsf  = rms(FE_fft);
% 13. Root Variance Frequency
feature.FE_rvf   = (sum((FE_fft-feature.FE_fc).^2)/N).^(1/2);
end