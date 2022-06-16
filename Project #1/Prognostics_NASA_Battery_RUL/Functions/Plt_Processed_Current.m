function Plt_Processed_Current(title_idx, data_number, voltage_criteria) 

j        = 0;
data_idx = zeros(1,1);

for i = 1 : length(data_number.cycle)
    if data_number.cycle(:, i).type == "discharge"
        j = j + 1;
        data_idx(j) = i;
    end
end

hold on
for i = 1 : length(data_idx)
    threshold_V = find(voltage_criteria > data_number.cycle(data_idx(i)).data.Voltage_measured);
    threshhold_V_min = min(threshold_V);

    if i == 1 || i == length(data_idx)
        plot(data_number.cycle(data_idx(i)).data.Time(1:threshhold_V_min),data_number.cycle(data_idx(i)).data.Current_measured(1:threshhold_V_min));
    else
        plot(data_number.cycle(data_idx(i)).data.Time(1:threshhold_V_min),data_number.cycle(data_idx(i)).data.Current_measured(1:threshhold_V_min));
    end
       
end

ylim([-5 -0])
xlabel('Time (sec)');
ylabel('Measured Discharge Current (A)');
title('Cycle Specific Discharge Graph of ' + string(title_idx));

end
