function xfeature=freqFeatures(F)

% Comments
fprintf('\nreturn Frequency-domain features of vector x \n')
fprintf('input:    x, 1-d vector \n')
fprintf('output:   x Feature, table show \n\n')
fprintf('x:        Input data \n')
fprintf('xfeature: Table for feature of x \n\n')

% define table
xfeature = table;
N=length(F);

% 1. mean[Frequency Center]
xfeature.fc= mean(F);

% 2. RMS[RMS Frequency]
xfeature.rmsf= rms(F);

% 3. Root Variance Frequency
xfeature.rvf= (sum((F-xfeature.fc).^2)/N).^(1/2);

end
