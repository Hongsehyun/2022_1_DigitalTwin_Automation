function [DischargeDateTimes] = getDischargeDateTimes(data) 
% Input : data(B005, B006, etc....)
% Output : Actual date of the discharge -> Used to make timetable

data_size     = size(data.cycle);
data_cycle_size  = data_size(2);                 % Number of Cycle(ex. 616)

time_idx = 1;
DischargeDateTimes=datetime(data.cycle(1).time);

for i = 1 : data_cycle_size
    discharge_idx(i) = strcmp(data.cycle(i).type, 'discharge');
    
    if discharge_idx(i) == 1
        DischargeDateTimes(time_idx) = datetime(data.cycle(i).time);
        time_idx = time_idx + 1;
    end
end

DischargeDateTimes = DischargeDateTimes';

end