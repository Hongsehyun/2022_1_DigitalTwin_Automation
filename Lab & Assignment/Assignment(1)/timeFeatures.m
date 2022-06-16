function xfeature=timeFeatures(x)

% Comments
fprintf('\nreturn time-domain features of vector x \n')
fprintf('input:    x, 1-d vector \n')
fprintf('output:   x Feature, table show \n\n')
fprintf('x:        Input data \n')
fprintf('xfeature: Table for feature of x \n\n')

% define table
xfeature = table;
N=length(x);

% 1. mean
xfeature.ddmean=mean(x);
% 2. STD
xfeature.std=std(x);
% 3. RMS
xfeature.rms=rms(x);
% 4. Square Root Average
xfeature.sra= ( sum( sqrt(abs(x)) ) / N ).^2;
% 5. Average of Absolute Value
xfeature.aav=sum(abs(x))/N;
% 6. Energy (sum of power_2)
xfeature.energy=sum(x.^2);
% 7. Peak
xfeature.peak=max(abs(x));
% 8. Peak2Peak
xfeature.ppv=peak2peak(x);
% 9. Impulse Factor
xfeature.if=xfeature.peak/xfeature.aav;
% 10. Shape Factor
xfeature.sf=xfeature.rms/xfeature.aav;
% 11. Crest Factor
xfeature.cf= xfeature.peak/xfeature.rms;
% 12. Marginal(Clearance) Factor
xfeature.mf=xfeature.peak/xfeature.sra;
% 13. Skewness
xfeature.sk=skewness(x);
% 14. Kurtosis
xfeature.kt=kurtosis(x);

end