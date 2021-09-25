/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CameraMount.scad - MS lifecam holder and a PI Zero & PI Cam holder
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 1/31/16
// last update 9/4/2121
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ABS or something that can handle the heatbed temperature
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 3/23/16	- added clamping screw for cam
// 12/23/18	- Added preview colors and a PI3 with camera in a plastic case holder
//			  Added cubeX.scad
// 4/10/19	- Changed to a PI Zero W all in one holder, currently set for a Raspberry PI Camera Rev1.3
// 6/11/20	- Change PI cam opening to one that can also use wide angle cam, added ability to use 2mm brass inserts
// 7/23/20	- Fixed camera mounting holes
// 7/25/20	- Fixed PIShield() holes
// 7/25/20	- Changed pi camera mounting
// 7/30/20	- Added screw hole supoort for the mount()
// 8/20/20	- Needed more clearance for the pi camera version, reduced the outer diameter of the cam mount
// 8/27/20	- Can now mount the Pi0W in either direction
// 8/29/20	- Now uses 2.5mm inserts and screws, hole for pi camera can use the wide or narrow ribbon cable
// 12/6/20	- Added a camera mount just for the pi camera
// 12/19/20	- Added a PI camera and MS webcam mount for the 2020/2040 extrusion printer frame
// 1/7/21	- Added a mount for a PI 0 for the PICamera2020() and MSWebCam2020()
// 2/27/21	- Added one piece PI0W & camera mount
// 3/4/21	- Made one piece pi0w mount to allow the camera to mount on either side of the pi
// 3/6/21	- Added Raspberry PI HQ camera mount (not tested, don't have one)
// 3/13/21	- Change allinone pi0w camera to center the camera mount on the pi0w holder and slotted the 2020 mounts
//			- to allow shifth to one side of the 2020
// 9/4/21	- Added side mount selection to PICamera2020AllInOne()
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://www.raspberrypi.org/documentation/hardware/raspberrypi/mechanical/README.md
// https://www.raspberrypi-spy.co.uk/2013/05/pi-camera-module-mechanical-dimensions
// https://static.raspberrypi.org/files/product-mechanical-drawings/20200428_HQ_Camera_Technical_drawing.pdf
// MS USB Webcam: Duet 3 w/SBC https://pimylifeup.com/raspberry-pi-webcam-server/
// For a PI Cam only: https://elinux.org/RPi-Cam-Web-Interface -- freezes on Duet 3 with PI4 during printing
// For the pi zero cover: https://www.thingiverse.com/thing:2165844, I used the RPI_Zero_W_Case_-_Top_-_Heatsink.stl
// https://randomnerdtutorials.com/video-streaming-with-raspberry-pi-camera/
// Uses four M2 to mount the PI Zero and four M2 to mount the PI Camera
// Web cam software I use: https://pimylifeup.com/raspberry-pi-webcam-server/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ** NOTE: May need a raft for the built in support for the camera bracket
// For the PI camera 1.3, it only has clearance for the ribbon connector, so don't overtighten
// Or, use the CameraHolder() underneath the pi camera
// Uses 2.5mm brass inserts for the pi 0 and 2mm brass inserts for the camera
// Print in PETG, ABS, or anything that handle your bed temperatrue without drooping
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>
include <inc/brassinserts.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
CameraDiameter = 29;	// outside diameter of usb camera
Length = 90;			// distance needed from bed to see the entire bed
OuterRingThickness = 8;	// thickness of ring to hold camera
Width = CameraDiameter + OuterRingThickness;	// width of the ring to hold camera
MountThickness = 6;		// thickness of extension and mount
ShiftCamera = -4.5;		// amount to move camera ring to end of extension
MountLength = 20;		// length of the mount
HotendNozzleSize = 0.4;	// nozzle size for print support for mount end
MountSupport = 6;		// height of print support for mount end
PIhw=30-3.5-3.5;		// pi zero w vertical screw hole width
PIhl=58;				// pi zero w horizontal screw hole width
PIChw=21;				// cam screw hole horizontal distance
PIChh=12.8; 			// cam screw hole vertical distance (my camera is a bit longer)
PICameraSize=24;		// smaller dimension of the camera circuit board
Nozzle=0.4;				// nozzle size
Layer=0.3;				// layer thickness
Use2mmInsert=1;			// pi camera
Use2p5mmInsert=1;		// pi 0 w
Use3mmInsert=1;
LargeInsert=0;
HQCamWidth=30;  // cable connection on back bottom
HQCamLength=30;
HQCamHoleOffset=4;
////////////////////////////////////////////////////////////////////////

