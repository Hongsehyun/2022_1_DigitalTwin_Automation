function [Feature_Slope, Feature_Kneepoint, Feature_Tadd] = getFeature_Slope_Kneepoint_Tadd(data, voltage_criteria) 
% Input : data(B005, B006, etc..), voltage_criteria(2.7[V], 2.5[V], etc..)
% Output : Slope(2-pseudolinear), Kneepoint, and Tadd according to input data

data_size     = size(data.cycle);
data_cycle_size  = data_size(2);                 % Number of Cycle(ex. 616)
discharge_idx  = zeros(data_cycle_size, 1);

for i = 1 : data_cycle_size
    discharge_idx(i) = strcmp( data.cycle(i).type, 'discharge'); % Returns 1 if cycle is a discharge cycle
    discharge_idx    = discharge_idx';
end

idx = 1;
for i = 1 : data_cycle_size

    if discharge_idx(i) == 1
        threshold_V(i) = find(voltage_criteria > data.cycle(i).data.Voltage_measured);
        threshhold_V_min = min(threshold_V(i));

        change_idx = find(ischange(data.cycle(i).data.Voltage_measured));
        
        temp = size(change_idx);
        if temp(2) >= 3
            Feature_Slope(idx,:)   = (data.cycle(i).data.Voltage_measured(change_idx(3))-data.cycle(i).data.Voltage_measured(change_idx(1)))/...
                                    (data.cycle(i).data.Time(change_idx(3))-data.cycle(i).data.Time(change_idx(1)));
            Feature_Kneepoint(idx,:)  = data.cycle(i).data.Time(change_idx(3));
            Feature_Tadd(idx,:)       = data.cycle(i).data.Time(threshhold_V_min)-Feature_Kneepoint(idx,:);
        end
        
        if temp(2) < 3
            Feature_Slope(idx,:)  = (data.cycle(i).data.Voltage_measured(change_idx(2))-data.cycle(i).data.Voltage_measured(change_idx(1)))/...
                                    (data.cycle(i).data.Time(change_idx(2))-data.cycle(i).data.Time(change_idx(1)));
            Feature_Kneepoint(idx,:) = data.cycle(i).data.Time(change_idx(2));
            Feature_Tadd(idx,:)      = data.cycle(i).data.Time(threshhold_V_min)-Feature_Kneepoint(idx,:);
        end
        idx = idx + 1;
    end
end

end
