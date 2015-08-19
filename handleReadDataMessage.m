function handleReadDataMessage( message, dataToRead )
%HANDLEREADDATAMESSAGE Summary of this function goes here
%   Detailed explanation goes here

    % get location from message
    ctmatLocation = char(message.getLocation());

    % load ctmat file
    ctmatFile = load(ctmatLocation, '-mat');
    
    % print data
    separator = '-----------------------------';
    disp(separator);
    numberOfFields = length(dataToRead);
    for n = 1:numberOfFields
        structField = dataToRead{n};
        printData(ctmatFile.tmpMatFile.(structField));
        disp(separator);
    end
end

