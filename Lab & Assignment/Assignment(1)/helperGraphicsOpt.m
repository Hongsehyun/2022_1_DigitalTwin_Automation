function helperGraphicsOpt(ChannelId)
ax = gca;
ax.Title.String = ['Input Channel: ' num2str(ChannelId)];
ax.XLabel.String = 'Frequency (Hz)';
ax.YLabel.String = 'Time (seconds)';
end



%%% Exercise 2-5 전용 코드
% function helperGraphicsOpt(ChannelId)
% 
% ax = gca;
% ax.XDir = 'reverse';
% ax.ZLim = [0 30];
% ax.Title.String = ['Input Channel: ' num2str(ChannelId)];
% ax.XLabel.String = 'Frequency (Hz)';
% ax.YLabel.String = 'Time (seconds)';
% ax.View = [30 45];
% 
% end