///////////////////////////////////////////////////////////////////////
// WebCam-Mount.scad - lifecam holder and a PI Zero & Cam holder
///////////////////////////////////////////////////////////////////////
// created 1/31/16
// last update 8/29/20
////////////////////////////////////////////////////////////////////////
// ABS or something that can handle the heatbed temperature
/////////////////////////////////////////////////////////////////////////
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
/////////////////////////////////////////////////////////////////////////
// https://www.raspberrypi.org/documentation/hardware/raspberrypi/mechanical/README.md
// https://www.raspberrypi-spy.co.uk/2013/05/pi-camera-module-mechanical-dimensions
// For the PI Zero, I use https://elinux.org/RPi-Cam-Web-Interface
// for the pi zero cover: https://www.thingiverse.com/thing:2165844, I used the RPI_Zero_W_Case_-_Top_-_Heatsink.stl
// Uses four M2 to mount the PI Zero and four M2 to mount the PI Camera
// Web cam software I use: https://elinux.org/RPi-Cam-Web-Interface
/////////////////////////////////////////////////////////////////////////
// ** NOTE: May need a raft for the built in support for the camera bracket
/////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
use <inc/cubeX.scad>
include <brassfunctions.scad>
// vars
///////////////////////////////////////////////////////////////////////
$fn=100;
CameraDiameter = 29;	// outside diameter of usb camera
Length = 100;			// distance needed from bed to see the entire bed
OuterRingThickness = 8;	// thickness of ring to hold camera
Width = CameraDiameter + OuterRingThickness;	// width of the ring to hold camera
MountThickness = 6;		// thickness of extension and mount
ShiftCamera = -4.5;		// amount to move camera ring to end of extension
MountLength = 20;		// length of the mount
HotendNozzleSize = 0.4;	// nozzle size for print support for mount end
MountSupport = 6;		// height of print support for mount end
//----
PIhw=30-3.5-3.5;		// pi zero w vertical screw hole width
PIhl=58;				// pi zero w horizontal screw hole width
PIChw=21;				// cam screw hole horizontal distance
PIChh=12.8; 			// cam screw hole vertical distance (my camera is a bit longer)
PICameraSize=24;		// smaller dimension of the camera circuit board
Nozzle=0.4;				// nozzle size
Layer=0.3;				// layer thickness
////////////////////////////////////////////////////////////////////////

rotate([-90,0,0]) PICameraBracket(1);
translate([18,10,-30.8]) CameraHolder();
//WebCameraBracket(1); // must use support

////////////////////////////////////////////////////////////////////////////////////////////////////

