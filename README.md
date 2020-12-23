# Bone Cancer Biopsy Navigation
This program simulates the calibration and tracking of a rigid surgical tool used in a tumor biopsey procedure. Within the simulation, the tool must travel along a linear trajectory through a given window (approximated as a sphere) before entering the tumor tissue to be biopsied. The tool itself is marked with 3 fixed non-collinear markers, as is the patient. These marker's locations can be identified by a nearby optical tracking device. Once the tool is calibrated, it can be tracked to check how far its tip is from the tumor centre, as well as whether the tool's current trajectory along its principal axis passes through the window and tumor. 

The tumor and window centres' coordinates are given in a CT frame, as are their radii, and so are the patient tracker coordinates. The tool's marker coordinates are given in the frame of the optical tracker, and the tool tip and tool direction vector are computed in the frame of the tool. Additionally, the coordinates of the patient trackers are given in the the optical tracker frame. From these sets of coordinates, the relevent quantities can be computed using a series of frame transformations.

## main
Drives the entire program

## Tool_Tip_Calibration/Tool_Tip_Calibration_2/Tool_Tip_Calibration_3
These functions all compute the location of the tool tip with respect to the tool frame using a matrix of tool marker points in the tracker frame. Methods are described in the comments of each function.

## Tool_Axis_Calibration_Testing
This function computes the tool's axis direction vector in its own frame using a matrix of tool marker points in the tracker frame. Methods are described in the module.

## Surgical Navigation
This function uses the patient markers in both the CT and tracker frame, the tumor and window centre and radius in the CT frame, the tool markers in the tracker frame, and the tip and direction vector of the tool in the tool frame to compute the tool's current trajectory and distance to the tumor centre as described above. 
