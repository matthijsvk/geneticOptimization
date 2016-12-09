function obj = interfaceEldo(filename,x)

    nbCircuits = size(x,1);
    
    % Example for DC simulations
    injectValues(filename,x,'dc');
    unix(['eldo interfaceEldo/' filename '/dc > /dev/null']);
    dataDC=extractDC(filename);
    
    %% get P, area
    v =1.8;
    i = dataDC; disp(length(i));
    Pvector = abs(v*i);
    disp([nbCircuits, length(Pvector)]);
%     fprintf('Power:   %d ',Pvector)
    
    % Example for AC simulations
    injectValues(filename,x,'ac');
    unix(['eldo interfaceEldo/' filename '/ac > /dev/null']);
    dataAC = extractAC(filename);

    GBWresults = zeros(nbCircuits,1);
    unityGBWresults = zeros(nbCircuits,1);
    BWresults = zeros(nbCircuits,1);
    
    for j=1:nbCircuits
        Zmagn= sqrt(sum([dataAC{j}.RX dataAC{j}.IX].^2,2));
        Zph= atan(dataAC{j}.IX ./ dataAC{j}.RX);
       
        %% get G, BW, GBW, unityGBW
        Zmagn = Zmagn;
        Gain = Zmagn(1);
        % find GBW: see where Zamp (=Vout goes below Vin*0.708)
        BWvector = dataAC{j}.f(Zmagn < 0.708*Zmagn(1)); 
        if size(BWvector,1) > 0
            BW = BWvector(1);
        else
            BW = 1; %1Hz, otherwise GBW is zero for all, and crowdingDistance is NaN
        end
        GBW = BW * Gain;
        
        % find unityGBW: see where Zamp (=Vout goes below Vin)
        unityGBWvector = dataAC{j}.f(Zmagn < 1);
        if size(unityGBWvector, 1) == size(dataAC{j}.f,1) % gain always lower than 1
            unityGBW = 1;
        elseif size(unityGBWvector ,1) > 0 % some freqs with gain higher than 1
            unityGBW = unityGBWvector(1);
        else
            unityGBW = 1; % eg if gain goes up and never comes down (which is not realistic)
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
        
        %obj(j,1)=-Gain;
        obj(j,1)=10 * log10(Pvector(j) );
        obj(j,2)=-GBW; %minus because we want to maximize GBW (and the GA tries to minimize everything)
        disp([BW, Gain, GBW])
        
    end   
end

