function helperPlotTrend(ax, currentCycle, healthIndicator, mdl, threshold, timeUnit)
%HELPERPLOTTREND helper function to refresh the trending plot
% Copyright 2018 The MathWorks, Inc.

t = 1:size(healthIndicator, 1);
% HIpred = mdl.Phi + mdl.Theta*exp(mdl.Beta*(t - mdl.InitialLifeTimeValue));
% HIpredCI1 = mdl.Phi + ...
%     (mdl.Theta - sqrt(mdl.ThetaVariance)) * ...
%     exp((mdl.Beta - sqrt(mdl.BetaVariance))*(t - mdl.InitialLifeTimeValue));
% HIpredCI2 = mdl.Phi + ...
%     (mdl.Theta + sqrt(mdl.ThetaVariance)) * ...
%     exp((mdl.Beta + sqrt(mdl.BetaVariance))*(t - mdl.InitialLifeTimeValue));

HIpred = mdl.Phi + mdl.Theta*t + mdl.NoiseVariance;
HIpredCI1 = mdl.Phi + mdl.Theta*t + mdl.NoiseVariance - healthIndicator(end)*0.1;
HIpredCI2 = mdl.Phi + mdl.Theta*t + mdl.NoiseVariance + healthIndicator(end)*0.1;


cla(ax)
hold(ax, 'on')
plot(ax, t, HIpred)
plot(ax, [t NaN t], [HIpredCI1 NaN, HIpredCI2], '--')
plot(ax, t(1:currentCycle), healthIndicator(1:currentCycle, :))
plot(ax, t, threshold*ones(1, length(t)), 'r')
hold(ax, 'off')

if ~isempty(mdl.SlopeDetectionInstant)
    title(ax, sprintf('Cycle %d: Degradation detected!\n', currentCycle))
else
    title(ax, sprintf('Cycle %d: Degradation NOT detected.\n', currentCycle))
end
ylabel(ax, 'Health Indicator')
xlabel(ax, ['Cycle (' timeUnit ')'])
legend(ax, 'Degradation Model', 'Confidence Interval', ...
    'Health Indicator', 'Threshold', 'Location', 'Northeast')
end