function feature = Time_Freq_Features_Calculator(X)
%% Function Setting
feature = table;
N=length(X);
%% getFFT
Xfft = getFFT(X, N); 
%% X Time Features
% Average of Absolute Value
Xaav     = sum(abs(X))/N;
% Energy (sum of power_2)
Xenergy  = sum(X.^2);
% Peak
Xpeak    = max(abs(X));

% 1. RMS
feature.Xrms = rms(X);
% 2. Square Root Average
feature.Xsra = ( sum( sqrt(abs(X)) ) / N ).^2;
% 3. Kurtosis Value
feature.Xkv  = kurtosis(X);
% 4. Skewness Value
feature.Xsk  = skewness(X);
% 5. Peak2Peak
feature.Xppv = peak2peak(X);
% 6. Crest Factor
feature.Xcf  = Xpeak/feature.Xrms;
% 7. Impulse Factor
feature.Xif  = Xpeak/Xaav;
% 8. Marginal(Clearance) Factor
feature.Xmf  = Xpeak/feature.Xsra;
% 9. Shape Factor
feature.Xsf  = feature.Xrms/Xaav;
% 10. Kurtosis Factor
feature.Xkf  = feature.Xkv/(feature.Xrms^4);
%% X Frequency Features
% 11. mean[Frequency Center]
feature.Xfc   = mean(Xfft);
% 12. RMS[RMS Frequency]
feature.Xrmsf = rms(Xfft);
% 13. Root Variance Frequency
feature.Xrvf  = (sum((Xfft-feature.Xfc).^2)/N).^(1/2);
end