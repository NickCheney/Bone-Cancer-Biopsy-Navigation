% Nick Cheney
% SN 20063624
% 2020/11/24
% CISC 330 
% Bone Cancer Biopsy Navigation

% This function computes the positions of the simulation tumor, window,
% tool tip, axis and tool trajectory vector in the tracker frame, then uses
% these along with predetermined global variables to check proper tool
% trajectory, tool tip distance from depth of tumor centre, and then plot
% the navigation scene.

function Surgical_Navigation(Apat_track, Bpat_track, Cpat_track, Atool_track, Btool_track, Ctool_track)
% Takes the positions of trackers in the patient frame and tools in the
% tool frame, and uses these to compute tumor, window, tool tip, tool
% axis, and tool trajectory line in the tracker frame, then performs
% computations as described above.
% INPUTS:
%       Apat_track - position of patient frame tracker A
%       Bpat_track - position of patient frame tracker B
%       Cpat_track - position of patient frame tracker C
%       Atool_track - position of tool frame tracker A
%       Btool_track - position of tool frame tracker B
%       Ctool_track - position of tool frame tracker C
% OUTPUTS:
%       None
% SIDE EFFECTS:
%       Prints a statement regarding whether or not tool trajectory passes
%       through tumor and/or window, prints required increase in depth of
%       tool tip to the tumor centre, and plots a navigation scene with all
%       computed quantities.

%declare some global variables to be used 
% In Tool frame
global TIPTOOL;
global VAXTOOL;

% In CT frame
global A_PAT_CT;
global B_PAT_CT;
global C_PAT_CT;
global TUM_CTR_CT;
global TUM_RAD_CT;
global WIN_CTR_CT;
global WIN_RAD_CT;

% First we'll transform the tool tip and tool axis direction vector from
% the tool frame into the tracker frame

