////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Power.scad - uses a pc style power socket with switch
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 7/4/2016
// last update 7/24/19
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/4/16	- Added cover
// 8/5/16	- adjusted cover & 2020 mounting holes
// 1/10/17	- Added colors for easier editing in preview and added mount for a power switch
// 1/11/17	- Added label to power switch mount
// 8/19/18	- OpenSCAD 2018.06.01 for $preview
// 5/10/19	- Added a rear cover for the power switch
// 5/11/19	- Added a power cover with rounded edges and square edges
// 5/16/19	- Merged power supply mount into here and renamed this file
// 5/28/19	- Added a housing version with seperate power plug and switch, added M5 countersinks to housing, modified the MMAX
//			  power supply mounts for the CXY-MSv1 corexy
// 7/24/19	- Adjusted cover() screw holes
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NOTE: Version 0 uses Digi-Key Part number: CCM1666-ND : combined power socket and switch
//		 http://www.digikey.com/product-detail/en/te-connectivity-corcom-filters/1609112-3/CCM1666-ND/758835
//		 ---------------------------------------------------------------------------------------------------
//		 If the socket hole size changes, then the size & postions of the walls/wings & socket may need adjusting
//		 The power socket uses 3mm screws to mount, drill with 2.5mm and tap after installing the socket
///////////////////////////////////////////////////////////////////////////////////////////////////////////
use <inc/cubeX.scad>	// http://www.thingiverse.com/thing:112008
include <inc/screwsizes.scad>
use <BABIND.TTF>	// true type font used for the label
$fn = 50;
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
SwitchSocketWidth = 40;	// socket hole width
SwitchSocketHeight = 27;	// socket hole height
SocketShiftLR = 0; // move socket left/right
SocketShiftUD = 0; // move socket up/down
PowerSupplyCoverClearance = 1;
PowerSupplyCoverWidth=115+PowerSupplyCoverClearance;
PowerSupplyCoverHeight=50+PowerSupplyCoverClearance;
PowerSupplyCoverDepth=55;
//PowerSupplyCoverTab=24;
PowerSupplyAdjust=2;
PowerSupplySideMountingScrewSpacing=25;
Length = 113;
Width = 13;
Thickness = 10;
LayerThickness = 0.2;
SocketPlugWidth=SwitchSocketWidth;
SocketPlugHeight=SwitchSocketHeight;
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//all(0,13,19.5,2,1,2,0);// 1st arg: flip power label; next 4 args: Width, length, clip Thickness; defaults to 0,13,19.5,2
//testfit();	// print part of it to test fit the socket & 2020
//switch();		// 4 args: flip label, Width, length, clip Thickness; defaults to 0,13,19.5,2
//powersupply_cover();
//powersupply_cover_v2();
//pbar(1,2);
housing(1,13,19.5);
//translate([0,0,0]) cover();

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module all(flip=0,s_w=13,s_l=19.5,s_t=2,Makerslide=1,PBQuantiy=2,Version=0) {
	if($preview) %translate([25,20,0]) cube([200,200,2],center=true); // show the 200x200 bed
	translate([0,-12,0]) housing(Version,s_l,s_w);
	translate([0,-5,45]) rotate([180,0,0]) cover();
	translate([-50,-45,0]) switch(flip,s_w,s_l,s_t);		// 3 args: Width, length, clip Thickness; defaults to 13,19.5,2
	translate([-30,60,0]) powersupply_cover();
	translate([-35,-10,0]) rotate([0,0,90]) pbar(Makerslide,PBQuantiy);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

module powersupply_cover_v2() { // square version
	if($preview) {  // verify inside is the right size
		%translate([14,2,5]) cube([5,PowerSupplyCoverHeight,5]);
		%translate([2,14,5]) cube([PowerSupplyCoverWidth,5,5]);
	}
	difference() {
		color("cyan") cube([PowerSupplyCoverWidth+4,PowerSupplyCoverHeight+4,2]); 
		translate([111,PowerSupplyCoverHeight/2+4,-2]) rotate([0,0,180]) pwr_supply_cover_vents(18); // ventilation
	}
	translate([PowerSupplyCoverWidth/5,0.5,PowerSupplyCoverDepth/6]) rotate([90,0,0]) printchar("DANGER HIGH VOLTAGE",1.5,4);
	translate([PowerSupplyCoverWidth/1.2,54.5,PowerSupplyCoverDepth/6]) rotate([90,0,180]) printchar("DANGER HIGH VOLTAGE",1.5,4);
	difference() {
		translate([0,0,0]) color("red") cube([2,PowerSupplyCoverHeight+4,PowerSupplyCoverDepth]);
		pwrc_supply_screws(screw4); // mount it to the power supply
	}
	difference() {
		translate([PowerSupplyCoverWidth+2,0,0]) color("plum") cube([2,PowerSupplyCoverHeight+4,PowerSupplyCoverDepth]);
		pwrc_supply_screws(screw4); // mount it to the power supply
	}
	translate([0,0,0]) color("gray") cubeX([PowerSupplyCoverWidth+4,2,PowerSupplyCoverDepth],1);
	translate([0,PowerSupplyCoverHeight+2,0]) color("lightgray") cube([PowerSupplyCoverWidth+4,2,PowerSupplyCoverDepth-14]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module powersupply_cover() { // rounded version (cubeX)
	if($preview) {  // verify inside is the right size
		%translate([14,4,5]) cube([5,PowerSupplyCoverHeight,5]);
		%translate([4,14,5]) cube([PowerSupplyCoverWidth,5,5]);
	}
	difference() {
		color("cyan") cubeX([PowerSupplyCoverWidth+8,PowerSupplyCoverHeight+8,4],1); 
		translate([113,PowerSupplyCoverHeight/2+7,-2]) rotate([0,0,180]) pwr_supply_cover_vents(18); // ventilation
	}
	difference() {
		translate([0,0,0]) color("red") cubeX([4,PowerSupplyCoverHeight+8,PowerSupplyCoverDepth],1);
		pwrc_supply_screws(screw4); // mount it to the power supply
	}
	difference() {
		translate([PowerSupplyCoverWidth+4,0,0]) color("plum") cubeX([4,PowerSupplyCoverHeight+8,PowerSupplyCoverDepth],1);
		pwrc_supply_screws(screw4); // mount it to the power supply
	}
	translate([0,0,0]) color("gray") cubeX([PowerSupplyCoverWidth+8,4,PowerSupplyCoverDepth],1);
	translate([0,PowerSupplyCoverHeight+4,0]) color("lightgray") cubeX([PowerSupplyCoverWidth+8,4,PowerSupplyCoverDepth-14],1);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module pwrc_supply_screws(Screw) {
	translate([-5,PowerSupplyCoverHeight/4+PowerSupplyAdjust,PowerSupplyCoverDepth-7]) rotate([0,90,0]) color("black") cylinder(h=PowerSupplyCoverWidth+17,d=Screw);
	translate([-5,PowerSupplyCoverHeight/4+PowerSupplySideMountingScrewSpacing+PowerSupplyAdjust,PowerSupplyCoverDepth-7]) rotate([0,90,0]) color("white") cylinder(h=PowerSupplyCoverWidth+17,d=Screw);
}


////////////////////////////////////////////////////////////////////////////////////////////////////////

module pwr_supply_cover_vents(Qty=1) {
	for(a = [0:Qty-1]) {
		translate([a*6,0,0]) color("black") hull() {
			cylinder(h=10,d=3);
			translate([0,20,0]) cylinder(h=10,d=3);
		}
	}
	translate([2,-11,-2]) color("gray") hull() { // wire access hole
		cylinder(h=10,d=10);
		translate([PowerSupplyCoverWidth-18,0,0]) cylinder(h=10,d=10);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module housing(Version=0,s_w=13,s_l=19.5) {
	if($preview) %translate([-5,18,0]) cube([5,60,5]); // something to show max height
	difference() {
		color("blue") cubeX([SwitchSocketWidth+40,SwitchSocketHeight+40,5],2); // base
		translate([SwitchSocketWidth,9,-2]) color("green") cylinder(h=10,r=screw5/2); // center 2020 mounting hole
		translate([SwitchSocketWidth,9,-9]) color("lightgreen") cylinder(h=10,d=screw5hd); // center 2020 mounting hole
		// socket hole
		if(Version==0) {
			translate([SwitchSocketWidth/2+SocketShiftLR,SwitchSocketHeight/2+14+SocketShiftUD,-2]) color("cyan") cube([SwitchSocketWidth,SwitchSocketHeight,10]);
		} else {
			translate([SwitchSocketWidth/2+SocketShiftLR-10,SwitchSocketHeight/2+14+SocketShiftUD,-2]) color("cyan")
				cube([SocketPlugWidth,SocketPlugHeight,10]); // plug socket
			translate([SwitchSocketWidth/2+SocketShiftLR+36,SwitchSocketHeight/2+14.2+SocketShiftUD,-2]) color("pink")
				cube([s_w,s_l,8]); // swicth
		}
	}
	difference() {
		translate([0,SwitchSocketHeight+35,0]) color("red") cubeX([SwitchSocketWidth+40,5,40],2); // top wall
		cover_screw_holes(screw3t);
	}
	difference() {
		translate([0,19,0]) color("black") cubeX([5,SwitchSocketHeight+21,40],2); // left wall
		cover_screw_holes(screw3t);
	}
	difference() {
		translate([SwitchSocketWidth+35,19,0]) color("white") cubeX([5,SwitchSocketHeight+21,40],2); // right wall
		cover_screw_holes(screw3t);
	}
	difference() { // right wing
		translate([SwitchSocketWidth+35,19,0]) color("lightblue") cubeX([25,5,25],2); // wall
		translate([SwitchSocketWidth+50,26,15]) rotate([90,0,0]) color("blue") cylinder(h=10,r=screw5/2); // 2020 mounting hole
		translate([SwitchSocketWidth+50,33,15]) rotate([90,0,0]) color("cyan") cylinder(h=10,d=screw5hd); // 2020 mounting hole
	}
	difference() { // left wing
		translate([-20,19,0]) color("tan") cubeX([25,5,25],2); // wall
		translate([-10,26,15]) rotate([90,0,0]) color("brown") cylinder(h=10,r=screw5/2); // 2020 mounting hole
		translate([-10,33,15]) rotate([90,0,0]) color("gray") cylinder(h=10,d=screw5hd); // 2020 mounting hole
	}
	coverscrewholes();
	difference() {
		translate([-20,0,0]) color("salmon") cubeX([25,23,5],2); // left wing base filler
		translate([-10,9,-2]) color("pink") cylinder(h=10,r=screw5/2); // 2020 mounting hole
		translate([-10,9,-9]) color("black") cylinder(h=10,d=screw5hd); // 2020 mounting hole
	}
	difference() {
		translate([SwitchSocketWidth+35,0,0]) color("orange") cubeX([25,23,5],2);	// right wing base filler
		translate([SwitchSocketWidth+50,9,-2]) color("khaki") cylinder(h=10,r=screw5/2); // 2020 mounting hole
		translate([SwitchSocketWidth+50,9,-9]) color("lightgray") cylinder(h=10,d=screw5hd); // 2020 mounting hole
	}
	translate([SwitchSocketWidth+50-screw5hd/2,9-screw5hd/2,1]) screwholesupport();
	translate([-10-screw5hd/2,9-screw5hd/2,1]) screwholesupport();
	translate([SwitchSocketWidth-screw5hd/2,9-screw5hd/2,1]) screwholesupport();
}

//////////////////////////////////////////////////////////////////

module screwholesupport() {
	color("plum") cube([screw5hd+1,screw5hd+1,LayerThickness]);
}

module coverscrewholes(Screw=screw3) {
	difference() {
		translate([5,40,20]) color("blue") cylinder(h=20,d=screw5); // left
		translate([5,35,13]) rotate([0,-45,0]) color("red") cube([10,10,5]);
		cover_screw_holes(Screw);
	}
	difference() {
		translate([SwitchSocketWidth+35,40,20]) color("red") cylinder(h=20,d=screw5); // right
		translate([SwitchSocketWidth+27,35,22]) rotate([0,45,0]) color("blue") cube([10,10,5]);
		cover_screw_holes(Screw);
	}
	difference() {
		translate([SwitchSocketWidth,62,20]) color("white") cylinder(h=20,d=screw5); // top screw hole
		translate([SwitchSocketWidth-5,55,20]) rotate([-45,0,0]) color("green") cube([10,10,5]);
		cover_screw_holes(Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module cover_screw_holes(Screw=screw3t) {
	translate([5,40,7]) color("white") cylinder(h=40,d=Screw); // left
	translate([SwitchSocketWidth+35,40,7]) color("gray") cylinder(h=40,d=Screw); // right
	translate([SwitchSocketWidth,62,7]) color("hotpink") cylinder(h=40,d=Screw); // top screw hole
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

module testfit() { // may need adjusting if the socket size is changed
	difference() {
		sock();
		translate([-28,-10,-5]) cube([SwitchSocketWidth+90,SwitchSocketHeight,50]); // walls around socket only
		translate([-28,-2,-2]) cube([SwitchSocketWidth+90,SwitchSocketHeight+50,5]); // remove some from bottom
		translate([-28,-2,6]) cube([SwitchSocketWidth+90,SwitchSocketHeight+50,50]); // shorten vertical 2020 wings
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module cover(Screw=screw3) {
	difference() {
		translate([0,15,40]) color("cyan") cubeX([SwitchSocketWidth+40,SwitchSocketHeight+27,5],2); // base
		cover_screw_holes(Screw);
	}
	difference() {
		translate([0,13.8,25]) color("red") cubeX([SwitchSocketWidth+40,5,20],2); // base
		color("white") hull() {
			translate([SwitchSocketWidth,25,30]) rotate([90,0,0]) cylinder(h=15,d=10);
			translate([SwitchSocketWidth,25,25]) rotate([90,0,0]) cylinder(h=15,d=10);
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module switch(Flip=0,s_w=13,s_l=19.5,s_t=2) {
	difference() {  // switch front and switch mounting hole
		color("cyan") cubeX([s_l+15,s_w+15,5],2);
		translate([s_l/2-2,s_w/2+1,-2]) color("pink") cube([s_l,s_w,8]);
		translate([s_l/2-3.5,s_w/2+1,s_t]) color("red") cube([s_l+3,s_w,8]);
		switch_label(Flip);
	}
	translate([0,-2,0]) color("blue") cubeX([5,s_l+11,s_w+25],2); // left wall
	translate([s_l+10,-2,0]) color("salmon") cubeX([5,s_l+11,s_w+25],2); // right wall
	translate([s_l-18,s_w+10.5,0]) color("tan") cubeX([s_l+13,5,s_w+15],2); // rear wall
	difference() {
		translate([s_l-18,-2,0]) color("brown") cubeX([s_l+13,5,s_w+25],2); // top wall
		switch_label(Flip);
	}
	translate([0,0,33]) color("plum") cubeX([s_l+15,s_w+15,5],2); // rear cover
	translate([0,-22,0]) sw_mount(Flip,s_l+15);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sw_mount(Flip=0,Width) {
	difference() {
		color("green") cubeX([Width,27,5],2);
		translate([10,10,-2]) color("red") cylinder(h=10,d=screw5,$fn=100);
		translate([25,10,-2]) color("blue") cylinder(h=10,d=screw5,$fn=100);
		translate([0,22,0]) switch_label(Flip);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module switch_label(Flip=0) {
	if(!Flip) translate([5.5,-0,1]) rotate([180,0,0]) printchar("POWER",2,4);
	else translate([29,-2,1]) rotate([0,180,0]) printchar("POWER",2,4);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=1.5,Size=4) { // print something
	color("black") linear_extrude(height = Height) text(String, font = "Babylon Industrial:style=Normal",size=Size);
}

///////////////////////////////////////////////////////////////////////////

module pbar(Makerslide=0,Quanity=1) {
	for(b=[0:Quanity-1])
		translate([1,b*(Width+3),0]) bar(Makerslide); // two needed to mount p/s
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bar(mks=1) {
	difference() {
		color("cyan") cubeX([Length,Width,Thickness]);
		// p/s mounting holes
		translate([49.5,Width/2,-2]) rotate([0,0,0]) color("gray") cylinder(h=Thickness*2,r=screw4/2);
		color("black") hull() {
			translate([99.5,Width/2,-2]) rotate([0,0,0]) cylinder(h=Thickness*2,r=screw4/2);
			translate([97.5,Width/2,-2]) rotate([0,0,0]) cylinder(h=Thickness*2,r=screw4/2);
		}
		// countersink the mounting holes
		translate([50,Width/2,-14]) rotate([0,0,0]) color("red") cylinder(h=Thickness*2,r=screw4hd/2);
		color("plum") hull() {
			translate([99.5,Width/2,-14]) rotate([0,0,0]) cylinder(h=Thickness*2,r=screw4hd/2);
			translate([97.5,Width/2,-14]) rotate([0,0,0]) cylinder(h=Thickness*2,r=screw4hd/2);
		}
		translate([-30,0,0]) makerslide_mount(mks);
		// zip tie holes
		translate([5,Width+2,Thickness/2]) rotate([90,0,0]) color("salmon") cylinder(h=Thickness*2,r=screw5/2);
		translate([Length-5,Width+2,Thickness/2]) rotate([90,0,0]) color("blue") cylinder(h=Thickness*2,r=screw5/2);
	}
	//mks_mount_support(mks);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

module makerslide_mount(mks) {
	if(mks) {
		// makerslide mounting holes
		translate([Length/2+10,Width/2,-2]) color("gold") cylinder(h=Thickness*2,r=screw5/2);
		translate([Length/2-10,Width/2,-2]) color("pink") cylinder(h=Thickness*2,r=screw5/2);
		translate([Length/2+10,Width/2,Thickness/2]) color("lightgray") cylinder(h=Thickness*2,r=screw5hd/2);
		translate([Length/2-10,Width/2,Thickness/2]) color("black") cylinder(h=Thickness*2,r=screw5hd/2);
	} else {
		translate([Length/2,Width/2,-2]) color("gold") cylinder(h=Thickness*2,r=screw5/2);
		translate([Length/2,Width/2,Thickness/2]) color("lightgray") cylinder(h=Thickness*2,r=screw5hd/2);
		translate([Length/2-screw5hd/2,Width/2-screw5hd/2,Thickness/2]) color("black") cube([screw5hd,screw5hd,LayerThickness]);
	}
}

module mks_mount_support(mks) {
	if(mks) {
		translate([Length/2+10-screw5hd/2,Width/2-screw5hd/2,Thickness/2])
			color("lightgray") cube([screw5hd,screw5hd,LayerThickness]);
		translate([Length/2-10-screw5hd/2,Width/2-screw5hd/2,Thickness/2])
			color("black") cube([screw5hd,screw5hd,LayerThickness]);
	} else
		translate([Length/2-screw5hd/2,Width/2-screw5hd/2,Thickness/2]) color("black") cube([screw5hd,screw5hd,LayerThickness]);
}

//////////////// end of powersocket.scad /////////////////////////
