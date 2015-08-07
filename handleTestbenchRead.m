function handleTestbenchRead( request, ctData )
%HANDLETESTBENCHREAD Summary of this function goes here
%   Detailed explanation goes here

    testbenchReadInfos = cell(request.getTestbenchRead().toArray());
    for n = 1:length(testbenchReadInfos)
        structField = testbenchReadInfos{n};
        field = ctData.(structField);
        if isequal(structField, 'header')
            disp('Header Info');
            fprintf('Fileformat %s\n', field.fileformat);
            fprintf('Engine number %s\n', field.engineNumber);
        elseif isequal(structField, 'partInfo')
            disp('Part Info');
            fprintf('Part type name %s', field.partTypeName{1});
            fprintf('Part type name %s', field.partTypeName{2});
            fprintf('Part type name %s\n', field.partTypeName{3});
        end
    end
%             iter = testbenchReadInfos.listIterator();
%             while iter.hasNext()
%                 entry = iter.next();
%             end
end

