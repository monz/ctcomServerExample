clear all;
clc;


import ctcom.messageTypes.*;
import ctcom.messageImpl.*;
import ctcom.CtcomServer;

%% configuration

ctmatFile = 'matfiles/chh 000791_kt3.i01.ctmat';
% outCtmatPath = 'Z:\testrunData.ctmat';
outCtmatPath = '/mnt/linuxdata/tmp/ctmatfiles/testrunData.ctmat';
outCtmatLocation = '/mnt/linuxdata/tmp/ctmatfiles/testrunData.ctmat';
%outCtmatLocation = '\\192.168.2.101\ctmatfiles\testrunData.ctmat'; % client must have access rights to this path
%outCtmatLocation = '\\192.168.56.101\ctmatfiles\testrunData.ctmat';
serverport = 4745;

%%

disp('Starting CTCOM server service');
% create new ctcom server
server = CtcomServer(serverport);
while true
    try
        %% accept connection requests
        server.accept();
        % read client connection request
        request = server.getMessage();
        %% check if received message is valid (not null [java], not empty [matlab])
        if isempty(request)
            disp('Did not receive ctcom connect message');
            continue;
        elseif ~ (request.getType() == MessageType.CONNECT)
            % expected ctcom connect message, skip message and read next
            % message
            continue;
        end
        disp('Received ctcom connect message');
        %% check if protocol version matched
        if ~ request.isProtocolMatched()
            % protocol version did not match
            disp('Protocol version did not match');
            server.sendConnectAcknowledge(request);
            server.quit(sprintf('Protocol version did not match, required version %s\n', request.getProtocolVersion()));
            continue;
        end
        %% send CTCOM connection request acknowledgement
        server.sendConnectAcknowledge(request);

        protocolVersion = request.getProtocolVersion();
        fprintf('Handle ctcom messages in version: %s\n', char(protocolVersion));

        % read config from connection request
        % TODO: implement algorithm here
        % ---------------------------------------------------
        load(ctmatFile, '-mat');
        % handle test bench read
        handleTestbenchRead(request, ctData);

        % handle test bench write
        outCtmat = handleTestbenchWrite(request, ctData, outCtmatPath);

        % ---------------------------------------------------

        % notify client to read data provided on network share
        % send CTCOM readData message to client
        message = ReadDataMessage();
        message.setLocation(outCtmatLocation);
        server.sendMessage(message);

        % receive CTCOM readData or quit messages
        while true
            message = server.getMessage();
            % check if received message is valid
            if isempty(message)
                % received unknown message
                continue;
            else
                break;
            end
        end
        if message.getType() == MessageType.READ_DATA
            % TODO: implement algorithm here
            % read client's readData answer
            % ---------------------------------------------------
            % handle CTCOM readData request
            fprintf('Transfer: %s\n', char(message.getTransfer()));
            fprintf('Location: %s\n', char(message.getLocation()));
        elseif message.getType() == MessageType.QUIT
            % print CTCOM quit message
            fprintf('Quit: %s\n', char(message.getMessage()));
            break;
        end
        % ---------------------------------------------------
        server.quit('enough messages sent');
    catch ME
        try
            server.quit('shit happens');
            server.close();
        catch ME2
            disp(ME2.message);
        end
        disp(ME.message);
        break;
    end
end
disp('Ending CTCOM server service');
% close tcp socket
server.close();
