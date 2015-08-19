function handleReadDataMessage( message, dataToRead )
%HANDLEREADDATAMESSAGE Summary of this function goes here
%   Detailed explanation goes here

    % get location from message
    ctmatLocation = char(message.getLocation());

    % load ctmat file
    ctmatFile = load(ctmatLocation, '-mat');
    
    % print data
    
    separator = '-----------------------------';
    disp('signals');
    disp(separator);
    disp(ctmatFile.ctData.parts(1).signals(1).('yData')(1:3));
%     separator = '-----------------------------';
%     disp(separator);
%     numberOfFields = length(dataToRead);
%     for n = 1:numberOfFields
%         structField = dataToRead{n};
%         % skip parts field for convenience
%         if isequal(structField, 'parts.engineInputs') || isequal(structField, 'parts.engineOutputs')
%             continue;
%         end
%         printData(ctmatFile.ctData.(structField));
%         disp(separator);
%     end
end

