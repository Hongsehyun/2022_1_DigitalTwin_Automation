function Class = get_Class_method_2(Table)
%% Setting
Class_Col        = Table.Properties.RowNames;
Class_Size       = size(Class_Col);
Class            = cell(Class_Size(1),1);
%% Method (2)     Ball   Inner   Outer   Normal   Classification
for i = 1:Class_Size(1)
    if  strcmp(extract(Class_Col(i,:),1),'B')
        Class(i,:) = {'Ball'};
    end

    if  strcmp(extract(Class_Col(i,:),1),'I')
        Class(i,:) = {'Inner'};
    end
    
    if  strcmp(extract(Class_Col(i,:),1),'O')
        Class(i,:) = {'Outer'};
    end
        
    if  strcmp(extract(Class_Col(i,:),1),'N')
        Class(i,:) = {'Normal'};
    end
end
end
