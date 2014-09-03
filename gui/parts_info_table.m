function partstable = parts_info_table(parts)
    
    %% Find all applicable fields
    fields = {}; 
    for i=1:length(parts)
        fields=[fields;fieldnames(parts{i})]; 
    end; 
    fields = unique(fields);
    
    %% Setup (empty) struct array
    structarray = [];
    for i=1:length(parts)
        for j=1:length(fields)
            var = [];
            if isfield(parts{i},fields{j})
                var = num2str(parts{i}.(fields{j}));
            else
                var = '-';
            end
            if ~isfield(structarray,fields{j})
                structarray.(fields{j}) = {var};
            else
                structarray.(fields{j}) = [structarray.(fields{j}); {var}];
            end
        end
    end;
    
    %% Create table
    partstable = struct2table(structarray);
%end