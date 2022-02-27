////////////////////////////////////////////////////////////////////////////////////
// Endstops.scad - endstop holder for makerslide
////////////////////////////////////////////////////////////////////////////////////
// created: 5/10/2016
// last update: 1/18/22
////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 6/29/16	- Adjusted mounting holes for use on the double slot side of makerslide
// 7/3/16	- Added arg for amount to move from edge to thing() & base()
//			 Made spacer plate a bit shorter to fit on corexy belt holder
//           Added spacerY(), adjustable stop for the y endstop to hit
// 7/17/17	- Added strikeX(), adjustable stop for the x endstop to hit
// 12/17/18	- Added colors for preview
// 2/26/19	- Added ability to change mounting screw sizes (M5/M4/M3)
// 8/8/20	- Simplified the x endstop
// 9/27/20	- Change mounts onto belt attachment to M4 or M5, and slotted, so you don't have to be perfect with the inserts
// 10/31/20	- Added missing y endstop holder
// 5/4/21	- Adjusted y endstop size, BOSL2 conversion
// 5/6/21	- Adjusted x endstop size
// 9/25/21	- Added wider x stop strike for exoslide
// 10/31/21	- Made X endstop long enough to get past x-carriage belt holder
// 1/18/22	- Renamed stuff, commented out StrikeX() in All(), since it's now on the X belt end
////////////////////////////////////////////////////////////////////////////////////
include <inc/screwsizes.scad>
include <bosl2/std.scad>
include <inc/brassinserts.scad>
$fn=75;
////////////////////////////////////////////////////////////////////////////////////
// vars
Use2mmInsert=1;
Use2p5Insert=1;
Use3mmInsert=1;
Use4mmInsert=1;
Use5mmInsert=1;
LargeInsert=1;
Switch_ht=20;//15;		// height of holder
Switch_thk = 5;			// thickness of holder
Switch_thk2 = 6;		// thickness of spacer
HolderWidth = 33;	// width of holder
SwitchShift = 6;	// move switch mounting holes along width
LayerThickness=0.3;
////////////////////////////////////////////////////////////////////////////

//All(1,1,1);
//XStopMount(22,10,8,Yes3mmInsert(Use3mmInsert,LargeInsert),screw5,8);	// TEMCo CN0097
//XStopMount(10,0,0,Yes2mmInsert(Use2mmInsert),screw5,4); // black microswitch
//YStopMount(22,10,8,Yes3mmInsert(Use3mmInsert,LargeInsert),screw4,8);	// TEMCo CN0097
//StopMount(10,0,0,Yes2mmInsert(Use2mmInsert),Yes5mmInsert(Use5mmInsert),4); // black microswitch
YStopMountMS(10,0,0,Yes2mmInsert(Use2mmInsert),Yes5mmInsert(Use5mmInsert),4); // black microswitch
//StrikeY(screw5);
//StrikeX(screw5,0); // second arg: 1 for exoslide

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module All(BlackX=0,BlackY=0,EXOSlide=0) {
	if(BlackX) XStopMount(10,0,0,Yes2mmInsert(Use2mmInsert),screw5,4); // black microswitch
	else XStopMount(22,10,8,Yes3mmInsert(Use3mmInsert,LargeInsert),screw5,8);	// TEMCo CN0097
	if(BlackY) translate([0,40,0])
					YStopMount(10,0,0,Yes2mmInsert(Use2mmInsert),Yes5mmInsert(Use5mmInsert),4); // black microswitch
	else translate([0,40,0]) YStopMount(22,10,8,Yes3mmInsert(Use3mmInsert,LargeInsert),screw4,8);	// TEMCo CN0097
	translate([-10,-30,0])StrikeY(screw5);
	//translate([-30,-50,0]) StrikeX(screw5,EXOSlide);
}

//////////////////////////////////////////////////////////////////////////

