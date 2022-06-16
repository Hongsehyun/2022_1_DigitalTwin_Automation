function [Discharge_Capacity] = getFeature_DischargeCapacity(data) 
% Input : data(B005, B006, etc....)
% Output : Discharge Capacity according to Input Dataset

data_size     = size(data.cycle);
data_cycle_size  = data_size(2);                 % Number of Cycle(ex. 616)
discharge_idx  = zeros(data_cycle_size, 1);

Discharge_Capacity = zeros(1, 1);
time_idx = 1;

for i = 1 : data_cycle_size
    discharge_idx(i) = strcmp(data.cycle(i).type, 'discharge');
    
    if discharge_idx(i) == 1
        Discharge_Capacity(time_idx) = data.cycle(i).data.Capacity;
        time_idx = time_idx + 1;
    end
end

Discharge_Capacity = Discharge_Capacity';

end