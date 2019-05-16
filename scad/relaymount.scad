///////////////////////////////////////////////////////////////////////////////
// relaymount.scad - something to mount a relay board onto 2020
///////////////////////////////////////////////////////////////////////////////
// created 2/13/16
// last update 5/10/19
///////////////////////////////////////////////////////////////////////////////
// 2/24/16 - added zip tie option
// 5/17/16 - changed to use CubeX and the corrected the math for the mount holes
//			 added zip tie thickness and the option to have screw & zip mount
// 8/18/16 - Added x,y vars for pc board holes
// 5/10/19	- made the mount() parametric via the passed variables
///////////////////////////////////////////////////////////////////////////////
use <inc/cubex.scad>
include <inc/screwsizes.scad>
$fn=50;
///////////////////////////////////////////////////////////////////////////////
// vars
///////////////////////////////////////////////////////////////////////////////
bossh = 2;		// spacing needed to clear stuff on bottom of board
zipw = 4;		// zip tie width
zipthick = 2;	// zip tie thickness (depth of slot will the zipthick/2)
///////////////////////////////////////////////////////////////////////////////

// 1st arg is type: 0 - zip tie mount;1 - screw mount;2 - both;3 - neither
//mount2(2,Width,Length,Thickness,Side_dx,Side_dy);
//mount2(2,21.24,43.37,5,6.6,2.6); // 12v relay module from Amazon
mount2(2,21.2,43.1,5,6.3,3); // ebay buck convertor
///////////////////////////////////////////////////////////////////////////////

module mount2(type,width,length,thickness,side_dx,side_dy) {
	difference() {
		cubeX([length,width,thickness],2);
		boardholes(screw3t,thickness,side_dx,side_dy,length,width);
		if(type==0)	zip(width,length,thickness);
		if(type==1) mounthole(screw5,width,length,thickness);
		if(type==2) {
			mounthole(screw5,width,length,thickness);
			zip(width,length,thickness);
		}
		if(type==3) ;	// neither
	}
	boss(screw3t,thickness,side_dx,side_dy,length,width);
}

/////////////////////////////////////////////////////////////////////////////////////////////

//module mount(hole) {
//	difference() {
//		cubeX([Length,Width,Thickness],2);
//		boardholes();
//		if(hole==0)	zip();
//		if(hole==1) mounthole();
//		if(hole==2) {
//			mounthole();
//			zip();
//		}
//		if(hole==3) ;	// neither
//	}
//	boss();
//}

///////////////////////////////////////////////////////////////////////////////

module boardholes(Screw,thickness,side_dx,side_dy,length,width) { // holes for mounting the relay board
		translate([side_dx,side_dy,-2]) cylinder(h=thickness+8,r=screw3/2);
		translate([length-side_dx,side_dy,-2]) cylinder(h=thickness+8,r=screw3/2);
		translate([side_dx,width-side_dy,-2]) cylinder(h=thickness+8,r=screw3/2);
		translate([length-side_dx,width-side_dy,-2]) cylinder(h=thickness+8,r=screw3/2);
}
///////////////////////////////////////////////////////////////////////////////

module mounthole(Screw,width,length,thickness) { // hole to mount it to 2020
	translate([length/2,width/2,-2]) cylinder(h=thickness+5,r=screw5/2);
	// countersink the screw
	translate([length/2,width/2,thickness-1]) cylinder(h=thickness+5,r=screw5hd/2);
	
}

///////////////////////////////////////////////////////////////////////////////

module boss(Screw,thickness,side_dx,side_dy,length,width) {
	difference() {
		translate([side_dx,side_dy,0]) color("red") cylinder(h=thickness+bossh,d=Screw*2);
		translate([side_dx,side_dy,-1]) cylinder(h=thickness+8,d=Screw);
	}
	difference() {
		translate([length-side_dx,side_dy,]) color("blue") cylinder(h=thickness+bossh,d=Screw*2);
		translate([length-side_dx,side_dy,-1]) cylinder(h=thickness+8,d=Screw);
	}
	difference() {
		translate([side_dx,width-side_dy,0]) color("plum") cylinder(h=thickness+bossh,d=Screw*2);
		translate([side_dx,width-side_dy,-1]) cylinder(h=thickness+8,d=Screw);
	}
	difference() {
		translate([length-side_dx,width-side_dy,0]) color("black") cylinder(h=thickness+bossh,d=Screw*2);
		translate([length-side_dx,width-side_dy,-1]) cylinder(h=thickness+8, d=Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////////

module zip(width,length,thickness) {
	translate([length/2-zipw/2,-1,thickness-zipthick/2]) cube([zipw,60,3]);
}

//////////////////// end of relaymount.scad ///////////////////////////////////