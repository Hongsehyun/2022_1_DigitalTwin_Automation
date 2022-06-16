function plt_processed_discharge(data_number, voltage_criteria, data_idx, title_idx) 

name        = 'cycle #' + string(data_idx);
legend_idx  = char(name);

data_size   = size(data_idx);
len         = data_size(2);

figure()
for i = 1:len
    threshold_V(i) = find(voltage_criteria > data_number.cycle(data_idx(i)).data.Voltage_measured);
    threshhold_V_min = min(threshold_V(i));
    if i == 1 || i == len
         plot(data_number.cycle(data_idx(i)).data.Time(1:threshhold_V_min), data_number.cycle(data_idx(i)).data.Voltage_measured(1:threshhold_V_min),'-o','DisplayName',legend_idx(:,:,i));
     else
         plot(data_number.cycle(data_idx(i)).data.Time(1:threshhold_V_min), data_number.cycle(data_idx(i)).data.Voltage_measured(1:threshhold_V_min),'DisplayName',legend_idx(:,:,i));
   end
    hold on
end

legend('Location','southwest','NumColumns',2)
ylabel('Measured Discharge Voltage (V)');
xlabel('Time (sec)');    xlim([0,4000]);
title(string(title_idx) + ' Pre-Preocessed Cycle Specific Discharge Graph');

end