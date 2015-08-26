function ctcom_server(configfile)
    import ctcom.messageTypes.*;
    import ctcom.messageImpl.*;
    import ctcom.CtcomServer;

    %% configuration
    % TODO: validate xml config file with xsd schema
    config = ConfigReader.read(configfile, 'ctcom');

    serverport = str2double(config.port);
    exampleData = config.ctmatExampleData;
    ctmatDirectory = config.ctmatNetworkPath;
    waitTime = str2double(config.timeBetweenMessages);

    % static values
    ctmatCounter = -1;

    % enable pausing
    pause on;

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
            %% start main algorithm

            % read config from connection request
            [dataToRead, dataToWrite] = handleConnectMessage(request); 

            while true
                % create ctmat file for the client
                % TODO: instead of load data, here the test bench creates new data
                data = load(exampleData,'-mat');
                [createdCtmatLocation, ctmatCounter] = createCtmatFile(ctmatDirectory, dataToWrite, data.ctData, ctmatCounter);

                % notify client to read data provided on network share
                % send CTCOM readData message to client
                fprintf('\n\n Sending new data %05i \n',ctmatCounter);
                message = ReadDataMessage();
                message.setLocation(createdCtmatLocation);
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

                    % read client's readData answer
                    handleReadDataMessage(message, dataToRead);

                    % wait some time before sending new data to ctcom client
                    pause(waitTime);
                    continue;

                elseif message.getType() == MessageType.QUIT

                    % print CTCOM quit message
                    fprintf('Quit: %s\n', char(message.getMessage()));
                    break;

                end
            end
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
end