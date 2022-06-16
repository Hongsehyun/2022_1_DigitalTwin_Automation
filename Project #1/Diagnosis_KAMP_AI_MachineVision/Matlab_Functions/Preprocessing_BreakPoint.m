function [BreakPoint] = Preprocessing_BreakPoint(Data)
%%
Size_data            = size(Data);
ColumnSize_data      = Size_data(2);
RowSize_data         = Size_data(1);
BreakPoint           = zeros(1,RowSize_data);
flag                 = 0;

for i=1:RowSize_data
    for j=1:ColumnSize_data
        
        if flag == 1
            flag = 0;
            break
        end
        
        if ( (Data(i,j) == 0) &&  j < ColumnSize_data )
           BreakPoint(i) = j-1; 
           flag = 1;
        end
    end
end