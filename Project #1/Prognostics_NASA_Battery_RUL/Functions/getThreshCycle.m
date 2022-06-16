function [thresh_cycle] = getThreshCycle(data)
% Input : data(B005, B006, etc....)
% Output : Threshhold Cycle = When Capacity value < 70% of initial Capacity Value

data_size     = size(data.cycle);
data_cycle_size  = data_size(2);                 % Number of Cycle(ex. 616)
discharge_idx  = zeros(data_cycle_size, 1);

time_idx = 0;
thresh_cycle = 0;

for i = 1:data_cycle_size
    discharge_idx(i) = strcmp(data.cycle(i).type, 'discharge');
    
    if discharge_idx(i) == 1 && thresh_cycle < 1

        time_idx = time_idx + 1;

        if time_idx == 1
            initial_capacity = data.cycle(i).data.Capacity;
        
        else
            if data.cycle(i).data.Capacity < initial_capacity*0.7101
                thresh_cycle = time_idx;
            end          
        end

    end
end

end