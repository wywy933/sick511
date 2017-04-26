fclose(t);
clc;
close all;
clear all;
t = tcpip('192.168.0.1',2112); % create tcp portal
t.InputBufferSize = 9000; % change input buffer size to 5000 bytes
t.OutputBufferSize = 2000; % change output buffer size to 2000 bytes
t.Terminator = char(03); % set read terminator to ETX which is 03 in ascii


ScanAngle_min = -5; %preset minimum scan angle value
ScanAngle_max = 185; %preset maximum scan angle value
ScanAngle_min = ScanAngle_min * pi / 180; % change from degree to radius
ScanAngle_max = ScanAngle_max * pi / 180; % change from degree to radius
ScanAngle_total = abs(ScanAngle_min) + abs(ScanAngle_max); % total degrees

% Authorised client. password: client
login_client = add_ascii_frame('sMN SetAccessMode 03 F4724744');

% Service level. password:servicelevel
login_service = add_ascii_frame('sMN SetAccessMode 04 81BE23AA');
% store all configration to hardware
storecfg = add_ascii_frame('sMN mEEwriteall');
% log out and run
run = add_ascii_frame('sMN Run');

setscancfg = ...
    add_ascii_frame('sMN mLMPsetscancfg +2500 +1 +683 -50000 +1850000');
getscancfg = add_ascii_frame('sRN LMPscancfg');
setoutputrange = ...
    add_ascii_frame('sWN LMPoutputRange +1 +683 -50000 +1850000');
askoutputrange = add_ascii_frame('sRN LMPoutputRange');

% Output of measured values of one scan.
% Sends the last valid scan data back from the memory of the LMS.
% Also if the measurement is not running,
% the last measurement is available.
pull_single = add_ascii_frame('sRN LMDscandata');

% start to keep sending scanned value
pull_cont = add_ascii_frame('sEN LMDscandata 1');
% stop to keep sending scanned value
pull_stop = add_ascii_frame('sEN LMDscandata 0');


fopen(t); %open preset portal

% log in check
% set frequency and resolution
% configure scandata content
% configure scandata output
% store parameters
% log out
% request scan

query(t,login_client) %login as client
% query(t,setscancfg)
query(t,getscancfg)
% query(t,setoutputrange)
query(t,askoutputrange)
query(t,storecfg) %store configration into device
query(t,run) % log out and run
A = query(t,pull_single); % pull very last scan data
A = strread(A,'%s','delimiter',' '); %seperate read string into array
A = A'; % change dimention

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

r_Distance = A(1,27:end-6); % scanned data string

r_MeasurementFrequency = A(1,18); %read frequency


%%%%%%%%%%%%%%%%%%%%%%%%%%working area%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
time = 1; % preset time value

% while starts here
while 1
    
    [AA B] = query(t,pull_single); %pull data stream from 511
    AA = strread(AA,'%s','delimiter',' ');
    A = AA';
    
    
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%data valid check%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    r_AmountOfData = hex2dec(A(1,26));
    r_Distance = A(1,27:end-6);
    if r_AmountOfData ~= length(r_Distance)
        disp('data length does not match. value invalid');
    end
    
    %%%%%%%%%%%%%%%%
    [Xmax,Ymax] = size(r_Distance);
    
    c_Distance = zeros(1,r_AmountOfData);
    for y = 1:r_AmountOfData
        c_Distance(y) = hex2dec(r_Distance(y));
    end
    c_Distance = (c_Distance ./ 1000) .* c_ScaleFactor;
    
    %     theta = ScanAngle_min + ScanAngle_total / length(r_Distance):...
    %         ScanAngle_total  / length(r_Distance): ...
    %         ScanAngle_max;
    angle_step = ScanAngle_total / length(r_Distance);
    theta = ScanAngle_min + angle_step :angle_step:ScanAngle_max;
    c_Distance = medfilt1(c_Distance,9);
    clf
    
    subplot(2,2,1);
    polar(theta,c_Distance,'.');
    grid on;
    
    dis = c_Distance; % generate another distance copy, 
                      % to protect the origenal data from polluted
    
    %%%%%%%%%%%%%%%%%%%%%%angle limitation%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    given_angle_1_low = 85;
    given_angle_1_high = 105;
    layer_anger_diff = 10;
    given_angle_1_low = given_angle_1_low * pi / 180;
    given_angle_1_high = given_angle_1_high * pi / 180;
    layer_anger_diff = layer_anger_diff * pi / 180;
    
    given_angle_2_low = given_angle_1_low - layer_anger_diff;
    given_angle_2_high = given_angle_1_high + layer_anger_diff;
    
    given_angle_3_low = given_angle_2_low - layer_anger_diff;
    given_angle_3_high = given_angle_2_high + layer_anger_diff;
    %%%%%%%%%%%%%%%%%%%%%detect corner within given angle range%%%%%%%%%%%
    
    maxdis = 0;
    
