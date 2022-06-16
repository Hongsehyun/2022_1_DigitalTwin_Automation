function [Feature_Rmeas] = getFeature_Rmeas(data) 

% Input : data(B005, B006, etc....)
% Output : Rmeas(Feature) according to input data

j        = 0;
len      = length(data.cycle);
data_idx = zeros(1,1);

% extract the index of the 'discharge' cycle.
% j = discharge number
% i = index number of cycle
for i = 1 : len
    if data.cycle(:, i).type == "discharge"
        j = j + 1;
        data_idx(j) = i;
    end
end

% In each cycle, we only look at 10 data from the starting point
% Extract when data values change rapidly(When a sudden voltage drop occurs due to internal resistance)
len_data  = length(data_idx);
time_idx  = 9;
pseudo_1  = zeros(len_data,2);
for cycle = 1:len_data
    for time = 1 : time_idx
        a = data.cycle(data_idx(cycle)).data.Voltage_measured(1, time+1);
        b = data.cycle(data_idx(cycle)).data.Voltage_measured(1, time);
    
        if b-a > 0.05
            pseudo_1(cycle,:) =  [time time+1];
        end
    end
end

% V = IR -> R = V/I, R_meas = dV/dI.
Feature_Rmeas = zeros(len_data,1);
for cycle = 1:len_data
    volt_bf = data.cycle(data_idx(cycle)).data.Voltage_measured(1,pseudo_1(1,1));
    volt_af = data.cycle(data_idx(cycle)).data.Voltage_measured(1,pseudo_1(1,2));
    
    curr_bf = data.cycle(data_idx(cycle)).data.Current_measured(1,pseudo_1(1,1));
    curr_af = data.cycle(data_idx(cycle)).data.Current_measured(1,pseudo_1(1,2));
    
    Feature_Rmeas(cycle,1) = (volt_af-volt_bf) / (curr_af - curr_bf);
end

end