% Start by computing the frame transformation from tool to home/tracker
% Generate tool frame
[F_tool,e1, e2, e3] = Generate_Orthonormal_Frame(Atool_track, Btool_track, Ctool_track);
% generate the transformation matrix from the tool frame to the tracker
% frame
F_T = Frame_Transformation_to_Home(F_tool,e1, e2, e3);
Tip_track = F_T * [TIPTOOL.'; 1];
% unpad and take transpose
Tip_track(4,:) = [];
Tip_track = Tip_track.';

fprintf("Tool tip in the tracker frame: [%.4f,%.4f,%.4f]\n", Tip_track(1),Tip_track(2),Tip_track(3));

% then crop the F tracker<-tool transformation to only leave its rotational
% component
F_T(4,:) = [];
F_T(:,4) = [];

% and use this to transform the tool axis direction vector into the tracker
% frame
vax_track = (F_T * VAXTOOL.').';
fprintf("Tool axis direction vector in the tracker frame: [%.4f,%.4f,%.4f]\n", vax_track(1),vax_track(2),vax_track(3));
fprintf("Tool trajectory line:\nTool_Traj_track = [%.4f,%.4f,%.4f] + t[%.4f,%.4f,%.4f]\n\n",...
        Tip_track(1),Tip_track(2),Tip_track(3),vax_track(1),vax_track(2),vax_track(3));
    
% next move onto quantities originally in the CT frame, starting by
% computing the transformation matrix from CT to patient frame as described
% in the paper derivation

% Generate patient frame using CT frame as "home"
[F_patCT, v1, v2, v3] = Generate_Orthonormal_Frame(A_PAT_CT, B_PAT_CT, C_PAT_CT);
% generate the transformation matrix from the patient frame to CT frame
F_pat2CT = Frame_Transformation_to_Home(F_patCT, v1, v2, v3);
% take the inverse to find the frame transformation from CT "home" to
% patient frame
F_CT2pat = inv(F_pat2CT);

% Next, generate the patient frame using tracker frame as home
[F_patTrack, w1, w2, w3] = Generate_Orthonormal_Frame(Apat_track, Bpat_track, Cpat_track);
% generate the transformation matrix from the patient frame to tracker home
% frame
F_pat2track = Frame_Transformation_to_Home(F_patTrack, w1, w2, w3);

% Now we can compute the centre of the tumor in the tracker frame and the
% overall tumor sphere equation in the tracker frame using the padded
% transpose of TumCtrCT using the derived logic
TumCtrTrack = F_pat2track * F_CT2pat * [TUM_CTR_CT.'; 1];
TumCtrTrack(4,:) = [];
TumCtrTrack = TumCtrTrack.';
% Tumor radius remains the same
TumRadTrack = TUM_RAD_CT;
fprintf("Equation of tumor sphere in tracker frame:\n");
fprintf("(x - %g) + (y - %g) + (z - %g) = %g^2\n", TumCtrTrack(1),TumCtrTrack(2), TumCtrTrack(3), TumRadTrack);
% and same for the centre of the window sphere and it's equation in the
% tracker frame:
WinCtrTrack = F_pat2track * F_CT2pat * [WIN_CTR_CT.'; 1];
WinCtrTrack(4,:) = [];
WinCtrTrack = WinCtrTrack.';
% Tumor radius remains the same
WinRadTrack = WIN_RAD_CT;
fprintf("Equation of window sphere in tracker frame:\n");
fprintf("(x - %g) + (y - %g) + (z - %g) = %g^2\n\n", WinCtrTrack(1),WinCtrTrack(2), WinCtrTrack(3), WinRadTrack);

% With the above computed qunatities, we can now compute whether or not the
% current tool trajectory passes through both the window and the tumor.
% NOTE: I will consider "passing through" to require the trajectory to have
% 2 points of intersection with the object's sphere, 1 being insufficient.

% find number of intersections between tool trajectory and window using
% prior module from first assingment (axis half lengths a,b,c all equal
% window radius). Since this module only works on an ellipsoid centred at
% (0,0,0), subtract the 
[trajWinInts, ~] = Intersect_Line_and_Ellipsoid((Tip_track - WinCtrTrack), vax_track, WinRadTrack,WinRadTrack,WinRadTrack);

% find the same for the tumor
[trajTumInts, ~] = Intersect_Line_and_Ellipsoid((Tip_track - TumCtrTrack), vax_track, TumRadTrack,TumRadTrack,TumRadTrack);

if (trajWinInts == 2)
    if (trajTumInts == 2)
        fprintf("Current tool trajectory passes through window and tumor\n\n")
    else
        fprintf("Current tool trajectory passes through window but not tumor\n\n")
    end
elseif (trajTumInts == 2)
    fprintf("Current tool trajectory passes through tumor but not window\n\n")
else
    fprintf("Current tool trajectory passes through neither tumor or window\n\n")
end

% And now move on to calculating remaining drill distance to reach the
% depth of the tumor centre
% NOTE: the "depth" will be considered the linear distance between the
% current tool tip position and a plane containing the centre of the tumor
% with a normal equal to the current tool trajectory direction vector. 

% To me, this makes more sense than the pure distance between the tool tip
% and the centre of the tumor, but they will be the same if the tool's
% trajectory will intersect the tumor centre exactly. 

% first, use a prewritten module from assingment 1 to find the intersection
% between the above described plane and the tool trajectory
tumCtrTrajInt = Intersect_Line_and_Plane(TumCtrTrack, vax_track, Tip_track, vax_track);

% then compute the distance between this intersection and the tool tip as
% the required increase in depth
dIncr = norm(tumCtrTrajInt - Tip_track);

fprintf("Required further drilling distance to reach depth of tumor centre: %g\n\n", dIncr);

% Now given the computed quantities, plot the overall navigation scene

% Start by plotting tumor
[X,Y,Z] = sphere;
XTum = X * TumRadTrack;
YTum = Y * TumRadTrack;
ZTum = Z * TumRadTrack;
% select tumor sphere edge colour to be red
lightRed = [1 0.75 0.75];
%plot sphere (20x20 surface patches)
surf(XTum + TumCtrTrack(1),YTum + TumCtrTrack(2),ZTum + TumCtrTrack(3),'FaceColor', 'none','EdgeColor',lightRed)
% maintain equal ratios of axes increments
axis equal
% plot more on the same graph
hold on;
% plot centre of tumor
plot3(TumCtrTrack(1), TumCtrTrack(2), TumCtrTrack(3), 'r.', 'MarkerSize', 30);
text(TumCtrTrack(1)+0.5, TumCtrTrack(2), TumCtrTrack(3), "Tumor Centre");

% plot the window next
XWin = X * WinRadTrack;
YWin = Y * WinRadTrack;
ZWin = Z * WinRadTrack;
% select window sphere edge colour to be green
lightGreen = [0.75 1 0.75];
%plot window sphere (20x20 surface patches)
surf(XWin + WinCtrTrack(1),YWin + WinCtrTrack(2),ZWin + WinCtrTrack(3),'FaceColor', 'none','EdgeColor',lightGreen)
% plot center of window
plot3(WinCtrTrack(1), WinCtrTrack(2), WinCtrTrack(3), 'g.', 'MarkerSize', 30);
text(WinCtrTrack(1)+0.5, WinCtrTrack(2), WinCtrTrack(3), "Window Centre");

% plot patient markers
plot3(Apat_track(1), Apat_track(2), Apat_track(3), 'y.', 'MarkerSize', 30);
text(Apat_track(1)+0.5, Apat_track(2), Apat_track(3), "A patient marker");
plot3(Bpat_track(1), Bpat_track(2), Bpat_track(3), 'y.', 'MarkerSize', 30);
text(Bpat_track(1)+0.5, Bpat_track(2), Bpat_track(3), "B patient marker");
plot3(Cpat_track(1), Cpat_track(2), Cpat_track(3), 'y.', 'MarkerSize', 30);
text(Cpat_track(1)+0.5, Cpat_track(2), Cpat_track(3), "C patient marker");

% plot tool markers
plot3(Atool_track(1), Atool_track(2), Atool_track(3), 'm.', 'MarkerSize', 30);
text(Atool_track(1)+0.5, Atool_track(2), Atool_track(3), "A tool marker");
plot3(Btool_track(1), Btool_track(2), Btool_track(3), 'm.', 'MarkerSize', 30);
text(Btool_track(1)+0.5, Btool_track(2), Btool_track(3), "B tool marker");
plot3(Ctool_track(1), Ctool_track(2), Ctool_track(3), 'm.', 'MarkerSize', 30);
text(Ctool_track(1)+0.5, Ctool_track(2), Ctool_track(3), "C tool marker");

% plot tool tip and tool axis vector
plot3(Tip_track(1), Tip_track(2), Tip_track(3), 'mo', 'MarkerSize', 5);
text(Tip_track(1)-2, Tip_track(2), Tip_track(3), "Tool tip");
vectarrow(Tip_track, (Tip_track + vax_track));
text(Tip_track(1) + vax_track(1) -3, Tip_track(2) + vax_track(2)+2.5, Tip_track(3) + vax_track(3), "Tool axis direction vector");

% generate range of trajactory line 
t = -11:0.1:25;
Xtr = Tip_track(1) + vax_track(1) * t;
Ytr = Tip_track(2) + vax_track(2) * t;
Ztr = Tip_track(3) + vax_track(3) * t;

% finally, plot trajectory line
plot3(Xtr, Ytr, Ztr, '--');
hold off;
end