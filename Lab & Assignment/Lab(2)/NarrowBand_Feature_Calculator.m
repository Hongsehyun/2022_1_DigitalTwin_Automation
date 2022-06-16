function feature = NarrowBand_Feature_Calculator(X)
%% Function Setting
feature = table;
N=length(X);
%% X Time Features
% Average of Absolute Value
NBaav     = sum(abs(X))/N;
% Peak
NBpeak    = max(abs(X));

% 1. RMS
feature.NBrms = rms(X);
% 2. Square Root Average
feature.NBsra = ( sum( sqrt(abs(X)) ) / N ).^2;
% 3. Kurtosis Value
feature.NBkv  = kurtosis(X);
% 4. Skewness Value
feature.NBsk  = skewness(X);
% 5. Peak2Peak
feature.NBppv = peak2peak(X);
% 6. Crest Factor
feature.NBcf  = NBpeak/feature.NBrms;
% 7. Impulse Factor
feature.NBif  = NBpeak/NBaav;
% 8. Marginal(Clearance) Factor
feature.NBmf  = NBpeak/feature.NBsra;
% 9. Shape Factor
feature.NBsf  = feature.NBrms/NBaav;
% 10. Kurtosis Factor
feature.NBkf  = feature.NBkv/(feature.NBrms^4);
% 11. Energy (sum of power_2)
feature.NBenergy  = sum(X.^2);
%% X Frequency Features
% 12. mean[Frequency Center]
feature.NBfc   = mean(X);
% 13. RMS[RMS Frequency]
feature.NBrmsf = rms(X);
% 14. Root Variance Frequency
feature.NBrvf  = (sum((X-feature.NBfc).^2)/N).^(1/2);
end