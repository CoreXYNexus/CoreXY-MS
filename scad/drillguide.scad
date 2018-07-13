//////////////////////////////////////////////////////////////////////////////
// drill guide 2020
//////////////////////////////////////////////////////////////////////////////
// created 4/6/2016
// last update 6/27/2016
//////////////////////////////////////////////////////////////////////////////
// 4/7/16 - added aversion to use on makerslide
// 4/13/16 - corrected distance between holes
// 6/24/16 - made so that offset determines length
//////////////////////////////////////////////////////////////////////////////
// A drill guide for 2020 to be able to eliminate the plastic brackets
// on the base section.  Drill both for 2040 or makerslide ends, one hold for 2020
//////////////////////////////////////////////////////////////////////////////
// vars
/////////////////////////////////////////////////////////////////////////////
screw5 = 5.6;
width = 30;
thickness = 5;
w2020 = 20.1;
bottom = 10;
offset = 20;//80;
length = offset + 25;
////////////////////////////////////////////////////////////////////////////////

drillguide();
//drillguide2();
//test(); // test print for fitting 2020

/////////////////////////////////////////////////////////////////////////////////

module drillguide() { //2020 channel
	difference() {
		cube([length,width,thickness+2]);
		translate([5,5,3]) cube([length,w2020,thickness]);
		translate([bottom+5,w2020/2+5,-5]) cylinder(h=20,r=screw5/2,$fn=100);
		translate([offset+bottom+5,w2020/2+5,-5]) cylinder(h=20,r=screw5/2,$fn=100);
	}
}

/////////////////////////////////////////////////////////////////////////////////

module drillguide2() { // to use on makerslide
	difference() {
		cube([length,width-10,thickness+2]);
		translate([5,-1,3]) cube([length,width+2,thickness]);
		translate([bottom+5,w2020/2,-5]) cylinder(h=20,r=screw5/2,$fn=100);
		translate([offset+bottom+5,w2020/2,-5]) cylinder(h=20,r=screw5/2,$fn=100);
	}
}

//////////////////////////////////////////////////////////////////////////////////

module test() { // test print for fitting 2020
	difference() {
		drillguide();
		translate([20,-2,-2]) cube([length+5,width+5,thickness*2]);
	}
}

//////////////////// end of drillguide.scad //////////////////////////////////////

