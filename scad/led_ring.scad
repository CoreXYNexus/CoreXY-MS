//******************************************************************************
// Description:
// 
// A holder for LED ring
//
// default size 80mm
//
//
// Copyright CC-BY-SA Bob Cousins 2011
//
// Revision History:
//
// v1 Initial version. Based on http://www.thingiverse.com/thing:7484
//******************************************************************************
///////////////////////////////////////////////////////////////////////////////////////////////////////////
// changes by Stephen Castello:
// 1/4/22	- Added colors, BOSL2, commented ref() and test(). move some code and my pretty stuff
///////////////////////////////////////////////////////////////////////////////////////////////////////////
include <bosl2/std.scad>
///////////////////////////////////////////////////////////////////////////////////////////////////////////
$fa=0.01;
$fn=100; //0;
//$fs=0.5;
///////////////////////////////////////////////////////////////////////////////////////////////////////////

draw(70);
//test();

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module draw(Diameter)
{
	led_ring_holder(Diameter);
	fixing_tabs(Diameter);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////

module led_ring_holder(diam)
{
	height = 2;
	outer_r = diam/2 + 2;
    
	difference () {
		union () {
			translate ([0,0,0]) color("cyan") cyl(r=outer_r, h=height*3,rounding=2);
		}
		translate ([0,0,height]) color("red") cylinder (r1=diam/2, r2=diam/2-2, h=height+0.1, center=true);
		translate ([0,0,0]) color("pink") cylinder (r=diam/2, h=height, center=true);
		translate ([0,0,0]) color("blue") cylinder (r=diam/2-2, h=height*3+1, center=true);
		translate ([-diam/2,0,0])  cuboid([diam/2,38,10]);
		// slot for wires            
		rotate ([0,0,-20]) translate ([diam/2,0, 1.5+2/2]) color("gray") cuboid([6, 3, 2]);      
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
// for original
module fixing_tabs(diam)
{
	height = 2;
	outer_r = diam/2 + 2;
	tab_x = 15;
	tab_y = 15;
	drill_d = 6;
	fix_x = (80 + 16)/2;

	difference () {
		union () {
			if (diam <= 80) {
				difference() {
					translate ([diam/2-2, -tab_y/2, -height*3/2]) color("lightgray")
						cuboid([fix_x-diam/2 + tab_x/2+2, tab_y, height*3],rounding=2,p1=[0,0]);
					translate ([0,0,height]) color("red") cylinder (r1=diam/2, r2=diam/2-2, h=height+0.1, center=true);
					translate ([0,0,0]) color("pink") cylinder (r=diam/2, h=height, center=true);
				}
			} else {
				difference() {
					translate ([diam/2 + tab_x/2,0,0]) color("lightgray")
						cuboid([tab_x+4, tab_y, height*3],rounding=2);
					translate ([0,0,height]) color("red") cylinder (r1=diam/2, r2=diam/2-2, h=height+0.1, center=true);
					translate ([0,0,0]) color("pink") cylinder (r=diam/2, h=height, center=true);
				}
			}
		}
    
		if (diam <= 80) {
			translate ([fix_x, 0, 0]) color("khaki") cyl(r=drill_d/2, h=height*3+1);
		} else {
			translate ([fix_x+(diam-80)/2, 0, 0]) color("khaki") cyl(r=drill_d/2, h=height*3+1);
		}          
	}          
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
module ref ()
{
  translate ([9,0,10])
  translate ([9,0,-5])
  import_stl ("C:/BitsFromBytes/things/7484-led-ring/led_ring_holder_01.stl");
}

module test ()
{
// original STL, for reference
//  ref ();
  
  for (i=[0:3])
  {
    translate ([0,0,-i*10])
    {
      led_ring_holder(60+i*10);
      fixing_tabs(60+i*10);
    }
  }
}
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
