//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// E3DV6 Blower 5150 Adpater.scad - mount a 5015 blower to a 40mm axial fan mount
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 8/26/2016
// last update 6/29/2020
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/26/16	- modified version from duet2020.v0.2.scad
//			  Made base large enough to cover where 40mm fan was and added a second piller to hold blower
// 9/10/16	- shifted fan closer to bottom of heatsink
// 1/1/17	- changed to 30mm fan and added colors to preview
// 6/1/19	- Made the base as thick as the supplied 30mm fan to be able to use the original screws
//			  Added abiltiy to ajsut fan position to be adjusted left/right
// 6/29/20	- Added use of 4mm brass insert
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// includes
include <inc/screwsizes.scad>
use <inc/cubeX.scad> // http://www.thingiverse.com/thing:112008
include <inc/brassinserts.scad>
$fn=50;
////////////////////////////////////////////////////////////////////////////////////////////////////////////
Use4mmInsert=1;
countersink=2;
bthick = 10+countersink; // thickness of platform
fan_support = 24; // 30mm fan=24
40mmFanMountSpacing=32;
fan_adjustLR=0.5;
adjust_bevel=4;
///////////////////////////////////////////////////////////////////////////////////////////////////////

//blower_adapter(); // for a 5015 blower fan to 30mm square fan
BlowerAdapterAero(); // for a 5015 blower fan to 30mm square fan

///////////////////////////////////////////////////////////////////////////////////////////////////////////////

