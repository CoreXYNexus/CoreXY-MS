///////////////////////////////////////////////////////////////////////
// WebCam-Mount.scad - lifecam holder and PI Cam holder
///////////////////////////////////////////////////////////////////////
// created 1/31/16
// last update 12/23/18
////////////////////////////////////////////////////////////////////////
// ABS or something that can handle the heatbed temperature
/////////////////////////////////////////////////////////////////////////
// 3/23/16 - added clamping screw for cam
// 12/23/18	- Added preview colors and a PI3 with camera in a plastic case holder
//			  Added cubeX.scad
/////////////////////////////////////////////////////////////////////////
include <inc/cubeX.scad>
// vars
///////////////////////////////////////////////////////////////////////
$fn=100;
screw5 = 5.5;	// 5mm screw hole size
screw3 = 3.6;
camdia = 29;	// outside diameter of usb camera
length = 80;	// distance needed from bed to see the entire bed
outer = 7;		// thickness of ring to hold camera
width = camdia + outer;	// width of the ring to hold camera
thickness = 6;	// thickness of extension and mount
camshift = -4.5;	// amount to move camera ring to end of extension
mlength = 20;	// length of the mount
extruder = 0.4;	// extruder size for print support for mount end
stall = 5.16;	// height of print support for mount end
// note: support for one side needs adjusting if cam size changes
////////////////////////////////////////////////////////////////////////

bracket();
//bracketPI();

////////////////////////////////////////////////////////////////////////

module bracket() {
	// cam end
	cam();
	clamp();
	// extension
	extension();
	reinforce();
	// mount to bed
	mount();
}

////////////////////////////////////////////////////////////////////////

module bracketPI() { // pi3 in a vilros clear case with the pi camera inside
	cam(1);
	extension(1);
	mount(1);
}

module cam(PI=0) {
	if(!PI) {
		translate([camshift,camdia/2-2.4,camdia/2+outer]) rotate([0,75,0]) difference() {
			color("cyan") cylinder(h=thickness,r=camdia/2+outer,$fn=100);	// outer
			translate([-25,0,-4]) color("red") cubeX([thickness+6,1.5,outer+5],1); // expansion slot
			translate([0,0,-1]) color("gray") cylinder(h=thickness+2,r=camdia/2,$fn=100); // hole
		}
	} else {
			translate([30,-width/6,0]) color("red") cubeX([thickness,width,mlength+5],1); // expansion slot
	}
}

module extension(PI=0) {
	if(!PI)	translate([0,-width/6,0]) color("black") cubeX([length,width,thickness],1);
	else translate([0,-width/6,0]) color("black") cubeX([length-8,width,thickness],1);
}

module mount(PI=0) {
	if(!PI) {
		difference() {
			color("blue") rotate([0,-15,0]) translate([length-2.5,-width/6,-20.8]) cubeX([mlength,width,thickness],1);
			// next is not all the way thru to make support of the bottom of the hole
			color("lightgray") rotate([0,-15,0]) translate([length+7,width/3,-20.6]) cylinder(h=thickness*2,r=screw5/2,$fn=100);
		}
		support();
		support2();
	} else {
		difference() {
			color("blue") translate([length-10.5,-width/6,0]) cubeX([mlength,width,thickness],1);
			// next is not all the way thru to make support of the bottom of the hole
			color("lightgray") translate([length,width/3,-2]) cylinder(h=thickness*2,r=screw5/2,$fn=100);
		}
	}
}


module support() {
	color("plum") translate([length+mlength-0.85,-width/6,0]) cube([extruder,width,stall]);
//	rotate([0,-15,0]) translate([length+3,-width+44,-20.8]) cubeX([screw5+2,screw5+2,extruder]);
}

module support2() {
	color("gold") rotate([0,0,90]) translate([-width/6,-(length+mlength-0.85),0]) cube([extruder,width,stall]);
	color("white") rotate([0,0,90]) translate([width-6.5,-(length+mlength-0.85),0]) cube([extruder,width,stall]);
}

module reinforce() {
	difference() {
		translate([0,-5,0]) rotate([6,0,0]) color("yellow") cubeX([20,4,20],1);
		translate([5,-7,20]) rotate([6,50,0]) color("pink") cube([25,6,25]);
	}
	difference() {
		translate([0,25,1]) rotate([-6,0,0]) color("red") cubeX([20,4,20],1);
		translate([5,25,21]) rotate([-6,50,0]) color("blue") cube([25,6,25]);
	}
}

module clamp() {
	difference() {
		translate([camshift-4,camdia/2-12,camdia/2+outer+16]) rotate([0,-15,0]) color("black") cubeX([6,20,15],1);
		translate([camshift-5,camdia/2-2.5,camdia/2+outer+15]) rotate([0,-15,0]) color("plum") cube([8,1.5,35]); // expansion slot
		translate([camshift-3.5,camdia/2+12,camdia/2+outer+25]) rotate([90,0,0]) color("white") cylinder(h=30,r=screw3/2,$fn=100);
	}
}

///////////// end of lifecam.scad //////////////////////////////////////