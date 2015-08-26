function [ createdCtmatLocation, newCounter ] = createCtmatFile( ctmatDirectory, dataToWrite, data, counter )
%CREATECTMATFILE Summary of this function goes here
%   Detailed explanation goes here

    numberOfFields = length(dataToWrite);
    for n = 1:numberOfFields
       structField = dataToWrite{n};
       if isequal(structField, 'parts.engineInputs') || isequal(structField, 'parts.engineOutputs')
           ctData.('parts') = data.('parts');
       else
           ctData.(structField) = data.(structField);
       end
    end
    
    % create new filename
    newCounter = counter + 2;
    filename = sprintf('chh %05i_kt3.i01', newCounter);
    createdCtmatLocation = [fullfile(ctmatDirectory, filename), '.ctmat'];
    
    % save ctmat file into network share
    save(createdCtmatLocation, 'ctData');

end