module XStopMount(Sep,DiagOffset,Offset,ScrewSwitch,ScrewMount=screw5,Adjust) {
	EndstopBase(Sep,DiagOffset,Offset,ScrewSwitch,Adjust);
	EndstopMount(ScrewMount);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YStopMount(Sep,DiagOffset,Offset,ScrewSwitch,ScrewMount=screw5,Adjust) {
	EndstopBase(Sep,DiagOffset,Offset,ScrewSwitch,Adjust);
	EndstopMount(ScrewMount);
}

///////////////////////////////////////////////////////////////////////////

module YStopMountMS(Sep,DiagOffset,Offset,ScrewSwitch,ScrewMount=screw5,Adjust) { // mounts on MS
	difference() {
		color("cyan") cuboid([25,39,5],rounding=2); // 39 to fit between the MS rails
		translate([-5,-10,0]) ExtrusionMountingHoles();
		if(DiagOffset) { // switch mount
			translate([Adjust+3,-11,0]) {
				translate([-(Switch_ht-Offset)+14,SwitchShift,0]) color("purple") cyl(h = 11, d = ScrewSwitch);
				translate(v = [-(Switch_ht-Offset)+14+DiagOffset,SwitchShift+Sep,0]) color("gray")
					cyl(h = 11, d=ScrewSwitch);
			}
		} else {
			translate([Adjust+9,-11,0]) {
				translate([-(Switch_ht-Offset)+14,SwitchShift,0]) color("purple") cyl(h = 11, d = ScrewSwitch);
				translate(v = [-(Switch_ht-Offset)+14+DiagOffset,SwitchShift+Sep,0])
					color("gray") cyl(h = 11, d=ScrewSwitch);
			}
		}
	}
	translate([30,0,0]) difference() { // y strike on carriage plate
		union() {
			color("gray") cuboid([25,40,5],rounding=2);
			translate([11,0,2.5]) color("purple") cuboid([5,40,10],rounding=2);
		}
		translate([-4,-10,0]) YStrikeMountHoles();
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module YStrikeMountHoles(Screw=Yes5mmInsert(Use5mmInsert)) {
	color("green") cyl(h=20,d=Screw);
	translate([0,20,0]) color("white") cyl(h=20,d=Screw);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ExtrusionMountingHoles(Screw=screw5) {
	color("red") cyl(h=20,d=Screw);
	translate([0,20,0]) color("blue") cyl(h=20,d=Screw);
	translate([0,0,4]) {
		color("blue") cyl(h=5,d=screw5hd);
		translate([0,20,0]) color("red") cyl(h=5,d=screw5hd);
	}
}

////////////////////////////////////////////////////////////////////////////////

module EndstopMount(Screw=screw5) {
	difference() {
		color("cyan") cuboid([13,HolderWidth,Switch_thk2],rounding=2,p1=[0,0]);
		translate([8,6,-1]) cylinder(h=Switch_thk*2,d=Screw);
		color("blue") hull() {
			translate([8,28,-1]) cylinder(h=Switch_thk*2,d=Screw);
			translate([8,25,-1]) cylinder(h=Switch_thk*2,d=Screw);
		}
	}
}
///////////////////////////////////////////////////////////////////////////////

module EndstopBase(Sep,DiagOffset,Offset,Screw,Adjust) {
	difference() {
		translate([-8-Adjust,0,0]) color("yellow")
			cuboid([Switch_ht+Adjust-8,HolderWidth,Switch_thk],rounding=2,p1=[0,0]);
		// screw holes for switch
		if(DiagOffset) {
			translate([Adjust-22,0,0]) {
				translate([-(Switch_ht-Offset)+14,SwitchShift,-1]) color("purple") cylinder(h = 11, d = Screw);
				translate(v = [-(Switch_ht-Offset)+14+DiagOffset,SwitchShift+Sep,-1]) color("gray") cylinder(h = 11, d=Screw);
			}
		} else {
			translate([Adjust-6,0,0]) {
				translate([-(Switch_ht-Offset)+14,SwitchShift,-1]) color("purple") cylinder(h = 11, d = Screw);
				translate(v = [-(Switch_ht-Offset)+14+DiagOffset,SwitchShift+Sep,-1]) color("gray") cylinder(h = 11, d=Screw);
			}
		}
	}
}

/////////////////////////////////////////////////////////////////////////////

module StrikeY(Screw=screw5) {	// used on y a-xis
	difference() {
		color("cyan") hull() {
			translate([0,20,0]) cuboid([35,4,15],rounding=2,p1=[0,0]);
			cuboid([35,4,4],rounding=2,p1=[0,0]);
		}
		translate([7.5,20,8]) {
			translate([0,10,0]) rotate([90,0,0]) color("red") cylinder(h=30,d=Screw);
			translate([20,10,0]) rotate([90,0,0]) color("blue") cylinder(h=30,d=Screw);
			translate([0,1,0]) rotate([90,0,0]) color("blue") cylinder(h=30,d=screw5hd);
			translate([20,1,0]) rotate([90,0,0]) color("red") cylinder(h=30,d=screw5hd);
		}
	}
}

/////////////////////////////////////////////////////////////////////////////

module StrikeX(Screw=screw5,EXOSlide=0,DoTab=1) {	// used on y a-xis
	difference() {	
		color("cyan") cuboid([9,84,9],rounding=2,p1=[0,0]);
		translate([-5,58,4.5]) mount2040(Screw);
	}
	if(EXOSlide) {
		color("blue") hull() {
			translate([0,-10,22]) cuboid([35,15,5],rounding=2,p1=[0,0]);
			translate([0,0,0]) cuboid([35,5,5],rounding=2,p1=[0,0]);
		}
	} else {
		color("gray")  hull() {
			cuboid([35,5,5],rounding=2,p1=[0,0]);
			translate([0,0,4]) cuboid([35,9,5],rounding=2,p1=[0,0]);
		}
	}
	if(DoTab) {
		translate([33,5,0]) color("green") cylinder(h=LayerThickness,d=20);
		translate([4,5,0]) color("red") cylinder(h=LayerThickness,d=20);
		translate([4,80,0]) color("plum") cylinder(h=LayerThickness,d=20);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////

module mount2040(Screw=screw5) {
	translate([0,0,0]) rotate([0,90,0]) color("red") cylinder(h=20,d=Screw);
	translate([0,20,0]) rotate([0,90,0]) color("blue") cylinder(h=20,d=Screw);
	translate([1,0,0]) rotate([0,90,0]) color("blue") cylinder(h=5,d=screw5hd);
	translate([1,20,0]) rotate([0,90,0]) color("red") cylinder(h=5,d=screw5hd);
}

////////////////////////////////////////////////////////////////////////////
