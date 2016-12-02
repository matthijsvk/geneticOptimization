function obj = interfaceEldo(filename,x)

    nbCircuits = size(x,1);
    
    % Example for DC simulations
    injectValues(filename,x,'dc');
    unix(['eldo interfaceEldo/' filename '/dc > /dev/null']);
    dataDC=extractDC(filename);
    
    %% get P, area
    v =1.8;
    i = dataDC;
    Pvector = abs(v*i);
%     fprintf('Power:   %d ',Pvector)
%     
%     % Example for Transient simulations
%     injectValues(filename,x,'tran');
%     unix(['eldo interfaceEldo/' filename '/tran > /dev/null']);
%     dataTran=extractTran(filename);
%     
%     for j=1:10
%         plot(dataTran{j}.time,dataTran{j}.X);
%         drawnow;
%         pause;
%     end
    
    % Example for AC simulations
    injectValues(filename,x,'ac');
    unix(['eldo interfaceEldo/' filename '/ac > /dev/null']);
    dataAC = extractAC(filename);

    GBWresults = zeros(nbCircuits,1);
    unityGBWresults = zeros(nbCircuits,1);
    BWresults = zeros(nbCircuits,1);
    
    for j=1:nbCircuits
        Zmagn= sum([dataAC{j}.RX dataAC{j}.IX].^2,2);
        Zph= atan(dataAC{j}.IX ./ dataAC{j}.RX);
       
        %% get G, BW, GBW, unityGBW
        Gain = Zmagn(1)/0.001;
        % find GBW: see where Zamp (=Vout goes below Vin*0.708)
        BWvector = dataAC{j}.f(Zmagn < 0.708*Zmagn(1)); 
        if size(BWvector,1) > 0
            BW = BWvector(1);
        else
            BW = j;
        end
        GBW = BW * Gain;
        
        % find unityGBW: see where Zamp (=Vout goes below Vin)
        unityGBWvector = dataAC{j}.f(Zmagn < 1);
        if size(unityGBWvector, 1) == size(dataAC{j}.f,1)
            unityGBW = 0;
        elseif size(unityGBWvector ,1) > 0
            unityGBW = unityGBWvector(1);
        else
            unityGBW = 0;
        end
        
%         fprintf('Gain:   %d ',Gain)
%         fprintf('BW:   %d ',BW)
%         fprintf('GBW:   %d ',GBW)
%         fprintf('unityGBW: %d',unityGBW)

%         close all;
%         subplot(2,1,1,'replace') ;
%         loglog(dataAC{j}.f, Zmagn );
%         title('Amplitude Plot');
%         subplot(2,1,2,'replace');
%         semilogx(dataAC{j}.f, Zph);
%         title('Phase Plot')
%         drawnow;
%         pause;
        
        GBWresults(j) = GBW;
        unityGBWresults(j) = unityGBW;
        BWresults(j) = BW;

    end
    
    % Compute objectives
    obj(:,1)=1/GBWresults;
    obj(:,2)=1/Pvector;
    %obj(:,3)=BWresults;

    
end

