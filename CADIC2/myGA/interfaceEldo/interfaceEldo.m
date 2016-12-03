function obj = interfaceEldo(filename,x)

    % Example for DC simulations
    injectValues(filename,x,'dc');
    unix(['eldo interfaceEldo/' filename '/dc ']);%> /dev/null']);
    dataDC=extractDC(filename);
    
    % Example for Transient simulations
    injectValues(filename,x,'tran');
    unix(['eldo interfaceEldo/' filename '/tran ']);%> /dev/null']);
    dataTran=extractTran(filename);
    
    for j=1:10
        plot(dataTran{j}.time,dataTran{j}.X);
        drawnow;
        pause;
    end
    
    % Example for AC simulations
    injectValues(filename,x,'ac');
    unix(['eldo interfaceEldo/' filename '/ac ']);%> /dev/null']);
    dataAC=extractAC(filename);
    
    for j=1:10
        loglog(dataAC{j}.f, sum([dataAC{j}.RX dataAC{j}.IX].^2,2) );
        drawnow;
        pause;
    end
    
    % Compute objectives
    %obj(:,1)=;
    %obj(:,2)=;
    %obj(:,3)=;
    
end

