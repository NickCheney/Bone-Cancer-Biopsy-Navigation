% Nick Cheney
% SN 20063624
% 2020/11/24
% CISC 330 
% Bone Cancer Biopsy Navigation
% 
% This script tests the function Surgical_Navigation(). It starts by
% plotting the preoperative plan in the CT frame, then calls
% Surgical_Navigation() three times for three different groud-truth
% solution navigation cases. 

% %declare some global variables to be used (In CT frame)
global A_PAT_CT;
global B_PAT_CT;
global C_PAT_CT;
global TUM_CTR_CT;
global TUM_RAD_CT;
global WIN_CTR_CT;
global WIN_RAD_CT;

% Initialize the patient trackers in the tracker frame, these will remain
% constant
ApatTrack = [-2,8,55];
BpatTrack = [4,8,55];
CpatTrack = [-2,14,55];

% Start by plotting the pre-operative plan in the CT frame
figure(1)

% First plot tumor
[X,Y,Z] = sphere;
XTum = X * TUM_RAD_CT;
YTum = Y * TUM_RAD_CT;
ZTum = Z * TUM_RAD_CT;
% select tumor sphere edge colour to be red
lightRed = [1 0.75 0.75];
%plot sphere (20x20 surface patches)
surf(XTum + TUM_CTR_CT(1),YTum + TUM_CTR_CT(2),ZTum + TUM_CTR_CT(3),'FaceColor', 'none','EdgeColor',lightRed)
hold on;
axis equal;
% plot centre of tumor
plot3(TUM_CTR_CT(1), TUM_CTR_CT(2),TUM_CTR_CT(3), 'r.', 'MarkerSize', 30);
text(TUM_CTR_CT(1)+0.5, TUM_CTR_CT(2), TUM_CTR_CT(3), "Tumor Centre");

% plot the window next
XWin = X * WIN_RAD_CT;
YWin = Y * WIN_RAD_CT;
ZWin = Z * WIN_RAD_CT;
% select window sphere edge colour to be green
lightGreen = [0.75 1 0.75];
%plot window sphere (20x20 surface patches)
surf(XWin + WIN_CTR_CT(1),YWin + WIN_CTR_CT(2),ZWin + WIN_CTR_CT(3),'FaceColor', 'none','EdgeColor',lightGreen)
% plot center of window
plot3(WIN_CTR_CT(1), WIN_CTR_CT(2), WIN_CTR_CT(3), 'g.', 'MarkerSize', 30);
text(WIN_CTR_CT(1)+0.5, WIN_CTR_CT(2), WIN_CTR_CT(3), "Window Centre");

% then add patient markers
plot3(A_PAT_CT(1), A_PAT_CT(2), A_PAT_CT(3), 'y.', 'MarkerSize', 30);
text(A_PAT_CT(1)+0.5, A_PAT_CT(2), A_PAT_CT(3), "A patient marker");
plot3(B_PAT_CT(1), B_PAT_CT(2), B_PAT_CT(3), 'y.', 'MarkerSize', 30);
text(B_PAT_CT(1)+0.5, B_PAT_CT(2), B_PAT_CT(3), "B patient marker");
plot3(C_PAT_CT(1), C_PAT_CT(2), C_PAT_CT(3), 'y.', 'MarkerSize', 30);
text(C_PAT_CT(1)+0.5, C_PAT_CT(2), C_PAT_CT(3), "C patient marker");


% label axis
xlabel("x");
ylabel("y");
zlabel("z");
hold off;

% Begin the navigation testing
fprintf("NAVIGATION CASE 1\n");
% Initialize the tool trackers in the tracker frame, these will change ever
% test
AtoolTrack = [-2,18,50];
BtoolTrack = [4,18,50];
CtoolTrack = [-2,24,50];
figure(2);
Surgical_Navigation(ApatTrack,BpatTrack,CpatTrack,AtoolTrack,BtoolTrack,CtoolTrack);


fprintf("NAVIGATION CASE 2\n");
AtoolTrack = [-2,23,50];
BtoolTrack = [4,23,50];
CtoolTrack = [-2,29,50];
figure(3);
Surgical_Navigation(ApatTrack,BpatTrack,CpatTrack,AtoolTrack,BtoolTrack,CtoolTrack);

fprintf("NAVIGATION CASE 3\n");
AtoolTrack = [-3,25,50];
BtoolTrack = [3,25,50];
CtoolTrack = [-3,31,50];
figure(4)
Surgical_Navigation(ApatTrack,BpatTrack,CpatTrack,AtoolTrack,BtoolTrack,CtoolTrack);