module BlowerAdapterAero() {
	difference() {
		color("cyan") cubeX([40mmFanMountSpacing+9,40mmFanMountSpacing+9,bthick+1],2);
		translate([4,4,-2]) {
			color("red") cylinder(h=bthick+5,d=screw3);
			translate([40mmFanMountSpacing,0,0]) color("blue") cylinder(h=bthick+5,d=screw3);
			translate([0,40mmFanMountSpacing,0]) color("green") cylinder(h=bthick+5,d=screw3);
			translate([40mmFanMountSpacing,40mmFanMountSpacing,0]) color("black") cylinder(h=bthick+5,d=screw3);
		}
		FanHoleAero();
	}
	difference() { // fan holder
		union() {
			translate([15,28.5,0]) color("gray") cubeX([screw4+4,screw4+1,48+screw4+1+bthick],2);
			translate([15,7,0]) color("lightgray") cubeX([screw4+4,screw4+1,48+screw4+1+bthick],2);
			translate([14,7,45]) rotate([0,-30,0]) color("cyan") cubeX([11,screw4+1,15],2);
			translate([14,28.5,45]) rotate([0,-25,0]) color("white") cubeX([11,screw4+1,15],2);
		}
		translate([screw4/2+12,screw4+35,56]) rotate([90,0,0]) color("red") cylinder(h=15,d=Yes4mmInsert(Use4mmInsert));
		translate([screw4/2+12,screw4+13,56]) rotate([90,0,0]) color("blue") cylinder(h=15,d=screw4);
		FanHoleAero();
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FanHoleAero() {
	color("gray") hull() {
		translate([10,13,11.5]) color("khaki") cube([20,15,2]);
		translate([4,4,-1]) cube([32,32,1]);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module blower_adapter(blower_h=20,blower_w=15,blower_m_dist=48) { // to use a 50mm 10x15 blower instead of a 40mm axial
	if($preview) %blowertest(blower_h,blower_w,blower_m_dist); // show blower in preview
	difference() {
		translate([-0.5+fan_adjustLR,-0.5,0]) color("red") cubeX([fan_support+9,fan_support+9,bthick+1],2);
		translate([fan_support/2-blower_w/4+fan_adjustLR,fan_support/2-blower_h/2-0.1,-2]) color("black")
			cube([blower_w,blower_h,bthick+5]);
		translate([4+fan_adjustLR,4,-2]) color("white") cylinder(h=bthick*2,r=screw3/2);
		translate([fan_support+4+fan_adjustLR,4,-2]) color("black") cylinder(h=bthick*2,r=screw3/2);
		translate([4+fan_adjustLR,6,bthick-countersink]) color("white") cylinder(h=bthick*2,r=screw3hd/2);
		translate([fan_support+4+fan_adjustLR,4,bthick-countersink]) color("black") cylinder(h=bthick*2,r=screw3hd/2);
		translate([4+fan_adjustLR,fan_support+4,-2]) color("yellow") cylinder(h=bthick*2,r=screw3/2);
		translate([fan_support+4+fan_adjustLR,fan_support+4,-2]) color("pink") cylinder(h=bthick*2,r=screw3/2);
		translate([4,fan_support+4+fan_adjustLR,bthick-countersink]) color("yellow") cylinder(h=bthick*2,r=screw3hd/2);
		translate([fan_support+4+fan_adjustLR,fan_support+4,bthick-countersink]) color("pink") cylinder(h=bthick*2,r=screw3hd/2);
		translate ([fan_support/2-blower_w/4+fan_adjustLR,fan_support/2-blower_h/2+18+adjust_bevel,-8]) rotate([45,0,0])
			color("white") cube([blower_w,10,15]);
	}
	difference() {
		translate([23.3+fan_adjustLR,blower_h-12.5,0]) color("plum") cubeX([screw4+1,screw4+4,blower_m_dist+screw4+1+bthick],2);
		translate([screw4/2+20+fan_adjustLR,screw4+blower_w-12.9,blower_m_dist+bthick-4.3]) rotate([90,0,90])
			cylinder(h=10,d=screw4);
		translate([fan_support+4+fan_adjustLR,4,3]) color("black") cylinder(h=bthick*2,r=screw3hd/2);
	}
	difference() {
		translate([23.3+fan_adjustLR,blower_h-9.5,blower_m_dist-18+bthick]) rotate([30,0,0]) color("blue")
			cubeX([screw4+1,screw4+6,20],2);
		translate([22.3+fan_adjustLR,blower_h-8.5,blower_m_dist-20+bthick]) color("pink") cube([screw4+3,screw4+4,20],2);
		translate([screw4/2+20+fan_adjustLR,screw4+blower_w-13,blower_m_dist+bthick-4.3]) rotate([90,0,90]) cylinder(h=10,d=screw4);
	}
	difference() { // fan holder
		translate([17.7-blower_w+fan_adjustLR,blower_h-12,0]) color("gray")
			cubeX([screw4+1,screw4+4,blower_m_dist+screw4+1+bthick],2);
		translate([screw4/2+15-blower_w+fan_adjustLR,screw4+blower_w-13.2,blower_m_dist+7.75]) rotate([90,0,90])
			cylinder(h=10,d=Yes4mmInsert(Use4mmInsert));//screw4t);
		translate([4+fan_adjustLR,4,3]) color("white") cylinder(h=bthick*2,r=screw3hd/2);
	}
	difference() {
		translate([17.7-blower_w+fan_adjustLR,blower_h-12,blower_m_dist-18+bthick]) rotate([30,0,0]) color("cyan")
		cubeX([screw4+1,screw4+10,19],2);
		translate([16.7-blower_w+fan_adjustLR,blower_h-8,blower_m_dist-20+bthick]) color("pink") cube([screw4+3,screw4+4,20],2);
		translate([screw4/2+15-blower_w+fan_adjustLR,screw4+blower_w-13.3,blower_m_dist+7.75]) rotate([90,0,90])
			cylinder(h=10,d=Yes4mmInsert(Use4mmInsert));//screw4t);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module blowertest(blower_h,blower_w,blower_m_dist) {
	translate([fan_support-blower_w/4+3,fan_support/2-blower_h/2,bthick-1]) rotate([90,0,90]) blower();
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module blower() {
	import("5015_Blower_Fan.stl"); // http://www.thingiverse.com/thing:1576438
}

//////////////////// end of duet2020.scad ////////////////////////////////////////////////////////////