//PICameraBracket(1);
//PICameraBracketNoPi(0,1);
//translate([18,10,-30.8]) CameraHolder();
//MSWebCameraBracket(0); // must use support
//MSWebCameraBracketV2(0); // must use support
//PICamera2020(1,0.2,1);
PICamera2020AllInOne(2,0.2,0);
//MSWebCam2020(1);
//HQCameraMount();

////////////////////////////////////////////////////////////////////////////////////////////////////

module MSWebCam2020(AddPI0Mount=0,Addtickness=0) {
	rotate([0,-90,0]) difference() {
			Mount2020();
			translate([-10,-1.5,-1]) color("darkgray") rotate([0,90,0]) cylinder(h=40,d=screw3);
	}
	translate([37,15,0]) MSWebCamMount();
	if(AddPI0Mount) {
		difference() {
			translate([0,70,6+AddThickness]) rotate([180,0,0]) Extension(1,0,AddThickness);
			translate([35,59,-5]) color("red") cylinder(h=20,d=screw5);
			translate([35,59,MountThickness-4]) color("blue") cylinder(h=5,d=screw5hd);
			translate([58,59,-5]) color("green") cylinder(h=20,d=screw5);
			translate([58,59,MountThickness-4]) color("purple") cylinder(h=5,d=screw5hd);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module SwivelMount(AddBump=0,DoTab=1) {
	translate([35,8,MountThickness]) rotate([90,180,0]) {
		difference() {
			translate([0,-1,-5]) color("khaki") cubeX([20,MountThickness+2,30],2);
			translate([-2,-3,-0.25]) color("plum") cubeX([10,MountThickness+6,20.5],2);
			translate([3,3,-10]) color("pink") cylinder(h=50,d=screw3);
			translate([3,3,-8]) color("gray") cylinder(h=10,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
		}
		if(AddBump) translate([9,3,10]) color("green") sphere(3);
		if(DoTab) {
			translate([2,MountThickness,-2]) color("gray") rotate([90,0,0]) cylinder(h=Layer,d=20);
			translate([2,MountThickness,23]) color("lightgray") rotate([90,0,0]) cylinder(h=Layer,d=20);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module MSWebCamMount(DoTab=1) {
	difference() {
		color("cyan") cylinder(h=MountThickness,r=CameraDiameter/2+OuterRingThickness);	// outer
		translate([-25,0,-4]) color("red") cubeX([MountThickness+6,1.5,OuterRingThickness+5],1); // expansion slot
		translate([0,0,-1]) color("gray") cylinder(h=MountThickness+2,r=CameraDiameter/2); // hole
		// notch bottom of gap to prevent bad layers
		translate([-10,-6.4,-3]) rotate([0,0,45]) color("green") cube([10,10,10]);
	}
	translate([22,-12,8.5]) rotate([0,-90,0]) difference() {
		translate([ShiftCamera-4,CameraDiameter/2-12,CameraDiameter/2+OuterRingThickness+19])
			color("darkgray") cubeX([6,20,9],1);
		translate([ShiftCamera-5,CameraDiameter/2-3,CameraDiameter/2+OuterRingThickness+15])
			color("plum") cube([8,2.5,35]); // expansion slot
		translate([ShiftCamera-1,CameraDiameter/2+12,CameraDiameter/2+OuterRingThickness+25]) {
			rotate([90,0,0]) {
				color("white") cylinder(h=30,d=screw3);
				color("plum") cylinder(h=10,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
			}
		}
	}
	SwivelMount(DoTab);
	
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module PICamera2020(AddPI0Mount=0,AddThickness=0,HQ=0) {
	rotate([0,270,0]) Mount2020();
	if(HQ)
		translate([10,0,0]) HQCameraMount();
	else
		translate([10,0,0]) CameraMount();
	if(AddPI0Mount) {
		difference() {
			translate([0,70,6+AddThickness]) rotate([180,0,0]) Extension(1,0,AddThickness);
			translate([35,59,-5]) color("red") cylinder(h=20,d=screw5);
			translate([35,59,MountThickness-4]) color("blue") cylinder(h=5,d=screw5hd);
			translate([58,59,-5]) color("green") cylinder(h=20,d=screw5);
			translate([58,59,MountThickness-4]) color("purple") cylinder(h=5,d=screw5hd);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////

module PICamera2020AllInOne(Mount,AddThickness=0,HQ=0) {
	difference() {
		translate([0,0,6+AddThickness]) rotate([180,0,0]) ExtensionV3(1,0,AddThickness,Mount);
		if(Mount==1) {
			color("red") hull() {
				translate([45,-24,-5]) cylinder(h=20,d=screw5);
				translate([45,-13,-5]) cylinder(h=20,d=screw5);
			}
			color("blue") hull() {
				translate([45,-24,MountThickness-4]) cylinder(h=10,d=screw5hd);
				translate([45,-13,MountThickness-4]) cylinder(h=10,d=screw5hd);
			}
			color("green") hull() {
				translate([68,-24,-5]) cylinder(h=20,d=screw5);
				translate([68,-13,-5]) cylinder(h=20,d=screw5);
			}
			color("purple") hull() {
				translate([68,-24,MountThickness-4]) cylinder(h=10,d=screw5hd);
				translate([68,-13,MountThickness-4]) cylinder(h=10,d=screw5hd);
			}
		}
	}
	if(Mount==2) {
		difference() {
			translate([0,-49,0]) color("purple") cubeX([Length,16,MountThickness],2);
			//translate([58,-36,4]) color("pink") cubeX([25,10,10],2); // clearance for power plug
			color("red") translate([10,-43,-5]) cylinder(h=20,d=screw5);
			color("blue") translate([10,-43,MountThickness-3]) cylinder(h=10,d=screw5hd);
			color("green") translate([Length-10,-43,-5]) cylinder(h=20,d=screw5);
			color("plum") translate([Length-10,-43,MountThickness-3]) cylinder(h=10,d=screw5hd);
		}
	}
	translate([0,-16,0]) difference() {
		color("red") hull() {
			translate([-5,-6,23]) color("red") cubeX([20.5,MountThickness,7],2);
			translate([0,-6,0]) cubeX([15,MountThickness,5],2);
		}
		translate([-10,-2.75,27]) color("darkgray") rotate([0,90,0]) cylinder(h=40,d=screw3);
	}
	if(HQ)
		translate([0,5,0]) HQCameraMount();
	else
		translate([0,5,0]) CameraMount(Yes2mmInsert(Use2mmInsert),1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module Mount2020v2(Tab=1,ExtraHeight=0,DoTab=1) {
	difference() {
		union() {
			color("cyan") cubeX([20+ExtraHeight,25,MountThickness],2);
			//color("plum") cubeX([20+ExtraHeight,MountThickness,25],2);
			if(Tab) translate([0,-6,10]) color("red") rotate([-45,0,0]) cubeX([20,15,MountThickness],2);
		}
		translate([-10,-1.5,9.5]) color("darkgray") rotate([0,90,0]) cylinder(h=40,d=screw3);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module Mount2020(Tab=1,ExtraHeight=0,DoTab=1) {
	difference() {
		union() {
			color("cyan") cubeX([20+ExtraHeight,25,MountThickness],2);
			//color("plum") cubeX([20+ExtraHeight,MountThickness,25],2);
			if(Tab) translate([0,-2,-6]) color("red") rotate([45,0,0]) cubeX([20,12,MountThickness],2);
		}
		translate([-10,-1.5,-1]) color("darkgray") rotate([0,90,0]) cylinder(h=40,d=screw3);
		ScrewMount2020();
	}
	if(DoTab) {
		difference() {
			translate([0,-1,-1]) color("gray") rotate([0,90,0]) cylinder(h=Layer,d=20);
			translate([-10,-1.5,-1]) color("darkgray") rotate([0,90,0]) cylinder(h=40,d=screw3);
		}
		translate([0,23,3]) color("lightgray") rotate([0,90,0]) cylinder(h=Layer,d=20);
		//translate([0,3,23]) color("lightgreen") rotate([0,90,0]) cylinder(h=Layer,d=20);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

module ScrewMount2020(Screw=screw5) {
	translate([10,10+MountThickness,-2]) color("red") cylinder(h=10,d=Screw);
	translate([30,10+MountThickness,-2]) color("blue") cylinder(h=10,d=Screw);
	translate([10,8,10+MountThickness]) color("green") rotate([90,0,0]) cylinder(h=10,d=Screw);
	translate([30,8,10+MountThickness]) color("purple") rotate([90,0,0]) cylinder(h=10,d=Screw);
	if(Screw==screw5) {
		translate([10,10+MountThickness,-MountThickness+1.5]) color("blue") cylinder(h=5,d=screw5hd);
		translate([30,10+MountThickness,-MountThickness+1.5]) color("red") cylinder(h=5,d=screw5hd);
		translate([10,0.5,10+MountThickness]) color("purple") rotate([90,0,0]) cylinder(h=5,d=screw5hd);
		translate([30,0.5,10+MountThickness]) color("green") rotate([90,0,0]) cylinder(h=5,d=screw5hd);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CameraMount(Screw=Yes2mmInsert(Use2mmInsert),AddBump=0) {
	translate([45,0,MountThickness]) rotate([0,180,0]) difference() {
		translate([0,-0.2,0]) color("cyan") cubeX([Width,Width,MountThickness],2); 
		translate([15,18,1]) {
			PICamMountingHoles(Screw);
			translate([-PIChh/2+0.5,-PIChw/2-1,MountThickness-2]) color("red")
				cube([4,PICameraSize,4]); // wide angle pi cam
			translate([-PIChh/2+11.5,-PIChw/2-1,MountThickness-4]) color("blue") cube([7,PICameraSize,4]); // pi cam 1.3
		}
	}
	translate([25,21,-11]) rotate([0,-90,90]) SwivelMount(AddBump,0);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module HQCameraMount(Screw=Yes2mmInsert(Use2mmInsert)) {
	difference() {
		translate([0,-0.2,0]) color("cyan") cubeX([HQCamLength,HQCamWidth,MountThickness],2); 
		translate([15,18,1]) {
			translate([0,-4.0]) PIHQCamMountingHoles(Screw);
			translate([-HQCamLength/2,-HQCamWidth/2,-MountThickness+4]) color("blue") cube([7,PICameraSize,4]); // pi cam 1.3
		}
	}
	translate([13,17,-11]) rotate([0,-90,90]) SwivelMount(0,0);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module PICameraBracket(PI=0) {
		Camera(PI);
		Extension(PI);
		Reinforce(PI);
		Mount(PI);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

module PICameraBracketNoPi(PI=0,PiCam=1) {
	rotate([-90,0,0])  {
		CameraV2(PiCam);
		translate([-1,0,0]) ReinforceV2();
		ExtensionV2();
		MountV2();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////

module CameraHolder(Screw=screw2p5) {
	difference() {
		color("gray") cubeX([PICameraSize,PICameraSize+5,2],1);
		translate([14,14,-4]) PICamMountingHoles(Screw);
		color("white") hull() {
			translate([9,14.5,-3]) cylinder(h=10,d=16);
			translate([15,14.5,-3]) cylinder(h=10,d=16);
		}
		color("green") hull() {
			translate([10,6,-3]) cylinder(h=10,d=8);
			translate([10,23,-3]) cylinder(h=10,d=8);
		}
	}
	difference() {
		translate([3.6,25,5.5]) rotate([180,0,0]) CamSpacers(Screw);
		translate([14,14,-4]) PICamMountingHoles(Screw);
		translate([0,3.75,4]) color("darkgray") cube([20,5,10]);
		translate([0,19,4]) color("white") cube([20,5,10]);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////

module CamSpacers(Screw=screw2) {
	//%translate([0,0,5]) cube([PIChh,PIChw,2]);
	color("red") hull() {
		translate([0,0,0]) cylinder(h=1,d=Screw+1);
		translate([0,0,3.5]) cylinder(h=1,d=Screw+3);
	}
	color("plum") hull() {
		translate([0,PIChw,0]) cylinder(h=1,d=Screw+1);
		translate([0,PIChw,3.5]) cylinder(h=1,d=Screw+3);
	}
	color("white") hull() {
		translate([PIChh,0,0]) cylinder(h=1,d=Screw+1);
		translate([PIChh,0,3.5]) cylinder(h=1,d=Screw+3);
	}
	 color("gray") hull() {
		translate([PIChh,PIChw,0]) cylinder(h=1,d=Screw+1);
		translate([PIChh,PIChw,3.5]) cylinder(h=1,d=Screw+3);
	}
}

////////////////////////////////////////////////////////////////////////

module MSWebCameraBracket(PI=0) {
	MSWebCamera(PI);
	MSClamp(0);
	Extension(PI,0);
	Reinforce(PI);
	Mount(PI);
}

////////////////////////////////////////////////////////////////////////

module MSWebCameraBracketV2(PI=0) {
	translate([0,0,18]) {
		MSWebCameraV2();
		MSClampV2();
	}
	translate([-5,-6,0]) color("khaki") cubeX([OuterRingThickness,Width,25],2);
	ExtensionV2();
	ReinforceV2();
	MountV2();
}

////////////////////////////////////////////////////////////////////////////////

module PIShield(PI=0) {
	if(PI) {
		difference() {
			color("cyan") cubeX([25,16.5,3.5],1);
			translate([13,12.7,0]) rotate([0,0,90]) PICamMountingHoles(screw2);
		}
		difference() {
			translate([23,2.4,0]) PICamSpacers2(screw2);
			//translate([2,1.6,6]) cube([21,13.5,8]); // pi camera 1.3 needs clearance for the stuff on the back
			translate([13,12.7,0])rotate([0,0,90]) PICamMountingHoles(screw2);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

module PIZeroBaseMount(Screw=Yes2p5mmInsert(Use2p5mmInsert),Mount) {
	translate([17,0.5,0]) {
		translate([0,0,0]) color("red") cylinder(h=10,d=Screw);
		translate([0,PIhw,0]) color("plum") cylinder(h=10,d=Screw);
		translate([PIhl,0,0]) color("white") cylinder(h=10,d=Screw);
		translate([PIhl,PIhw,0]) color("gray") cylinder(h=10,d=Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////

module PICamMountingHoles(Screw=Yes2p5mmInsert(Use2p5mmInsert)) {
	translate([-10.5,-10,-2]) {
		translate([0,0,-1]) color("gray") cylinder(h=15,d=Screw);
		translate([0,PIChw,-1]) color("red") cylinder(h=15,d=Screw);
		translate([PIChh,0,-1]) color("plum") cylinder(h=15,d=Screw);
		translate([PIChh,PIChw,-1]) color("white") cylinder(h=15,d=Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////

module PIHQCamMountingHoles(Screw=Yes2p5mmInsert(Use2p5mmInsert)) {
	translate([-10.5,-10,-2]) {
		translate([0,0,-1]) color("gray") cylinder(h=15,d=Screw);
		translate([0,HQCamLength-HQCamHoleOffset*2,-1]) color("red") cylinder(h=15,d=Screw);
		translate([HQCamWidth-HQCamHoleOffset*2,0,-1]) color("plum") cylinder(h=15,d=Screw);
		translate([HQCamWidth-HQCamHoleOffset*2,HQCamLength-HQCamHoleOffset*2,-1]) color("white") cylinder(h=15,d=Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PICamSpacers(Screw=screw2) {
	translate([-10.5,-10,-2]) {
		color("red") hull() {
			translate([0,0,-0.5]) cylinder(h=1,d=Screw+1);
			translate([0,0,2]) cylinder(h=1,d=Screw+3);
		}
		color("plum") hull() {
			translate([0,PIChw,-0.5]) cylinder(h=1,d=Screw+1);
			translate([0,PIChw,2]) cylinder(h=1,d=Screw+3);
		}
		color("white") hull() {
			translate([PIChh,0,-0.5]) cylinder(h=1,d=Screw+1);
			translate([PIChh,0,2]) cylinder(h=1,d=Screw+3);
		}
		 color("gray") hull() {
			translate([PIChh,PIChw,-0.5]) cylinder(h=1,d=Screw+1);
			translate([PIChh,PIChw,2]) cylinder(h=1,d=Screw+3);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PICamSpacers2(Screw=screw2) {
	rotate([0,0,90]) {
		color("red") translate([0,0,0]) cylinder(h=7,d=Screw+3);
		color("plum") translate([0,PIChw,0]) cylinder(h=7,d=Screw+3);
		color("white") translate([PIChh,0,0]) cylinder(h=7,d=Screw+3);
		color("gray") translate([PIChh,PIChw,0]) cylinder(h=7,d=Screw+3);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Camera(PI=0) {
	if(!PI) {
		translate([ShiftCamera,CameraDiameter/2-2.4,CameraDiameter/2+OuterRingThickness]) rotate([0,75,0]) difference() {
			color("cyan") cylinder(h=MountThickness,r=CameraDiameter/2+OuterRingThickness);	// outer
			translate([-25,0,-4]) color("red") cubeX([MountThickness+6,1.5,OuterRingThickness+5],1); // expansion slot
			translate([0,0,-1]) color("gray") cylinder(h=MountThickness+2,r=CameraDiameter/2); // hole
		}
	} else {
		translate([-9,-6,Width-0.5]) rotate([0,75,0]) {
			difference() {
				translate([0,-0.2,0]) color("cyan") cubeX([Width,Width,MountThickness],2); 
				translate([15,18,1]) {
					PICamMountingHoles(Yes2mmInsert(Use2mmInsert));
					translate([-PIChh/2+0.5,-PIChw/2-1,MountThickness-2]) color("red")
						cube([4,PICameraSize,4]); // wide angle pi cam
					translate([-PIChh/2+11.5,-PIChw/2-1,MountThickness-4]) color("blue") cube([6,PICameraSize,4]); // pi cam 1.3
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CameraV2(PI=0) {
	if(!PI) {
		translate([ShiftCamera,CameraDiameter/2-2.4,CameraDiameter/2+OuterRingThickness]) rotate([0,90,0]) difference() {
			color("cyan") cylinder(h=MountThickness,r=CameraDiameter/2+OuterRingThickness);	// outer
			translate([-25,0,-4]) color("red") cubeX([MountThickness+6,1.5,OuterRingThickness+5],1); // expansion slot
			translate([0,0,-1]) color("gray") cylinder(h=MountThickness+2,r=CameraDiameter/2); // hole
		}
	} else {
		difference() {
			translate([-5,-6,0]) color("cyan") cubeX([MountThickness,Width,Width+10],2); 
			translate([-4,12,30]) rotate([0,90,0]) {
				PICamMountingHoles(Yes2mmInsert(Use2mmInsert));
				translate([-PIChh/2+0.5,-PIChw/2-1,MountThickness-2]) color("red")
					cube([4,PICameraSize,4]); // wide angle pi cam
				translate([-PIChh/2+11.5,-PIChw/2-1,MountThickness-4]) color("blue") cube([6,PICameraSize,4]); // pi cam 1.3
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PICameraHole() {
	translate([-14,-14,-2]) color("gray") cube([PICameraSize-2,PICameraSize+4,10]); // hole
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MSWebCamera(PI=0) {
	translate([ShiftCamera,CameraDiameter/2-2.4,CameraDiameter/2+OuterRingThickness]) rotate([0,75,0]) difference() {
		color("cyan") cylinder(h=MountThickness,r=CameraDiameter/2+OuterRingThickness);	// outer
		translate([-25,0,-4]) color("red") cubeX([MountThickness+6,1.5,OuterRingThickness+5],1); // expansion slot
		translate([0,0,-1]) color("gray") cylinder(h=MountThickness+2,r=CameraDiameter/2); // hole
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MSWebCameraV2() {
	translate([ShiftCamera,CameraDiameter/2-2.4,CameraDiameter/2+OuterRingThickness]) rotate([0,90,0]) {
		difference() {
			color("cyan") cylinder(h=MountThickness,r=CameraDiameter/2+OuterRingThickness);	// outer
			translate([-25,0,-4]) color("red") cubeX([MountThickness+6,1.5,OuterRingThickness+5],1); // expansion slot
			translate([0,0,-1]) color("gray") cylinder(h=MountThickness+2,r=CameraDiameter/2); // hole
			//translate([17,-15,-2]) color("lightgray") cube([10,30,10]); // cut off bottom of outer circle
			// notch bottom of gap to prevent bad layers
			translate([-10,-6.4,-3]) rotate([0,0,45]) color("green") cube([10,10,10]);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Extension(PI=0,PiCam=0,AddThickness=0,Mount) {
	difference() {
		translate([0,-Width/6,0]) color("darkgray") cubeX([Length,Width,MountThickness+AddThickness],2);
		if(PiCam) translate([6,2,-2]) color("white") cubeX([3,20,15],1); // hole for camera ribbon cable
		if(PI) {
			PIZeroBaseMount();
			PIZeroClearance();
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtensionV3(PI=0,PiCam=0,AddThickness=0,Mount=1) {
	difference() {
		color("darkgray") cubeX([Length,Width,MountThickness+AddThickness],2);
		//if(PiCam) translate([6,2,-2]) color("white") cubeX([3,20,15],1); // hole for camera ribbon cable
		if(PI) {
			translate([10,6.5,0]) {
				PIZeroBaseMount(Mount);
				PIZeroClearance(Mount);
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtensionV2(PiCam=1) {
	difference() {
		translate([-5,-Width/6,0]) color("darkgray") cubeX([Length-10,Width,MountThickness],2);
		if(PiCam) translate([2,2,-5]) color("white") cubeX([3,20,15],1); // hole for camera ribbon cable
		}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PIZeroClearance(Mount=1) {
	// clearance for the header pins, in either position
	translate([20,19,-MountThickness+1.6]) color("white") cubeX([52,8,MountThickness],2);
	translate([20,-3,-MountThickness+1.6]) color("plum") cubeX([52,8,MountThickness],2);
	translate([66,0,-MountThickness+1.6]) color("green") cubeX([6,23,MountThickness],2);
	translate([20,0,-MountThickness+1.6]) color("lightblue") cubeX([6,23,MountThickness],2);
	if(Mount==1) translate([47,23,-8.4]) color("pink") cubeX([25,10,10],2); // clearance for power plug
	translate([20,-8,-8.4]) color("khaki") cubeX([25,10,10],2); // clearance for power plug
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Mount(PI=0) {
	difference() {
		color("blue") rotate([0,-15,0]) translate([Length-5,-Width/6,-25.8]) cubeX([MountLength+2,Width,MountThickness],2);
		// next is not all the way thru to make support of the bottom of the hole
		color("lightgray") rotate([0,-14,0]) translate([Length+7,Width/3,-(25.8-Layer)]) cylinder(h=MountThickness*2,d=screw5);
		color("green") rotate([0,-14,0]) translate([Length+7,Width/3,-(28.8-Layer)]) cylinder(h=MountThickness*3,d=screw5);
		color("white") rotate([0,-13.5,0]) translate([Length+7,Width/3,-(28.8-Layer)]) cylinder(h=MountThickness,d=screw5hd);
	}
	//Support(PI);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MountV2() {
	translate([-14,0,25.8]) {
		translate([98,0.5,-24]) color("white") cylinder(h=MountThickness*3,screw5); // something to help prevent moving left/right
		translate([98,25.5,-24]) color("lightgray") cylinder(h=MountThickness*3,screw5);
		difference() {
			color("blue") hull() {
				translate([Length-5,-Width/6,-25.8]) cubeX([1,Width,MountThickness],2);
				translate([Length-5+MountLength,Width/9,-25.8]) cubeX([1,Width/2,MountThickness],2);
			}
			color("gray") translate([Length+7,Width/3,-33]) cylinder(h=MountThickness*2.5,d=screw5);
			color("plum") translate([Length+7,Width/3,-31]) cylinder(h=MountThickness,d=screw5hd);
		}
		translate([Length+6,12,-25]) color("darkgray") cylinder(h=Layer,d=screw5hd+1);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Support(PI=0) {
	difference() { // screw hole support
		color("red") rotate([0,-14,0]) translate([Length+7,Width/3,-(27.8-Layer)])
			cylinder(h=MountThickness*1.5,d=screw5+Nozzle*3);
		color("green") rotate([0,-14,0]) translate([Length+7,Width/3,-(28.8-Layer)]) cylinder(h=MountThickness*3,d=screw5);
		color("pink") translate([105,8,-10]) cube([10,10,10]);
	}
	difference() { // mount support
		union() {
			color("plum") translate([Length+MountLength-1.25,-Width/6+0.75,0]) cube([HotendNozzleSize,Width-1.4,MountSupport]);
			color("gold") rotate([0,0,90]) translate([-Width/6+0.75,-(Length+MountLength-0.85),0])
				cube([HotendNozzleSize,Width-16,MountSupport]);
			color("white") rotate([0,0,90]) translate([Width-7.25,-(Length+MountLength-0.85),0])
				cube([HotendNozzleSize,Width-16,MountSupport]);
			color("green") rotate([0,0,90]) translate([Width-25,-(Length+MountLength-0.85),0])
				cube([HotendNozzleSize,Width-16,MountSupport]);
			color("khaki") rotate([0,0,90]) translate([Width-34,-(Length+MountLength-0.85),0])
				cube([HotendNozzleSize,Width-16,MountSupport]);
			color("red") rotate([0,0,90]) translate([Width-16,-(Length+MountLength-0.85),0])
				cube([HotendNozzleSize,Width-16,MountSupport]);
		}
		translate([Length-5,-15,5]) color("red") cube([5,Width+5,5]);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Reinforce(PI=0,Tilt=1) {
	if(Tilt) {
		difference() {
			translate([0,-5,0]) rotate([6,0,0]) color("yellow") cubeX([20,4,20],1);
			translate([5,-7,20]) rotate([6,50,0]) color("pink") cube([25,6,25]);
		}
		difference() {
			translate([0,25,1]) rotate([-6,0,0]) color("red") cubeX([20,4,20],1);
			translate([5,25,21]) rotate([-6,50,0]) color("blue") cube([25,6,25]);
		}
	} else {
		difference() {
			translate([-16,-6,10]) rotate([0,45,0]) color("yellow") cubeX([30,4,20],1);
			translate([-7,-7,-22]) rotate([0,0,0]) color("pink") cube([35,6,25]);
			translate([-17,-7,-2]) rotate([0,-15,0]) color("gray") cube([20,6,25]);
		}
		difference() {
			translate([-16,26.8,10]) rotate([0,45,0]) color("red") cubeX([30,4,20],1);
			translate([-7,26,-22]) rotate([0,0,0]) color("blue") cube([35,6,25]);
			translate([-17,26,-2]) rotate([0,-15,0]) color("lightgray") cube([20,6,25]);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ReinforceV2() {
		difference() {
			translate([-2.5,-5.8,16]) rotate([0,45,0]) color("yellow") cubeX([30,4,5],1);
			translate([-7,-7,-22]) rotate([0,0,0]) color("pink") cube([35,6,25]);
		}
		difference() {
			translate([-2.5,26.5,16]) rotate([0,45,0]) color("red") cubeX([30,4,5],1);
			translate([-7,26,-22]) rotate([0,0,0]) color("blue") cube([35,6,25]);
		}
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MSClamp(PI=0) {
	if(!PI) {
		difference() {
			translate([ShiftCamera-4,CameraDiameter/2-12,CameraDiameter/2+OuterRingThickness+19]) rotate([0,-15,0])
				color("darkgray") cubeX([6,20,9],1);
			translate([ShiftCamera-5,CameraDiameter/2-2.5,CameraDiameter/2+OuterRingThickness+15]) rotate([0,-15,0])
				color("plum") cube([8,1.5,35]); // expansion slot
			translate([ShiftCamera-3.5,CameraDiameter/2+12,CameraDiameter/2+OuterRingThickness+25]) {
				rotate([90,0,0]) {
					color("white") cylinder(h=14,d=screw3);
					color("plum") cylinder(h=10,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
				}
			}
		
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MSClampV2() {
	difference() {
		translate([ShiftCamera,CameraDiameter/2-12,CameraDiameter/2+OuterRingThickness+19])
			color("darkgray") cubeX([6,20,9],1);
		translate([ShiftCamera-1,CameraDiameter/2.5,CameraDiameter/2+OuterRingThickness+15])
			color("plum") cube([8,2.5,35]); // expansion slot
		translate([ShiftCamera+3,CameraDiameter/2-1.5,CameraDiameter/2+OuterRingThickness+25]) {
			rotate([0,90,90]) {
				color("white") cylinder(h=14,d=screw3);
		 		translate([0,0,-15]) color("plum") cylinder(h=15,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////