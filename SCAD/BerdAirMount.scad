/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BeraAirMount.scad
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// C:4/8/21
// U:5/1/22
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 4/8/21	- BerdAirMount on the extruder on EXOSlide
// 9/14/21	- Added a mount to go on teh top of a E3DV6 heatsink: E3DV6Mount()
// 10/5/21	- Added mount for titan and titan aero
// 5/1/22	- Add an Y hose connector
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <BOSL2/std.scad>
include <inc/brassinserts.scad>
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn=100;
Use3mmInsert=1;
LargeInsert=1;
LayerThickness=0.3;
Clearance=0.9;
E3DV6diameter=16+Clearance; // diameter of section right above heat sink
StepperHoleOffset=31;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//BerdAirMountLeft(35,2,0); // side with heater block, exoslide
//BerdAirMountRight(13,2,0); // side without heater block, exoslide
//E3DV6Mount(2,1,0);  // mount on the top section of the heatsink
//BerdAirTitan(0,1,1,2);
YHoseConnector();

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YHoseConnector() {
	translate([0,0,1]) BottomHose();
	RightHose();
	LeftHose();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module 	BottomHose() {
	rotate([0,0,0]) difference() {
		color("cyan") cyl(h=10,d=3,rounding1=1);
		color("green") cyl(h=15,d=2);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module LeftHose() {
	translate([-2,0,12.5]) {
		difference() {
			rotate([0,-17,0]) difference() {
				color("khaki") cyl(h=15,d=3,rounding2=1);
				color("blue") cyl(h=20,d=2);
			}
			translate([3,0,-10]) HoseInner(17,6);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RightHose() {
	translate([2,0,12.5]) {
		difference() {
			rotate([0,17,0]) difference() {
				color("purple") cyl(h=15,d=3,rounding2=1);
				color("blue") cyl(h=20,d=2);
			}
			translate([-3,0,-10]) HoseInner(-17,6);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////


module HoseInner(Angle=17,Height=3) {
	translate([0,0,6]) rotate([0,Angle,0]) color("green") cyl(h=Height,d=2);
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirTitan(Side=0,DoClamp=1,DoTab=1,PipeSize=2) { // Side: 1=Right 
	if(Side) {
		difference() {
			translate([0,-4.5,0]) color("cyan") cuboid([40,25,4],rounding=2,p1=[0,0]);
			translate([4.5,17,-3]) {
				color("blue") cylinder(h=10,d=screw3);
				translate([StepperHoleOffset,-6,0]) color("red") cylinder(h=10,d=screw3);
			}
			translate([25,10,4]) BerdAirClampHoles();
			union() {
				translate([9,4,-3]) color("gray") cuboid([15,20,10],rounding=2,p1=[0,0]);
				//translate([25,0.5,-3]) color("lightgray") rotate([0,0,45]) cuboid([9,10,10],rounding=2,p1=[0,0]);
				translate([22,3.2,-3]) color("green") rotate([0,0,45]) cuboid([30,15,10],rounding=2,p1=[0,0]);
			}
		}
		difference() {
			translate([20,-6,0]) color("khaki") cuboid([10,10,16],rounding=2,p1=[0,0]);
			translate([25,6,4]) BerdAirClampHoles();
		}
		if(DoTab) difference() {
			union() {
				translate([4,16,0]) color("purple") cylinder(h=LayerThickness,d=20);
				translate([39,16,0]) color("gray") cylinder(h=LayerThickness,d=20);
			}
			translate([4.5,17,-3]) {
				color("blue") cylinder(h=10,d=screw3);
				translate([StepperHoleOffset,-6,0]) color("red") cylinder(h=10,d=screw3);
			}
		}
	} else {
		difference() {
			translate([0,-4.5,0]) color("cyan") cuboid([45,20,4],rounding=2,p1=[0,0]);
			translate([9.5,12,-3]) {
				color("blue") cylinder(h=10,d=screw3);
				translate([StepperHoleOffset,0,0]) color("red") cylinder(h=10,d=screw3);
			}
			translate([25,6,-8]) BerdAirClampHoles();
			union() {
				translate([13,4,-3]) color("gray") cuboid([15,15,10],rounding=2,p1=[0,0]);
				translate([21,0.5,-3]) color("lightgray") rotate([0,0,45]) cuboid([10,10,10],rounding=2,p1=[0,0]);
				translate([26,3.2,-3]) color("green") rotate([0,0,45]) cuboid([20,10,10],rounding=2,p1=[0,0]);
			}
		}
		difference() {
			translate([20,-6,-12]) color("khaki") cuboid([10,10,16],rounding=2,p1=[0,0]);
			translate([21,0.5,-6]) color("lightgray") rotate([0,0,45]) cuboid([10,10,30],rounding=2,p1=[0,0]);
			translate([25,6,-8]) BerdAirClampHoles();
		}
		if(DoTab) difference() {
			union() {
				translate([3,6,4-LayerThickness]) color("purple") cylinder(h=LayerThickness,d=20);
				translate([42,6,4-LayerThickness]) color("gray") cylinder(h=LayerThickness,d=20);
				//translate([25,-5.5,4-LayerThickness]) color("blue") cylinder(h=LayerThickness,d=10);
			}
			translate([9.5,12,-3]) {
				color("blue") cylinder(h=10,d=screw3);
				translate([StepperHoleOffset,0,0]) color("red") cylinder(h=10,d=screw3);
			}
		}
	}
	if(DoClamp)
		if(Side) translate([0,-21,0]) AeroClamp(Side=0,DoTab,PipeSize);
		else translate([0,-30,4]) rotate([180,0,0]) AeroClamp(Side=0,DoTab,PipeSize);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirClampHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) {
	color("pink") rotate([90,0,0]) cylinder(h=15,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
	translate([0,0,8]) color("plum") rotate([90,0,0]) cylinder(h=15,d=Yes3mmInsert(Use3mmInsert,LargeInsert));
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module AeroClamp(Side=0,DoTab=1,PipeSize=2) {
	rotate([90,0,0]) difference() {
		translate([20,0,0]) color("khaki") cuboid([10,4,16],rounding=2,p1=[0,0]);
		if(Side) translate([15,4,8]) color("blue") rotate([0,90,0]) cylinder(h=20,d=PipeSize);
		else  translate([15,-5,8]) color("blue") rotate([0,90,0]) cylinder(h=20,d=PipeSize);
			translate([25,7,4]) {
			color("pink") rotate([90,0,0]) cylinder(h=10,d=screw3);
			translate([0,0,8]) color("plum") rotate([90,0,0]) cylinder(h=10,d=screw3);
		}
	}
	difference() {
		if(Side) translate([25,-8,0]) color("white") cylinder(h=LayerThickness,d=30);
		else translate([25,-8,-1.6+LayerThickness]) color("white") cylinder(h=LayerThickness,d=30);
		translate([25,-4,-4]) {
			color("pink") rotate([0,0,0]) cylinder(h=10,d=screw3);
			translate([0,-8,0]) color("plum") rotate([0,0,0]) cylinder(h=10,d=screw3);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module E3DV6Mount(PipeSize=2,DoClamp=1,SetScrew=0,DoTab=1) {
	difference() {
		union() {
			color("cyan") hull() {
				translate([0,0,2-0.3]) cyl(h=3.5,d=E3DV6diameter*2-3,rounding=1.5);
				translate([-30,-E3DV6diameter/2,0]) cuboid([3,E3DV6diameter,4],rounding=1.5,p1=[0,0]);
			}
			translate([-22.5,0.25,4]) color("blue") cuboid([15,E3DV6diameter,8],rounding=1);
		}
		translate([-56,0,4.25]) BAClampScrews(Yes3mmInsert(Use3mmInsert,LargeInsert));
		translate([0,0,-5]) color("red") cylinder(h=20,d=E3DV6diameter);
		if(SetScrew) translate([0,0,2]) color("purple") rotate([0,90,0]) cylinder(h=20,d=screw3t);
	}
	if(DoClamp) BAClamp(PipeSize,DoTab);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BAClamp(PipeSize=2,DoTab=1) {
	translate([-39,0,32]) rotate([0,-90,0]) { // remove to test fit
		difference() { // clamp
			union() {
				translate([-32,-E3DV6diameter/2,0]) color("green") cuboid([5,E3DV6diameter,8],rounding=1,p1=[0,0]);
				if(DoTab) translate([-32,0,4]) color("red")  rotate([0,90,0]) cylinder(h=LayerThickness,d=25);
			}
			translate([-43,0,4.25]) BAClampScrews(screw3);
			translate([-27,0,-5]) color("gray") cylinder(h=20,d=PipeSize);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BAClampScrews(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert)) {
	translate([0,-4,0]) color("blue") rotate([0,90,0]) cylinder(h=40,d=Screw);
	translate([0,4,0]) color("khaki") rotate([0,90,0]) cylinder(h=40,d=Screw);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirMountLeft(Offset=35,PipeSize=2,Fit) { // side with heater block
	difference() {
		union() {
			color("cyan") cuboid([spacing+10,wall,wall],rounding=2,p1=[0,0],except_edges=BOTTOM);
			translate([8,0,0]) color("red") cuboid([wall+4,wall,Offset],rounding=2,p1=[0,0],except_edges=BOTTOM+TOP);
			translate([0,0,Offset-wall]) color("white")
				cuboid([spacing+10,wall*2,wall],rounding=2,p1=[0,0],except_edges=TOP);
		}
		translate([5,wall,Offset+5]) rotate([90,0,0]) IRMountHoles();
		translate([5,wall/2,10]) rotate([90,0,0]) IRMountHoles(screw3);
		translate([5,wall/2,17]) rotate([90,0,0]) IRMountHoles(screw3hd,10);
	}
	if(Fit) Cap(PipeSize,Offset);
	else translate([0,40,Offset+2]) rotate([90,0,0]) Cap(PipeSize,Offset);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BerdAirMountRight(Offset=13,PipeSize=2,Fit) { // side without heater block
	difference() {
		union() {
			color("cyan") cuboid([spacing+10,wall,wall+1],rounding=2,p1=[0,0],except_edges=BOTTOM);
			translate([8,0,0]) color("red") cuboid([wall+4,wall,Offset],rounding=2,p1=[0,0],except_edges=BOTTOM+TOP);
			translate([0,0,Offset-wall]) color("white")
				cuboid([spacing+10,wall*2,wall],rounding=2,p1=[0,0],except_edges=TOP);
		}
		translate([5,wall,Offset+5]) rotate([90,0,0]) IRMountHoles();
		translate([5,wall/2-2,10]) rotate([90,0,0]) IRMountHoles(screw3);
		translate([5,wall/2-2,17]) rotate([90,0,0]) IRMountHoles(screw3hd,10);
		translate([(spacing+10)/2,-3,9]) rotate([-45,0,0]) cylinder(h=10,d=PipeSize+5);
	}
	if(Fit) Cap(PipeSize,Offset);
	else translate([0,18,Offset+2]) rotate([90,0,0]) Cap(PipeSize,Offset);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Cap(PipeSize,Offset,Test=0) {
	difference() {
		translate([0,0,Offset]) color("plum") cuboid([spacing+10,wall*2,5],rounding=2,p1=[0,0],except_edges=BOTTOM);
		translate([(spacing+10)/2,wall*3-5,Offset+0.75]) color("green") hull() {
			rotate([90,0,0]) cylinder(h=wall*3,d=PipeSize);
			translate([0,0,-3]) rotate([90,0,0]) cylinder(h=wall*3,d=PipeSize);
		}
		translate([5,wall,Offset+15]) rotate([90,0,0]) IRMountHoles(screw3);
		translate([5,wall,Offset+24]) rotate([90,0,0]) IRMountHoles(screw3hd);
	}
	translate([5,wall,Offset+3.7]) color("black") cylinder(h=LayerThickness,d=screw3hd);
	translate([5+spacing,wall,Offset+3.7]) color("white") cylinder(h=LayerThickness,d=screw3hd);
	if(Test) translate([(spacing+10)/2,wall*3-5,Offset+0.75]) rotate([90,0,0]) color("purple") cylinder(h=wall*3,d=PipeSize);

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module IRMountHoles(Screw=Yes3mmInsert(Use3mmInsert,LargeInsert),Length=20) // ir screw holes for mounting to extruder plate
{
	translate([spacing,0,0]) rotate([90,0,0]) color("blue") cylinder(h=Length,d=Screw);
	translate([0,0,0]) rotate([90,0,0]) color("red") cylinder(h=Length,d=Screw);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////