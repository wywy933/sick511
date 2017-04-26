% fclose(t);
t = tcpip('192.168.0.1',2112);
t.InputBufferSize = 5000;
t.OutputBufferSize = 2000;
t.Terminator = char(03);


ScanAngle_min = -5;
ScanAngle_max = 185;
ScanAngle_min = ScanAngle_min * pi / 180;
ScanAngle_max = ScanAngle_max * pi / 180;
ScanAngle_total = abs(ScanAngle_min) + abs(ScanAngle_max);

% Authorised client. password: client
login_client = add_ascii_frame('sMN SetAccessMode 03 F4724744');

% Service level. password:servicelevel
login_service = add_ascii_frame('sMN SetAccessMode 04 81BE23AA');
storecfg = add_ascii_frame('sMN mEEwriteall');
run = add_ascii_frame('sMN Run');
% Output of measured values of one scan.
% Sends the last valid scan data back from the memory of the LMS. 
% Also if the measurement is not running, the last measurement is available.
pull_single = add_ascii_frame('sRN LMDscandata');

pull_cont = add_ascii_frame('sEN LMDscandata 1');
pull_stop = add_ascii_frame('sEN LMDscandata 0');

 fopen(t);

query(t,login_client)
A = query(t,pull_single);
query(t,storecfg);
query(t,run);
A = strread(A,'%s','delimiter',' ');
A = A';

r_CommandTitle = [A(1,1) A(1,2)];
r_VersionNumber = A(1,3);
r_DeviceNumber = A(1,4);
r_SerialNumber = A(1,5);
r_DeviceStatus = [A(1,6) A(1,7)];
r_TelegrammCounter = A(1,8);
r_ScanCounter = A(1,9);
% time since start up scan
% time of transmission scan
% status of digital inputs

r_ScanFrequency = A(1,17); %1388hex = 50Hz
r_MeasurementFrequency = A(1,18);
r_DistanceTag = A(1,21);
r_ScaleFactor = A(1,22);
r_ScaleFactorOffset = A(1,23);
r_StartAngle = A(1,24);
r_Steps = A(1,25);
r_AmountOfData = A(1,26);

r_Distance = A(1,27:end-6);

r_MeasurementFrequency = A(1,18); %read frequency

time = 1;
while 1
   
    
    [A B] = query(t,pull_single); %pull data stream from 511
    A = strread(A,'%s','delimiter',' ');
    A = A';
    
    
    %%%%%%%%%%%%%%%calculate/check scale factor%%%%%%%%%%%%%%%%%%%%%%%%%%
    r_ScaleFactor = A(1,22);
    r_ScaleFactorOffset = hex2dec(A(1,23));
    if strcmp(r_ScaleFactor,'40000000')
        c_ScaleFactor = 2;
    else if strcmp(r_ScaleFactor,'3F800000')
            c_ScaleFactor = 1;
        else
            disp('ScaleFactor invalid.')
            c_ScaleFactor = 1;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%data valid check%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    r_AmountOfData = hex2dec(A(1,26));
    r_Distance = A(1,27:end-6);
    if r_AmountOfData ~= length(r_Distance)
        disp('data length does not match. value invalid');
    end
    
    %%%%%%%%%%%%%%%%
    [Xmax,Ymax] = size(r_Distance);
    
    c_Distance = zeros(1,Ymax);
    for y = 1:Ymax
        c_Distance(y) = hex2dec(r_Distance(y));
    end
    c_Distance = (c_Distance ./ 1000) .* c_ScaleFactor;
    
    theta = ScanAngle_min + ScanAngle_total / length(r_Distance):...
        ScanAngle_total  / length(r_Distance): ...
        ScanAngle_max;
    tic
    clf;
    polar(theta,c_Distance,'.')
    title(time);
    grid on;
    pause(0.0005);

    time = toc;


end