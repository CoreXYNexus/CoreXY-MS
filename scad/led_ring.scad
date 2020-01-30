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

$fa=0.01;
$fn=0;
//$fs=0.5;

module ref ()
{
  translate ([9,0,10])
//  translate ([9,0,-5])
  import_stl ("C:/BitsFromBytes/things/7484-led-ring/led_ring_holder_01.stl");
}

module led_ring_holder(diam)
{
  height = 2;
  outer_r = diam/2 + 2;
    
  difference ()
  {
    union ()
    {
      translate ([0,0,0])
        cylinder (r=outer_r, h=height*3, center=true);
    }
    
    translate ([0,0,height])
      cylinder (r1=diam/2, r2=diam/2-2, h=height+0.1, center=true);

    translate ([0,0,0])
      cylinder (r=diam/2, h=height, center=true);

    translate ([0,0,0])
      cylinder (r=diam/2-2, h=height*3+1, center=true);
      
    translate ([-diam/2,0,0])
      cube ([diam/2,38,10], center=true);
      
    // slot for wires            
    rotate ([0,0,-20])
      translate ([diam/2,0, 1.5+2/2])
        cube ([6, 3, 2], center=true);      
  }
}

// for original
module fixing_tabs(diam)
{
  height = 2;
  outer_r = diam/2 + 2;
  
  tab_x = 15;
  tab_y = 15;
  drill_d = 6;
  
  fix_x = (80 + 16)/2;

  difference ()
  {
    union ()
    {
      if (diam <= 80)
      {
        translate ([diam/2, -tab_y/2, -height*3/2])
          cube ([fix_x-diam/2 + tab_x/2, tab_y, height*3], center=false);
      }
      else
      {
        translate ([diam/2 + tab_x/2,0,0])
          cube ([tab_x, tab_y, height*3], center=true);
      }
      
    }
    
    if (diam <= 80)
    {
      translate ([fix_x, 0, 0])
        cylinder (r=drill_d/2, h=height*3+1, center=true);
    }
    else
    {
      translate ([fix_x+(diam-80)/2, 0, 0])
        cylinder (r=drill_d/2, h=height*3+1, center=true);
    }          
  }          
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

module draw()
{
  //Original part

  diam = 70;
  
  led_ring_holder(diam);
  fixing_tabs(diam);
}

draw();
//test();
