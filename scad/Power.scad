////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Power.scad - uses a pc style power socket with switch
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// created 7/4/2016
// last update 6/16/22
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// https://creativecommons.org/licenses/by-sa/4.0/
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 8/4/16	- Added cover
// 8/5/16	- adjusted cover & 2020 mounting holes
// 1/10/17	- Added colors for easier editing in preview and added mount for a power switch
// 1/11/17	- Added label to power switch mount
// 8/19/18	- OpenSCAD 2018.06.01 for $preview
// 5/10/19	- Added a rear cover for the power switch
// 5/11/19	- Added a power cover with rounded edges and square edges
// 5/16/19	- Merged power supply mount into here and renamed this file
// 5/28/19	- Added a housing version with seperate power plug and switch, added M5 countersinks to housing, modified
//			  the MMAX
//			  power supply mounts for the CXY-MSv1 corexy
// 7/24/19	- Adjusted PowerInletHousingCover() screw holes
// 6/21/20	- Added power supply mount for a Sunpower SP-180A 12vdc, uses M3 mountind screws on the bottom
// 8/4/20	- Renamed a few modules with a better name
// 8/25/20	- Removed wings on PowerInletHousing()
// 8/26/20	- PowerSwtch() can now have a specified label
// 8/27/20	- Changed to cartoon bold font, size 7, PowerInletHousing() has mounting screw holes and recess for the
//			  power socket
// 4/20/21	- Added toggle switch mount
// 4/22/21	- Adjusted some holes in the Power Inlet
// 12/25/21	- Fixed Meanwell RS-15-5 mount
// 6/15/22	- Added vars for MW RS155 hole positions
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NOTE: Version 0 uses Digi-Key Part number: CCM1666-ND : combined power socket and switch
//		 http://www.digikey.com/product-detail/en/te-connectivity-corcom-filters/1609112-3/CCM1666-ND/758835
//		 ---------------------------------------------------------------------------------------------------
//		 If the socket hole size changes, then the size & postions of the walls/wings & socket may need adjusting
//		 The power socket uses 3mm screws to mount, drill with 2.5mm and tap after installing the socket
//-------------------------------------------------------------------------------------------------------------
// 5vdc Power Supply: https://www.meanwell.com/webapp/product/search.aspx?prod=RS-15
// 24vdc Power Supply is in PS Meanwell LRS-350-24 Mount.scad; https://www.meanwell.com/productPdf.aspx?i=459
///////////////////////////////////////////////////////////////////////////////////////////////////////////
include <BOSL2/std.scad>
include <inc/screwsizes.scad>
include <inc/brassinserts.scad>
$fn = 100;
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// vars
Use3mmInsert=1;
UseLargeInsert=1;
SwitchSocketWidth=49;//39;	// socket hole width
SwitchSocketHeight=28;//27;	// socket hole height
SwitchLength=19.5;
SwitchWidth=13;
SwitchThickness=2;
SocketShiftLR=-4;//0; // move socket left/right
SocketShiftUD=0; // move socket up/down
PowerSupplyCoverClearance=1;
PowerSupplyCoverWidth=115+PowerSupplyCoverClearance;
PowerSupplyCoverHeight=50+PowerSupplyCoverClearance;
PowerSupplyCoverDepth=55;
PowerSupplyAdjust=2;
PowerSupplySideMountingScrewSpacing=25;
Length=113;
Width=13;
Thickness=10;
LayerThickness=0.4;
SocketPlugWidth=SwitchSocketWidth;
SocketPlugHeight=SwitchSocketHeight;
PS12Offest=81;
PS12Edge=10;
PS12Width=100;
ToggleSwitchLength=30;
TogglwSwitchWidth=16;
ToggleSwitchHeight=26;
ToggleOffsetHoleSize=22;
Clearance=0.7;  // clearance for hole
MeanWellRS155Offset=40.1;
MeanWellrs155EndOffset=11.5;
TabDiameter=20;
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//Power(1);// Horizontal(0) Vertical(1) Toggle; flip=0;Makerslide=1,PBQuantiy=2,Version=0
//PowerInlet(0,0);
//testfit();	// print part of it to test fit the socket & 2020
//PowerSwitch(0,"POWER");		// 1st arg: flip label; 2nd arg:Text Label, default="POWER"
//translate([40,0,0]) PowerSwitch(0," 5VDC");
//powersupply_cover();
//powersupply_cover_v2();
////PowerSupplyMount(1,2); // old mount
//PowerInletHousing(1; // separate switch
//PowerInletHousing(0); // built in switch
//PowerInletHousingCover(); // test fit cover to power inlet housing
MeanWellRS155Mount();
//PowerToggleSwitch(1);

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module Power(VerticalToogle=0,Version=0) {
	translate([0,-12,0]) PowerInletHousing(Version);
	translate([0,-5,45]) rotate([180,0,0]) PowerInletHousingCover();
	translate([-50,-45,0]) PowerToggleSwitch(VerticalToogle);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerToggleSwitch(Vertical=1,Flip=0,HoleSize=12+Clearance) {
	difference() {
        union() {
            color("cyan") cuboid([ToggleSwitchLength+10,TogglwSwitchWidth+10,4],rounding=2,p1=[0,0],except_edges=TOP);
			translate([0,0,0]) color("blue")
				cuboid([5,TogglwSwitchWidth+10,ToggleSwitchHeight+6],rounding=2,p1=[0,0]); // left wall
			translate([ToggleSwitchLength+5,0,0]) color("salmon")
				cuboid([5,TogglwSwitchWidth+10,ToggleSwitchHeight+6],rounding=2,p1=[0,0]); // right wall
			translate([0,0,0]) color("tan")
				cuboid([ToggleSwitchLength+10,5,ToggleSwitchHeight+6],rounding=2,p1=[0,0]); // rear wall
			translate([0,TogglwSwitchWidth+5,0]) color("gray")
				cuboid([ToggleSwitchLength+10,5,ToggleSwitchHeight+6],rounding=2,p1=[0,0]); // rear wall
			translate([0,-22,0]) ToggleSwitchExtrusionMount(Flip,ToggleSwitchLength,Vertical);
		}
		translate([(ToggleSwitchLength+10)/2,(TogglwSwitchWidth+10)/2,-3]) color("red")
			cylinder(h=10,d=HoleSize); // switch hole
		if(Vertical)
			translate([2.5,28,0]) rotate([0,0,-90]) switch_label(Flip,"POWER",6,6);
		else
			translate([2.5,3,0]) switch_label(Flip,"POWER",6);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ToggleSwitchExtrusionMount(Flip=0,Width,Vertical=0) {
	if(Vertical) {
		difference() {	
			translate([-20,22,0]) color("green") cuboid([TogglwSwitchWidth+10,26,5],rounding=2,p1=[0,0]);
			translate([-10,35,-2]) color("red") cylinder(h=10,d=screw5);
			translate([-10,35,-4]) color("blue") cylinder(h=5,d=screw5hd);
		}
		translate([-10,35,1]) color("purple") cylinder(h=LayerThickness,d=screw5hd);
	} else {
		difference() {	
			color("green") cuboid([Width,27,5],rounding=2,p1=[0,0]);
			translate([10,10,-2]) color("red") cylinder(h=10,d=screw5);
			translate([30,10,-2]) color("blue") cylinder(h=10,d=screw5);
			translate([10,10,-4]) color("red") cylinder(h=5,d=screw5hd);
			translate([30,10,-4]) color("blue") cylinder(h=5,d=screw5hd);
		}
		translate([10,10,1]) color("pink") cylinder(h=LayerThickness,d=screw5hd);
		translate([30,10,1]) color("white") cylinder(h=LayerThickness,d=screw5hd);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerInlet(Version=0,Cvr=1) {
	translate([0,-12,0]) PowerInletHousing(Version);
	if(Cvr) translate([0,-5,45]) rotate([180,0,0]) PowerInletHousingCover();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MeanWellRS155Mount() { // meanwell RS-15-5
	difference() {
		union() {
			color("cyan") cuboid([50,60,4],rounding=2,p1=[0,0]);
			// printing corner support
			translate([2,2,0]) color("red") cyl(h=LayerThickness,d=TabDiameter);
			translate([48,2,0]) color("blue") cyl(h=LayerThickness,d=TabDiameter);
			translate([2,58,0]) color("gray") cyl(h=LayerThickness,d=TabDiameter);
			translate([48,58,0]) color("lightgray") cyl(h=LayerThickness,d=TabDiameter);
		}
		translate([10,10,-2]) color("red") cylinder(h=10,d=screw5);
		translate([10,10,-4]) color("blue") cylinder(h=5,d=screw5hd);
		translate([10,50,-2]) color("blue") cylinder(h=10,d=screw5);
		translate([10,50,-4]) color("red") cylinder(h=5,d=screw5hd);
		translate([40,MeanWellrs155EndOffset,0]) {
			translate([0,0,2]) color("plum") cyl(h=15,d=screw3);
			translate([0,0,5]) color("black") cyl(h=5,d=screw3hd);
			translate([0,MeanWellRS155Offset,2]) color("black") cyl(h=15,d=screw3);
			translate([0,MeanWellRS155Offset,5]) color("plum") cyl(h=5,d=screw3hd);
		}
	}
	translate([10,10,1]) color("white") cylinder(h=LayerThickness,d=screw5hd); // M5 CS support
	translate([10,50,1]) color("gray") cylinder(h=LayerThickness,d=screw5hd); // M5 CS support
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
	translate([PowerSupplyCoverWidth/1.2,54.5,PowerSupplyCoverDepth/6]) rotate([90,0,180])
		printchar("DANGER HIGH VOLTAGE",1.5,4);
	difference() {
		translate([0,0,0]) color("red") cube([2,PowerSupplyCoverHeight+4,PowerSupplyCoverDepth]);
		pwrc_supply_screws(screw4); // mount it to the power supply
	}
	difference() {
		translate([PowerSupplyCoverWidth+2,0,0]) color("plum") cube([2,PowerSupplyCoverHeight+4,PowerSupplyCoverDepth]);
		pwrc_supply_screws(screw4); // mount it to the power supply
	}
	translate([0,0,0]) color("gray") cuboid([PowerSupplyCoverWidth+4,2,PowerSupplyCoverDepth],rounding=1,p1=[0,0]);
	translate([0,PowerSupplyCoverHeight+2,0]) color("lightgray") cube([PowerSupplyCoverWidth+4,2,PowerSupplyCoverDepth-14]);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module powersupply_cover() { // rounded version
	if($preview) {  // verify inside is the right size
		%translate([14,4,5]) cube([5,PowerSupplyCoverHeight,5]);
		%translate([4,14,5]) cube([PowerSupplyCoverWidth,5,5]);
	}
	difference() {
		color("cyan") cuboid([PowerSupplyCoverWidth+8,PowerSupplyCoverHeight+8,4],rounding=1,p1=[0,0]); 
		translate([113,PowerSupplyCoverHeight/2+7,-2]) rotate([0,0,180]) pwr_supply_cover_vents(18); // ventilation
	}
	difference() {
		translate([0,0,0]) color("red") cuboid([4,PowerSupplyCoverHeight+8,PowerSupplyCoverDepth],rounding=1,p1=[0,0]);
		pwrc_supply_screws(screw4); // mount it to the power supply
	}
	difference() {
		translate([PowerSupplyCoverWidth+4,0,0]) color("plum")
			cuboid([4,PowerSupplyCoverHeight+8,PowerSupplyCoverDepth],rounding=1,p1=[0,0]);
		pwrc_supply_screws(screw4); // mount it to the power supply
	}
	translate([0,0,0]) color("gray") cuboid([PowerSupplyCoverWidth+8,4,PowerSupplyCoverDepth],rounding=1,p1=[0,0]);
	translate([0,PowerSupplyCoverHeight+4,0]) color("lightgray")
		cuboid([PowerSupplyCoverWidth+8,4,PowerSupplyCoverDepth-14],rounding=1,p1=[0,0]);
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

module PowerInletHousing(Version=0,Screw=Yes3mmInsert(Use3mmInsert,UseLargeInsert),ChangeSocketMountingOffset=1) {
	difference() {
		union() {
			color("blue") cuboid([SwitchSocketWidth+40,SwitchSocketHeight+40,5],rounding=2,p1=[0,0]); // base
		translate([0,SwitchSocketHeight+35,0]) color("red")
				cuboid([SwitchSocketWidth+40,5,40],rounding=2,p1=[0,0]); // top wall
		translate([0,19,0]) color("black") cuboid([5,SwitchSocketHeight+21,40],rounding=2,p1=[0,0]); // left wall
		translate([SwitchSocketWidth+35,19,0]) color("white")
				cuboid([5,SwitchSocketHeight+21,40],rounding=2,p1=[0,0]); // right wall
		}
		cover_screw_holes(Screw);
		translate([SwitchSocketWidth-30,9,-2]) color("green") cylinder(h=10,r=screw5/2); // mounting hole
		translate([SwitchSocketWidth+25,9,-2]) color("plum") cylinder(h=10,r=screw5/2); // mounting hole
		translate([SwitchSocketWidth-30,9,-9]) color("white") cylinder(h=10,d=screw5hd); // countersink
		translate([SwitchSocketWidth+25,9,-9]) color("lightgreen") cylinder(h=10,d=screw5hd); // countersink
		// socket hole
		if(Version==0) {
			translate([SwitchSocketWidth/2+SocketShiftLR,SwitchSocketHeight/2+14+SocketShiftUD,-2]) color("cyan")
				cube([SwitchSocketWidth,SwitchSocketHeight,10]);
			translate([SwitchSocketWidth/2+SocketShiftLR-4,SwitchSocketHeight/2+14+SocketShiftUD,2]) color("red")
				cube([SwitchSocketWidth+8,SwitchSocketHeight,10]);
			// mounting screws
			translate([SwitchSocketWidth+SocketShiftLR,SwitchSocketHeight+SocketShiftUD-(4.5+ChangeSocketMountingOffset),-3]) color("red")
				cylinder(h=10,d=Screw);
			translate([SwitchSocketWidth+SocketShiftLR,SwitchSocketHeight*2+SocketShiftUD+(4.5+ChangeSocketMountingOffset),-3]) color("cyan")
				cylinder(h=10,d=Screw);
		} else {
			translate([SwitchSocketWidth/2+SocketShiftLR-10,SwitchSocketHeight/2+14+SocketShiftUD,-2]) color("cyan")
				cube([SocketPlugWidth,SocketPlugHeight,10]); // plug socket
			translate([SwitchSocketWidth/2+SocketShiftLR+36,SwitchSocketHeight/2+14.2+SocketShiftUD,-2]) color("pink")
				cube([SwitchWidth,SwitchHeight,8]); // switch
		}
	}
	translate([SwitchSocketWidth-40,2,1]) color("gray") cube([SwitchSocketWidth+30,15,LayerThickness]); // screw5 support
	coverscrewholes(Screw);
}

//////////////////////////////////////////////////////////////////

module screwholesupport() {
	color("plum") cube([screw5hd+1,screw5hd+1,LayerThickness]);
}

module coverscrewholes(Screw=screw3) {
	difference() {
		translate([5,40,20]) color("blue") cylinder(h=20,d=Screw*2); // left
		translate([6.5,35,14]) rotate([0,-45,0]) color("red") cube([10,10,5]);
		cover_screw_holes(Screw);
	}
	difference() {
		translate([SwitchSocketWidth+35,40,20]) color("red") cylinder(h=20,d=Screw*2); // right
		translate([SwitchSocketWidth+26,35,22]) rotate([0,45,0]) color("blue") cube([10,10,5]);
		cover_screw_holes(Screw);
	}
	difference() {
		translate([SwitchSocketWidth-6,62,20]) color("white") cylinder(h=20,d=Screw*2); // top screw hole
		translate([SwitchSocketWidth-11,53,23]) rotate([-45,0,0]) color("green") cube([10,10,5]);
		cover_screw_holes(Screw);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////

module cover_screw_holes(Screw=screw3) {
	translate([5,40,24]) color("white") cylinder(h=40,d=Screw); // left
	translate([SwitchSocketWidth+35,40,24]) color("gray") cylinder(h=40,d=Screw); // right
	translate([SwitchSocketWidth-6,62,24]) color("hotpink") cylinder(h=40,d=Screw); // top screw hole
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

module PowerInletHousingCover(Screw=screw3) {
	difference() {
		translate([0,15,40]) color("cyan") cuboid([SwitchSocketWidth+40,SwitchSocketHeight+27,5],rounding=2,p1=[0,0]); // base
		cover_screw_holes(Screw);
		if(Screw==screw3) translate([0,0,0]) CoverScrewContersink();
	}
	difference() {
		translate([0,13.8,25]) color("red") cuboid([SwitchSocketWidth+40,5,20],rounding=2,p1=[0,0]); // base
		color("white") hull() {
			translate([SwitchSocketWidth-6,25,30]) rotate([90,0,0]) cylinder(h=15,d=10);
			translate([SwitchSocketWidth-6,25,25]) rotate([90,0,0]) cylinder(h=15,d=10);
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module CoverScrewContersink() {
	translate([5,40,43]) color("blue") hull() {
		cylinder(h=0.5,d=screw3);
		translate([0,0,2]) cylinder(h=0.5,d=7);
	}
	translate([SwitchSocketWidth+35,40,43]) color("black") hull() {
		cylinder(h=0.5,d=screw3);
		translate([0,0,2]) cylinder(h=0.5,d=7);
	}
	translate([SwitchSocketWidth-6,62,43]) color("plum") hull() {
		cylinder(h=0.5,d=screw3);
		translate([0,0,2]) cylinder(h=0.5,d=7);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module PowerSwitch(Flip=0,Text="POWER") {
	difference() {  // switch front and switch mounting hole
		color("cyan") cuboid([SwitchLength+15,SwitchWidth+15,5],rounding=2,p1=[0,0]);
		translate([SwitchLength/2-2,SwitchWidth/2+1,-2]) color("pink") cube([SwitchLength,SwitchWidth,8]);
		translate([SwitchLength/2-3.5,SwitchWidth/2+1,SwitchThickness]) color("red") cube([SwitchLength+3,SwitchWidth,8]);
		translate([0,2,0]) switch_label(Flip,Text);
	}
	translate([0,-2,0]) color("blue") cuboid([5,SwitchLength+11,SwitchWidth+25],rounding=2,p1=[0,0]); // left wall
	translate([SwitchLength+10,-2,0]) color("salmon")
		cuboid([5,SwitchLength+11,SwitchWidth+25],rounding=2,p1=[0,0]); // right wall
	translate([SwitchLength-18,SwitchWidth+10.5,0]) color("tan")
		cuboid([SwitchLength+13,5,SwitchWidth+15],rounding=2,p1=[0,0]); // rear wall
	difference() {
		translate([SwitchLength-18,-2,0]) color("brown")
			cuboid([SwitchLength+13,5,SwitchWidth+25],rounding=2,p1=[0,0]); // top wall
		translate([0,2,0]) switch_label(Flip,Text);
	}
	translate([0,0,33]) color("plum") cuboid([SwitchLength+15,SwitchWidth+15,5],rounding=2,p1=[0,0]); // rear cover
	translate([0,-22,0]) sw_mount(Flip,SwitchLength+15,Text);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sw_mount(Flip=0,Width,Text) {
	difference() {
		color("green") cuboid([Width,27,5],rounding=2,p1=[0,0]);
		translate([10,10,-2]) color("red") cylinder(h=10,d=screw5);
		translate([10,10,-4]) color("blue") cylinder(h=5,d=screw5hd);
		translate([25,10,-2]) color("blue") cylinder(h=10,d=screw5);
		translate([25,10,-4]) color("red") cylinder(h=5,d=screw5hd);
		translate([0,24,0]) switch_label(Flip,Text);
	}
	translate([5,5,1]) color("black") cube([27,screw5*2,LayerThickness]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module switch_label(Flip=0,Text,Height=2,FontSize=7) {
	echo(Text);
	if(!Flip) translate([5.5,-0,1]) rotate([180,0,0]) printchar(Text,Height,FontSize);
	else translate([29,-2,1]) rotate([0,180,0]) printchar(Text,Height,FontSize);
}

//////////////////////////////////////////////////////////////////////////////////////////////////

module printchar(String,Height=2,FontSize=14,Font="Balloon Bd BT:style=Bold") { // print something
	color("plum") linear_extrude(height = Height) text(text = String, font=Font, size=FontSize);
}

///////////////////////////////////////////////////////////////////////////

module PowerSupplyMount(Makerslide=0,Quanity=1) {
	for(b=[0:Quanity-1])
		translate([1,b*(Width+3),0]) bar(Makerslide); // two needed to mount p/s
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////

module bar(mks=1) {
	difference() {
		color("cyan") cuboid([Length,Width,Thickness],p1=[0,0]);
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
		translate([Length/2-screw5hd/2,Width/2-screw5hd/2,Thickness/2]) color("black")
			cube([screw5hd,screw5hd,LayerThickness]);
	}
}

module mks_mount_support(mks) {
	if(mks) {
		translate([Length/2+10-screw5hd/2,Width/2-screw5hd/2,Thickness/2])
			color("lightgray") cube([screw5hd,screw5hd,LayerThickness]);
		translate([Length/2-10-screw5hd/2,Width/2-screw5hd/2,Thickness/2])
			color("black") cube([screw5hd,screw5hd,LayerThickness]);
	} else
		translate([Length/2-screw5hd/2,Width/2-screw5hd/2,Thickness/2]) color("black")
		cube([screw5hd,screw5hd,LayerThickness]);
}


//////////////// end of power.scad ///////////////////////////////////////////////////////////////////////////////////