module PICameraBracket(PI=0) {
		Camera(PI);
		Clamp(PI);
		Extension(PI,1);
		Reinforce(PI,0);
		Mount(PI);
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
		translate([0,3.75,4]) color("black") cube([20,5,10]);
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

module WebCameraBracket(PI=0) {
	WebCamera(PI);
	Clamp(0);
	Extension(PI,0);
	Reinforce(PI);
	Mount(PI);
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

module PIZeroBaseMount(Screw=Yes2p5mmInsert()) {
	translate([17,0.5,0]) {
		translate([0,0,0]) color("red") cylinder(h=10,d=Screw);
		translate([0,PIhw,0]) color("plum") cylinder(h=10,d=Screw);
		translate([PIhl,0,0]) color("white") cylinder(h=10,d=Screw);
		translate([PIhl,PIhw,0]) color("gray") cylinder(h=10,d=Screw);
	}
}

////////////////////////////////////////////////////////////////////////////////////////

module PICamMountingHoles(Screw=Yes2p5mmInsert()) {
	translate([-10.5,-10,-2]) {
		translate([0,0,-1]) color("gray") cylinder(h=15,d=Screw);
		translate([0,PIChw,-1]) color("red") cylinder(h=15,d=Screw);
		translate([PIChh,0,-1]) color("plum") cylinder(h=15,d=Screw);
		translate([PIChh,PIChw,-1]) color("white") cylinder(h=15,d=Screw);
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
					PICamMountingHoles(Yes2p5mmInsert());
					translate([-PIChh/2+0.5,-PIChw/2-1,MountThickness-2]) color("red") cube([4,PICameraSize,4]); // wide angle pi cam
					translate([-PIChh/2+11.5,-PIChw/2-1,MountThickness-2]) color("blue") cube([6,PICameraSize,4]); // pi cam 1.3
				}
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PICameraHole() {
	translate([-14,-14,-2]) color("gray") cube([PICameraSize-2,PICameraSize+4,10]); // hole
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module WebCamera(PI=0) {
	translate([ShiftCamera,CameraDiameter/2-2.4,CameraDiameter/2+OuterRingThickness]) rotate([0,75,0]) difference() {
		color("cyan") cylinder(h=MountThickness,r=CameraDiameter/2+OuterRingThickness);	// outer
		translate([-25,0,-4]) color("red") cubeX([MountThickness+6,1.5,OuterRingThickness+5],1); // expansion slot
		translate([0,0,-1]) color("gray") cylinder(h=MountThickness+2,r=CameraDiameter/2); // hole
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Extension(PI=0,PiCam=0) {
	difference() {
		translate([0,-Width/6,0]) color("black") cubeX([Length,Width,MountThickness],1);
		if(PiCam) translate([6,2,-2]) color("white") cubeX([3,20,15],1); // hole for camera ribbon cable
		if(PI) {
			PIZeroBaseMount();
			PIZeroHeaderClearance();
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PIZeroHeaderClearance() {
	// clearance for the header pins
	translate([20,19,-MountThickness+1.6]) color("white") cubeX([52,8,MountThickness],2);
	translate([20,-3,-MountThickness+1.6]) color("plum") cubeX([52,8,MountThickness],2);
	translate([66,0,-MountThickness+1.6]) color("green") cubeX([6,23,MountThickness],2);
	translate([20,0,-MountThickness+1.6]) color("lightblue") cubeX([6,23,MountThickness],2);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Mount(PI=0) {
	difference() {
		color("blue") rotate([0,-15,0]) translate([Length-5,-Width/6,-25.8]) cubeX([MountLength+2,Width,MountThickness],1);
		// next is not all the way thru to make support of the bottom of the hole
		color("lightgray") rotate([0,-14,0]) translate([Length+7,Width/3,-(25.8-Layer)]) cylinder(h=MountThickness*2,d=screw5);
		color("green") rotate([0,-14,0]) translate([Length+7,Width/3,-(28.8-Layer)]) cylinder(h=MountThickness*3,d=screw5);
		color("white") rotate([0,-13.5,0]) translate([Length+7,Width/3,-(28.8-Layer)]) cylinder(h=MountThickness,d=screw5hd);
	}
	//Support(PI);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Support(PI=0) {
	difference() { // screw hole support
		color("red") rotate([0,-14,0]) translate([Length+7,Width/3,-(27.8-Layer)]) cylinder(h=MountThickness*1.5,d=screw5+Nozzle*3);
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Clamp(PI=0) {
	if(!PI) {
		difference() {
			translate([ShiftCamera-4,CameraDiameter/2-12,CameraDiameter/2+OuterRingThickness+16]) rotate([0,-15,0]) color("black")
				cubeX([6,20,15],1);
			translate([ShiftCamera-5,CameraDiameter/2-2.5,CameraDiameter/2+OuterRingThickness+15]) rotate([0,-15,0]) color("plum")
				cube([8,1.5,35]); // expansion slot
			translate([ShiftCamera-3.5,CameraDiameter/2+12,CameraDiameter/2+OuterRingThickness+25]) rotate([90,0,0]) color("white")
				cylinder(h=30,d=screw3,$fn=100);
		}
	}
}

///////////// end of lifecam.scad //////////////////////////////////////