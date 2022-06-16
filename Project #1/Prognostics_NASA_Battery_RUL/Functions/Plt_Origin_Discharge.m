function plt_discharge(data_number, data_idx, title_idx) 

name        = 'cycle #' + string(data_idx);
legend_idx  = char(name);

data_size   = size(data_idx);
len         = data_size(2);

figure
for i = 1:len
    if i == 1 || i == len
        plot(data_number.cycle(data_idx(i)).data.Time, data_number.cycle(data_idx(i)).data.Voltage_measured,'-o','DisplayName',legend_idx(:,:,i));
    else
        plot(data_number.cycle(data_idx(i)).data.Time, data_number.cycle(data_idx(i)).data.Voltage_measured,'DisplayName',legend_idx(:,:,i));
    end
    hold on
end

legend('Location','southwest','NumColumns',2)
ylabel('Measured Discharge Voltage (V)');
xlabel('Time (sec)');    xlim([0,4000]);
title(string(title_idx) + ' Cycle Specific Discharge Graph');

end