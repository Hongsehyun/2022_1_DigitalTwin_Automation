function Feature_Plot_CurvePoint(data_number, voltage_criteria, title_idx) 

data_number_size     = size(data_number.cycle);
data_number_rowSize  = data_number_size(2);
discharge_idx  = zeros(data_number_rowSize,1);

for i = 1:data_number_rowSize
    discharge_idx(i) = strcmp( data_number.cycle(i).type, 'discharge');
    discharge_idx    = discharge_idx';
end

% voltage discharge graph에서 second psuedo linear 영역의 기울기 값을 feature로 추출
data_idx       = discharge_idx;
name           = 'cycle #' + string(data_idx);
legend_idx     = char(name);

figure
idx = 1;
for i = 1:data_number_rowSize
    if discharge_idx(i) == 0
        % This Data is not Voltage Discharge Data    
    end
    
    if discharge_idx(i) == 1
        threshold_V(i) = find(voltage_criteria > data_number.cycle(i).data.Voltage_measured);
        threshhold_V_min = min(threshold_V(i));
        plot(data_number.cycle(i).data.Time(1:threshhold_V_min), data_number.cycle(i).data.Voltage_measured(1:threshhold_V_min),'-');
        hold on

        change_idx = find(ischange(data_number.cycle(i).data.Voltage_measured));
        
        temp = size(change_idx);
        if temp(2) >= 3
            plot(data_number.cycle(i).data.Time(change_idx(1)), data_number.cycle(i).data.Voltage_measured(change_idx(1)),'X', 'MarkerSize',30);
            plot(data_number.cycle(i).data.Time(change_idx(3)), data_number.cycle(i).data.Voltage_measured(change_idx(3)),'X', 'MarkerSize',30);
        end
        
        if temp(2) < 3
            plot(data_number.cycle(i).data.Time(change_idx(1)), data_number.cycle(i).data.Voltage_measured(change_idx(1)),'X', 'MarkerSize',30);
            plot(data_number.cycle(i).data.Time(change_idx(2)), data_number.cycle(i).data.Voltage_measured(change_idx(2)),'X', 'MarkerSize',30);
        end
        idx = idx + 1;
    end
end

ylabel('Measured Discharge Voltage (V)');
xlabel('Time (sec)');
title(string(title_idx) + ' Cycle Specific Discharge Graph');
hold off

end
