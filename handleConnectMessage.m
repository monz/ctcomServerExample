function [ dataToRead, dataToWrite ] = handleConnectMessage( connectMessage )
%HANDLECONNECTMESSAGE Summary of this function goes here
%   Detailed explanation goes here

    dataToRead = cell(connectMessage.getTestbenchRead().toArray());
    
    dataToWrite = cell(connectMessage.getTestbenchWrite().toArray());

end

