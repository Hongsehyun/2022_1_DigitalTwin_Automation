function feature = SpectralKurtosis_Feature_Calculator(X)
%% Function Setting
feature = table;
%% Features
feature.SKmean = mean(X);
feature.SKstd = std(X);
feature.SKsk  = skewness(X);
feature.SKkv  = kurtosis(X);
end