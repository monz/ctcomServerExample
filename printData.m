function printData( struct, parantField )
%PRINTDATA Summary of this function goes here
%   Detailed explanation goes here

    if isstruct(struct)
        
        structFields = fieldnames(struct);
        numberOfFields = length(structFields);
        
        % restrict output to the first three entries
        if numberOfFields > 3
            numberOfFields = 3;
        end
        
        for n = 1:numberOfFields
            structField = structFields{n};
            printData(struct.(structField), structField)
        end
        
    % end of recursion
    else
        
        % print only the first value of an array
        if length(struct) > 1
            if isnumeric(struct(1))
                structValue = num2str(struct(1));
            elseif iscellstr(struct(1))
                structValue = char(struct{1});
            elseif ischar(struct)
                structValue = struct;
            else
                structValue = struct(1);
            end
        % print the single value
        else
            if isnumeric(struct)
                structValue = num2str(struct);
            elseif iscellstr(struct)
                structValue = char(struct);
            else
                structValue = struct;
            end
        end
        
        fprintf('%s: %s \n', parantField, structValue);
        
    end
end