%     angle_step = ScanAngle_total / length(r_Distance);
%     theta = ScanAngle_min + angle_step :angle_step:ScanAngle_max;
    
    [max_dis,i] = max(dis);
    
    
    hold on;
    
    polar([0 theta(i)],[0 dis(i)],'r')
    polar([0 -5*pi/180],[0 dis(i)],'g')
    polar([0 185*pi/180],[0 dis(i)],'g')
    title(['max distance at',num2str(theta(i)*180/pi),'with value of',num2str(dis(i))]);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%layer 1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    subplot(2,2,2);
    limited_theta_1 = ScanAngle_min + (fix(given_angle_1_low / angle_step)) * angle_step:...
                    angle_step:...
                    ScanAngle_min + (fix(given_angle_1_high / angle_step) + 1) * angle_step;
    limited_dis_1 = dis(fix(given_angle_1_low / angle_step)-1:fix(given_angle_1_high / angle_step));
    polar(limited_theta_1,limited_dis_1,'.');
    hold on;
%     polar([0 maxatr + angle_step],[0 max(dis)])
    [max_dis,i] = max(limited_dis_1);
    polar([0 limited_theta_1(i)],[0 limited_dis_1(i)],'r')
    polar([0 ScanAngle_min + (fix(given_angle_1_low / angle_step)) * angle_step],[0 limited_dis_1(i)],'g')
    polar([0 ScanAngle_min + (fix(given_angle_1_high / angle_step) + 1) * angle_step],[0 limited_dis_1(i)],'g')
    title(['max distance at',num2str(limited_theta_1(i)*180/pi),'with value of',num2str(limited_dis_1(i))]);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%layer 2%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2,2,3);
    limited_theta_2 = ScanAngle_min + (fix(given_angle_2_low / angle_step)) * angle_step:...
                    angle_step:...
                    ScanAngle_min + (fix(given_angle_2_high / angle_step) + 1) * angle_step;
    limited_dis_2 = dis(fix(given_angle_2_low / angle_step)-1:fix(given_angle_2_high / angle_step));
    polar(limited_theta_2,limited_dis_2,'.');
    hold on;
%     polar([0 maxatr + angle_step],[0 max(dis)])
    [max_dis,i] = max(limited_dis_2);
    polar([0 limited_theta_2(i)],[0 limited_dis_2(i)],'r')
    polar([0 ScanAngle_min + (fix(given_angle_2_low / angle_step)) * angle_step],[0 limited_dis_2(i)],'g')
    polar([0 ScanAngle_min + (fix(given_angle_2_high / angle_step) + 1) * angle_step],[0 limited_dis_2(i)],'g')
    title(['max distance at',num2str(limited_theta_2(i)*180/pi),'with value of',num2str(limited_dis_2(i))]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%layer 3%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(2,2,4);
    limited_theta_3 = ScanAngle_min + (fix(given_angle_3_low / angle_step)) * angle_step:...
                    angle_step:...
                    ScanAngle_min + (fix(given_angle_3_high / angle_step) + 1) * angle_step;
    limited_dis_3 = dis(fix(given_angle_3_low / angle_step)-1:fix(given_angle_3_high / angle_step));
    polar(limited_theta_3,limited_dis_3,'.');
    hold on;
%     polar([0 maxatr + angle_step],[0 max(dis)])
    [max_dis,i] = max(limited_dis_3);
    polar([0 limited_theta_3(i)],[0 limited_dis_3(i)],'r')
    polar([0 ScanAngle_min + (fix(given_angle_3_low / angle_step)) * angle_step],[0 limited_dis_3(i)],'g')
    polar([0 ScanAngle_min + (fix(given_angle_3_high / angle_step) + 1) * angle_step],[0 limited_dis_3(i)],'g')
    title(['max distance at',num2str(limited_theta_3(i)*180/pi),'with value of',num2str(limited_dis_3(i))]);
    
    
    
    
    pause(0.001);
end

% maxdis
% maxatd









