//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// XBeltEnds.scad - x axis bearing mount on the carriage plates
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 6/27/2016
// last upate 1/22/22
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 7/3/16	- added comments and some assembly info
// 7/17/16	- swtiched to inside of carriage plate, added partial()
// 7/22/16	- added belt_adjust for adjusting the bearings on the XBeltEnds
// 1/10/17	- added labels and colors to preview for easier editing
// 8/19/18	- OpenSCAD 2018.06.01 for $preview
// 10/17/20	- Now can use 5mm inserts
// 1/16/22	- Added a endstop strike to left side, added locating tab to drill guide
// 1/20/22	- Renamed vars to a better description
// 1/22/22	- XBeltEnds now use brass inserts to mount on makkerslide carriage plate
///////////////////////////////////////////////////////////////////////////////////////
// Requires drilling two holes in the makerslide carriage plate
// Use a couple of 3mm screws to space the XBeltEnds above the makerslide, mark the outline
// of the XBeltEnds on the plate, align the drill guide with the marking and drill the 5mm holes
// -----------------------------------------------------------------------------------------------------------------------
// On left side upper bearing set to rear, lower bearing set to front, stepper motor gear to match upper
// On right side lower bearing set to rear, upper bearing set to front, stepper motor gear to match lower
// -----------------------------------------------------------------------------------------------------------------
// Uses 8 F625Z bearings, 8 5mm washers, 4 5x40mm screws
// Bearing stack is one washer, two bearings flanges out, one washer and one spacer
// U - bearings on upper, D - bearings on lower, removed unecessary code
//-------------------------------------------------------------------------------------------------------------------
// Left is X min, Right is X max
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
use <bosl2/std.scad> // https://github.com/revarbat/BOSL2
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$fn = 100;
Width = 38;						// width of the bracket
F625ZDiameter = 16;				// diameter of bearing where the belt rides
OuterBeltHeight = 26;			// how far out from the carriage plate the inner belt is on the sides
InnerBeltHeight = 17;			// how far out from the carriage plate the outer belt is on the sides
BeltHeight = OuterBeltHeight+2; // height of walls
BeltOffset = 2.5;				// adjust distance between inner & outer belts bearings
InnerBeltAdjust = -2;			// adjust inner belt bearing postion (- closer to plate, + farther away)
OuterBeltAdjust = 2;			// adjust outer belt bearing postion (- closer to plate, + farther away)
OneBearingStackHeight = 11.78;	// just the hieght of two washers & two F625Z bearings
Use5mmInsert=1;
LayerThickness=0.3;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

