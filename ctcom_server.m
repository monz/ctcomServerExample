clear all;
clc;


import ctcom.messageTypes.*;
import ctcom.messageImpl.*;
import ctcom.CtcomServer;

outCtmatPath = '/mnt/test/testrunData.ctmat';
outCtmatLocation = '\\192.168.56.101\ctmatfiles\testrunData.ctmat';

%%

disp('Starting CTCOM server service');
% create new ctcom server
server = CtcomServer(4745);
%while true
try
    % accept connection requests
    server.accept();
    % read client connection request
    request = server.getMessage();
    % check if received message is valid (not null [java], not empty [matlab])
    if isempty(request)
        disp('Did not receive ctcom connect message');
        %continue;
    elseif request.getType() == MessageType.CONNECT
        disp('Received ctcom connect message');
        % check if protocol version matched
        if request.isProtocolMatched()
            % send CTCOM connection request acknowledgement
            server.sendConnectAcknowledge(request);

            protocolVersion = request.getProtocolVersion();
            fprintf('Handle ctcom messages in version: %s\n', char(protocolVersion));
            
            % read config from connection request
            % TODO: implement algorithm here
            % ---------------------------------------------------
            load('matfiles/chh 000791_kt3.i01.ctmat', '-mat');
            % handle test bench read
            handleTestbenchRead(request, ctData);
            
            % handle test bench write
            outCtmat = handleTestbenchWrite(request, ctData, outCtmatPath);

            % save ctmat file into network share
            save(outCtmatPath, 'outCtmat');
            % ---------------------------------------------------

            % notify client to read data provided on network share
            % send CTCOM readData message to client
            message = ReadDataMessage();
            message.setLocation(outCtmatLocation);
            server.sendMessage(message);
            
            % start new testing/examination process
            while true
                % TODO: implement algorithm here
                % read client's readData answer
                % ---------------------------------------------------
                % < input code here>
                % ---------------------------------------------------

                % receive CTCOM readData or quit messages
                message = server.getMessage();
                % check if received message is valid
                if isempty(message)
                    % received unknown message
                    continue;
                end
                if message.getType() == MessageType.READ_DATA
                    % handle CTCOM readData request
                    fprintf('Transfer: %s\n', char(message.getTransfer()));
                    fprintf('Location: %s\n', char(message.getLocation()));
                elseif message.getType() == MessageType.QUIT
                    % quit CTCOM connection
                    fprintf('Quit: %s\n', char(message.getMessage()));
                    break;
                end
            end
        else
            % protocol version did not match
            disp('Protocol version did not match');
        end
    else
        % should not be reached, skip message, try again
        % continue
    end
catch ME
    try
        server.quit('shit happens');
        server.close();
    catch
        disp(ME.message);
    end
    disp(ME.message);
end
%end
disp('Ending CTCOM server service');
% close tcp socket
server.close();
