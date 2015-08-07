function outCtmat = handleTestbenchWrite( request, ctData, outCtmatPath )
%HANDLETESTBENCHWRITE Summary of this function goes here
%   Detailed explanation goes here

    testbenchWriteInfos = cell(request.getTestbenchWrite().toArray());
    for n = 1:length(testbenchWriteInfos)
       structField = testbenchWriteInfos{n};
       outCtmat.structField = ctData.(structField);
    end
    % save ctmat file into network share
    save(outCtmatPath, 'outCtmat');

end

