function [ createdCtmatLocation, newCounter ] = createCtmatFile( ctmatDirectory, dataToWrite, data, counter )
%CREATECTMATFILE Summary of this function goes here
%   Detailed explanation goes here

    numberOfFields = length(dataToWrite);
    for n = 1:numberOfFields
       structField = dataToWrite{n};
       tmpMatFile.(structField) = data.(structField);
    end
    
    % create new filename
    newCounter = counter + 1;
    filename = sprintf('chh %05i_kt3.i01', newCounter);
    createdCtmatLocation = [ctmatDirectory, filename, '.ctmat'];
    
    % save ctmat file into network share
    save(createdCtmatLocation, 'tmpMatFile');

end

