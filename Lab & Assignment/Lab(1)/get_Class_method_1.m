function Class = get_Class_method_1(Table)
%% Setting
Class_Col        = Table.Properties.RowNames;
Class_Size       = size(Class_Col);
Class            = cell(Class_Size(1),1);
%% Method (1)     Ball[7/14/21]   Inner[7/14/21]   Outer[7/14/21]   Normal   Classification 
for i = 1:Class_Size(1)
    if  strcmp(extract(Class_Col(i,:),1),'B')
        Class(i,:) = extractBefore(Class_Col(i,:),10);
    end

    if  strcmp(extract(Class_Col(i,:),1),'I')
        Class(i,:) = extractBefore(Class_Col(i,:),11);
    end
    
    if  strcmp(extract(Class_Col(i,:),1),'O')
        Class(i,:) = extractBefore(Class_Col(i,:),11);
    end
        
    if  strcmp(extract(Class_Col(i,:),1),'N')
        Class(i,:) = extractBefore(Class_Col(i,:),9);
    end
end

end
