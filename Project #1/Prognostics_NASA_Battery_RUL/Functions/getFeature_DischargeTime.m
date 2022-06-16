function [Feature_Time_discharge] = getFeature_DischargeTime(data) 
% Input : data(B005, B006, etc....)
% Output : Time spent on voltage discharge for each cycle of data

data_size     = size(data.cycle);
data_cycle_size  = data_size(2);                 % Number of Cycle(ex. 616)
discharge_idx  = zeros(data_cycle_size, 1);


time_idx = 1;

for i = 1:data_cycle_size
    discharge_idx(i) = strcmp(data.cycle(i).type, 'discharge');
    
    if discharge_idx(i) == 1
        discharge_time_size = size(data.cycle(i).data.Time);
        discharge_time_size = discharge_time_size(2);
        Feature_Time_discharge(time_idx) = data.cycle(i).data.Time(:,discharge_time_size);
        time_idx = time_idx + 1;
    end
end

end