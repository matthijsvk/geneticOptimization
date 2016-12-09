function sendC2(teamName,teamPwd,data)
M=5;
N=6;
Wmin=0.27e-6;
Lmin=0.18e-6;
Dmax=27e-6;
lb=[ Wmin Lmin Wmin Lmin Wmin 0 ];
ub=[ Dmax Dmax Dmax Dmax Dmax 1.8] ;

if size(data,1)~=M  || size(data,2)~=N 
    error( ['Wrong size of data. A ' num2str(M) 'x' num2str(N) '-matrix is expected.']);
end

if any(any( data < lb )) || any(any( data > ub ))
    error('Your data do not comply to the design constraints.');
end

host='hermippe.esat.kuleuven.be';
%fid=fopen('inputs.scs');
%data=fread(fid,Inf,'char');
%fclose(fid);

t=tcpip(host,9999,'OutputBufferSize',2048*5);
flag=true;
while flag
	try
		fopen(t);
		fwrite(t,teamName);
        if wait(t)
            fclose(t);
            break;
        end
        tmp=fread(t,t.BytesAvailable);
        %display(char(tmp'))
        if strcmp(char(tmp'),'TNR')
            disp('Your teamname was not recognized.');
            fclose(t);
            break;
        end
        disp('Teamname recognized.');
        
        fwrite(t,teamPwd);
        if wait(t)
            fclose(t);
            break;
        end
        tmp=fread(t,t.BytesAvailable);
        %display(char(tmp'))
        if strcmp(char(tmp'),'PNA')
            disp('Your password is not valid.');
            fclose(t);
            break;
        end
        disp('Authentication succeded.');
        %data
        data=reshape(data',1,size(data,1)*size(data,2));
        fwrite(t,double(data),'double');
        disp('Data sent.');
        
        fclose(t);
        flag=false;
 	catch e
		pause(0.25);
		e.message
	end
end 

clear all; %#ok<CLALL>