All(1,1); // everything
//XBeltEnds(0);
//translate([0,60,0])
//	XBeltEnds(1);
//DrillGuide(screw5);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module All(Spacers=0,Guide=0) {	// all the parts as a plate
	//if($preview) %translate([0,0,-5]) cube([200,200,2],center=true); // show the 200x200 bed
	rotate([0,90,0]) {
		XBeltEnds(0);
		translate([0,-45,0]) XBeltEnds(1);
	}
	if(Spacers) translate([-15,-30,-32.1]) BearingSpacer(OneBearingStackHeight,4);
	if(Guide) translate([57,-33,-38]) DrillGuide();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XBeltEnds(RightSide=0) {	// bearing mount bracket on x axis
	Base(Yes5mmInsert(Use5mmInsert));
	XEndWalls(0,0,RightSide);
	XEndWalls(1,1,RightSide);
	if(!RightSide) {
		translate([10,10,3]) printchar("Left",3,5);
		translate([12,31.5,11]) rotate([90,0,180]) printchar("D",3,5);
		translate([25,34.5,25]) rotate([90,0,0]) printchar("U",3,5);
	} else {
		translate([7,10,3]) printchar("Right",3,5);
		translate([13,34.5,28]) rotate([90,180,0]) printchar("D",3,5);
		translate([25,34.5,11]) rotate([90,0,0]) printchar("U",3,5);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module XEndWalls(Bottom=0,NotDoEndStop=0,Right=0) {	// the walls that hold the bearings
	if(Bottom) {
		if(Right) {
			difference() {	// Lower bearing support wall
				color("red") cuboid([Width,5,BeltHeight+F625ZDiameter],rounding=2,p1=[0,0]);
				BearingScrewHoles(Bottom,Yes5mmInsert(Use5mmInsert));
			}
		} else {
			difference() {	// Lower bearing support wall
				color("red") cuboid([Width,5,BeltHeight+F625ZDiameter],rounding=2,p1=[0,0]);
				BearingScrewHoles(!Bottom,Yes5mmInsert(Use5mmInsert));
			}
		}
	} else {
		if(Right) {
			difference() {	// Top bearing support wall
				translate([0,OneBearingStackHeight*2+5,0]) color("blue")
					cuboid([Width,5,BeltHeight+F625ZDiameter],rounding=2,p1=[0,0]);
				BearingScrewHoles(!Bottom,screw5);
				translate([Width-F625ZDiameter/2-BeltOffset,37,InnerBeltHeight+F625ZDiameter/2+InnerBeltAdjust])
					rotate([90,0,0]) color("gray")cylinder(h=5,d=screw5hd);
				translate([F625ZDiameter/2+BeltOffset,37,OuterBeltHeight+F625ZDiameter/2+OuterBeltAdjust]) rotate([90,0,0])
					color("yellow")cylinder(h=5,d=screw5hd);
			}
		} else {
			difference() {	// Top bearing support wall
				translate([0,OneBearingStackHeight*2+5,0]) color("blue")
					cuboid([Width,5,BeltHeight+F625ZDiameter],rounding=2,p1=[0,0]);
				BearingScrewHoles(Bottom,screw5);
			}
			if(!NotDoEndStop) {
				difference() {
					union() {
						translate([19,36.5,BeltHeight+F625ZDiameter-1]) color("green")
							cuboid([Width,15,5],rounding=2);  // X endstop strike riser
						translate([19,45,BeltHeight+F625ZDiameter+5.5]) color("pink")
							cuboid([Width,10,18],rounding=2);  // X endstop strike
					}
					translate([F625ZDiameter/2+BeltOffset+17,45,OuterBeltHeight+F625ZDiameter/2+OuterBeltAdjust])
						rotate([90,0,0]) color("purple")cylinder(h=15,d=screw5hd);
				}
			}
		}
	}
	translate([BeltHeight+F625ZDiameter-6.15,2,2]) rotate([0,90,0]) color("green") cyl(h=LayerThickness,d=15);
	translate([BeltHeight+F625ZDiameter-6.15,Width-7,2]) rotate([0,90,0]) color("purple") cyl(h=LayerThickness,d=15);
	translate([BeltHeight+F625ZDiameter-6.15,2,42]) rotate([0,90,0]) color("white") cyl(h=LayerThickness,d=15);
	translate([BeltHeight+F625ZDiameter-6.15,Width-7,42]) rotate([0,90,0]) color("lightgray") cyl(h=LayerThickness,d=15);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingScrewHoles(Bottom,Screw=screw5) {
	if(Bottom) { // Top farther, Lower closer
		translate([Width-F625ZDiameter/2-BeltOffset,50,InnerBeltHeight+F625ZDiameter/2+InnerBeltAdjust]) rotate([90,0,0])
			color("red") cylinder(h=60,d=Screw);
		translate([F625ZDiameter/2+BeltOffset,50,OuterBeltHeight+F625ZDiameter/2+OuterBeltAdjust]) rotate([90,0,0])
			color("white") cylinder(h=60,d=Screw);
	} else { // Top closer, Lower farther
		translate([Width-F625ZDiameter/2-BeltOffset,50,OuterBeltHeight+F625ZDiameter/2+OuterBeltAdjust]) rotate([90,0,0])
			color("yellow")cylinder(h=60,d=Screw);
		translate([F625ZDiameter/2+BeltOffset,50,InnerBeltHeight+F625ZDiameter/2+InnerBeltAdjust]) rotate([90,0,0])
			color("gray")cylinder(h=60,d=Screw);
		translate([Width-F625ZDiameter/2-BeltOffset,37,OuterBeltHeight+F625ZDiameter/2+OuterBeltAdjust]) rotate([90,0,0])
			color("gray")cylinder(h=5,d=screw5hd);
		translate([F625ZDiameter/2+BeltOffset,37,InnerBeltHeight+F625ZDiameter/2+InnerBeltAdjust]) rotate([90,0,0])
			color("yellow")cylinder(h=5,d=screw5hd);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BearingSpacer(length=OneBearingStackHeight,Quanity=2) {
	for(x=[0:Quanity-1]) {
		translate([0,x*15,0]) difference() {
			color("pink") cyl(h=length,r=screw5,rounding=1);
			color("cyan") cyl(h=length+5,d=screw5);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Base(Screw=screw5) {
	difference() {
		color("cyan") cuboid([Width,OneBearingStackHeight*2+10,5],rounding=2,p1=[0,0]);
		translate([Width/4-1,22,-1]) color("salmon") cylinder(h=10,d=Screw);	// mounting screw holes
		translate([Width-Width/4+1,12,-1]) color("green") cylinder(h=10,d=Screw);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DrillGuide(Screw=screw5) { // something to help in locating the holes to drill in the makerslide carriage plate
	difference() {
		Base(Screw);
		translate([3,2.7,3]) printchar("Drill Guide",3,5);
	}
	translate([19,43,2.5]) color("red") cuboid([Width,33,5],rounding=2); // addon to base
	translate([19,14.5+43,5]) color("blue") cuboid([Width,5,10],rounding=2); // lip
	translate([2,2,0.15]) color("green") cyl(h=LayerThickness,d=15);
	translate([2,Width+20,0.15]) color("purple") cyl(h=LayerThickness,d=15);
	translate([Width-2,2,0.15]) color("white") cyl(h=LayerThickness,d=15);
	translate([Width-2,Width+20,0.15]) color("gray") cyl(h=LayerThickness,d=15);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=2,Color="coral") { // print text
	color(Color) linear_extrude(height = Height) text(String, font = "Liberation Sans",size=Size);
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
