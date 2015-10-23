include <measured_numbers.scad>
include <util.scad>
include <design_numbers.scad>
use <Nema17_and_Ramps_and_bearings.scad>
use <Gears.scad>

module fish_ring(){
  $fn = 15;
  // Measured numbers
  hol_h  = 1.57;
  ins_ro = 4.90/2;
  edg_r  = 6.50/2;
  lar_ri = 3.00/2;
  hol_r1 = 5.86/2;
  hol_r2 = 5.42/2;
  trdist = cdist + lar_ro;
  // Bring action point to origo
  translate([0,-ins_ri,0])
  difference(){
    union(){
      color("black")
        cylinder(r=ins_ro, h=ins_h, center=true);  // Inside ring (cheramic)
      color("grey")
        cylinder(r=edg_r, h=edg_h, center=true);
      translate([0,0,-edg_h/2])
      color("grey")
      linear_extrude(height=edg_h, slices=1)
        polygon(points = [tangent_point(edg_r, [0,-trdist]),
                          tangent_point_3(edg_r, [0,-trdist]),
                          [0,-trdist]],
                paths = [[0,1,2]]);
      translate([0,-cdist,0]){
        color("black")
          translate([0,0,lar_h/4])
          cylinder(r=lar_ro, h=lar_h, center=true);
        color("grey")
          cylinder(r=hol_r1, h=edg_h, center=true);
        color("grey")
          cylinder(r=hol_r2, h=hol_h-edg_h/2);
      }
    }
    // The two holes (ceramic and lar ring)
    cylinder(r=ins_ri, h=ins_h+2, center=true);
    translate([0,-cdist,0])
      cylinder(r=lar_ri, h=lar_h*2, center=true);
  }
}
//fish_ring();

module placed_fish_rings(){
  for(i=[0,1,2]){
    rotate([0,0,120*i]){
      for(k=[0,1])
        mirror([k,0,0])
          translate(Line_contact_abc_xy
            + [0,0, Line_contacts_abcd_z[i] + ins_ri + ins_ri/sqrt(2)])
          rotate([90,0,fish_ring_abc_rotation])
          translate([-ins_ri/sqrt(2),0,0])
          mirror([0,0,1])
          fish_ring();
    }
  }
  
  // D-lines' fish rings
  for(i=[0,1,2]){
    rotate([0,0,120*i])
      translate(Line_contact_d_xy + [0, 0, Line_contacts_abcd_z[D]])
      rotate([fish_ring_d_rotation,0,0])
      fish_ring();
  }
}
placed_fish_rings();


//** bottom_plate start **//

// Assumes children(0) is centered in xy-plane
// A little odd that reference translation is along y...
// Used for XY and Z motors
// Needed here to get screw holes right
module four_point_translate(){
  radius = Four_point_five_point_radius;
  for(i=[120:120:360]){
    rotate([0,0,i]) translate([0,radius,0]) children(0);
  }
}

// Needed here to get screw holes right
module extruder_motor_translate(extruder_twist = 12){
  radius = Four_point_five_point_radius + 5;
  translate([0, radius, -Nema17_screw_hole_dist/2 // z-center screwhole
                        +Bottom_plate_thickness/2])
    rotate([0, 0, extruder_twist])
      translate([0, -Nema17_cube_height, 0])
        rotate([90,0,0])
          translate([0, 0, -3*Nema17_cube_height/2 - 2]) children(0);
}

// The thing separating bearings on center axis of bottom plate
module lock(r1, r2, height){
  difference(){
    cylinder(r=r2, h=height);
    translate([0,0,-1])
      cylinder(r=r1, h=height+2);
  }
}
//lock(Lock_radius_1, Lock_radius_2, Lock_height);

module bottom_plate(){
  // Global variables renamed short
  cw  = Nema17_cube_width;
  th  = Bottom_plate_thickness; 
  bpr = Bottom_plate_radius;
  bd  = Bearing_608_bore_diameter; 
  bw  = Bearing_608_width; 
  swh = Sandwich_height;
  gap = Sandwich_gap;

  difference(){
    union(){
      // Largest possible triangular plate
      eq_tri(Full_tri_side, th);
      // Circular bottom plate
      cylinder(r=bpr, h = th);

      // Sandwich stick
      cylinder(r=bd/2+0.16,
               h=Line_contacts_abcd_z[A]+swh-Snelle_height/2
                 + 5 // for putting some kind of top lock mechanism
                 );

      // The bottom lock
      cylinder(r=Lock_radius_2, h=th + Bottom_plate_sandwich_gap);

      // Mounting towers for abc fish rings
        rotate(30, [0, 0, 1])
               for ( i = [0 : 5] ){
                  rotate( i * 60, [0, 0, 1])
                    translate([0,95,10]){
                        rotate(90 , [0,0,1])
                            difference(){
                                translate([0,0,0])
                                //cylinder(h=100, r=5);
                                 #cube([12,5.5,Line_contacts_abcd_z[i] - ins_ri]);
                                rotate([0,90,0]){
                                    translate([-1,0,-6]){
                                        cylinder(h=12, r=2);
                                    }
                                }
                            }
                        }
                }
        
        /*
      for(i=[0,1,2]){
        rotate([0,0,120*i]){
          for(k = [0, 1]){
            mirror([k,0,0]){
              translate(Line_contact_abc_xy)
                rotate([0,0,fish_ring_abc_rotation])
                translate([-6-ins_ri , -edg_h/2+0.01,0])
                cube([12,5.5,Line_contacts_abcd_z[i] - ins_ri]);
            }
          }
        }
      }*/

      // Measurment points
      for(i=[0,1,2]){
        rotate([0,0,120*i]){
          translate(Line_action_point_abc_xy + [-2,-2,0])
            cube([4,4,Line_contacts_abcd_z[i]-2]);
          translate(Line_action_point_abc_xy
                   + [0,0,Line_contacts_abcd_z[i]-2])
            sphere(r=2);
        }
      }
    } // End union

    //*** ANTIMATERIA STARTS HERE ***//

    // top fastening sandwich stick
    for(k=[1,-1])
     translate([k*2,0,Line_contacts_abcd_z[A]+swh-Snelle_height/2+2.5])
        rotate([90,0,0])
        cylinder(r=1, h=10, center=true);

    // Screw holes for abc Nema
    translate([0, 0, -1]){
      four_point_translate()
        #Nema17_schwung_screw_holes(M3_diameter, th+2);
      four_point_translate()
        translate([0,0,th-2.5])
          #Nema17_screw_holes(M3_head_diameter, th+2);
    }

    // Tracks to put fish rings in
    placed_fish_rings();

    // Mounting space for d fish_rings  
    big=5*th;
    for(i=[0,1,2]){
      rotate([0,0,120*i])
        translate(Line_contact_d_xy + [0, 0, Line_contacts_abcd_z[D]]){
          rotate([fish_ring_d_rotation-90,0,0])
            translate([-3.3,-4.1 - edg_h/2 + 0.05,-big/2])
            cube([6.6,4.1,big]); // Block to put fish ring in
          rotate([fish_ring_d_rotation-180,0,0])
            translate([0,ins_ri+cdist,0])
            cylinder(r=M3_diameter/2, h=big, center=true);//Hole for M3
          rotate([fish_ring_d_rotation-180,0,0])
            translate([0,ins_ri+cdist,4])
            cylinder(r=M3_head_diameter/2, h=big);//M3 screw head hole
        }
    }

    // Mounting holes for abc fish rings
    // rotations and translations synced with placed_fish_rings
    for(i=[0,1,2]){
      rotate([0,0,120*i]){
        for(k=[0,1]){
          mirror([k,0,0]){
            translate(Line_contact_abc_xy
              +[0,0,Line_contacts_abcd_z[i] + ins_ri + ins_ri/sqrt(2)])
              rotate([90,0,fish_ring_abc_rotation]){
                translate([-ins_ri/sqrt(2),0,0])
                  translate([0,-cdist-ins_ri,0]){
                    cylinder(r=M3_diameter/2+0.3, h = 25, center=true);
                  }
              }
          }
        }
      }
    }

    // Hole for extruder motor
   /* 
    extruder_motor_translate(Extruder_motor_twist)
      scale(1.01) // Leave 1% extra space, don't need tight fit
      Nema17();
    */

    // Middle hole for ABCD-motors
    translate([0, 0, -Big+Nema17_ring_height])
      four_point_translate(){
        union(){
        cylinder(r = Nema17_ring_diameter/2, h = Big);
        translate([0,0,Big-0.1])
          cylinder(r1 = Nema17_ring_diameter/2,
                   r2 = Nema17_ring_diameter/2 - 5, h = 6);
        }
      }

    // Place holes exaclty like punched_cube is placed when rendering
    // From placed_extruder
    rotation = Big_extruder_gear_rotation;
    extruder_motor_twist = Extruder_motor_twist;
    // Added only here
    translate([0,0,-Big/2 + Bottom_plate_thickness -1.5])
    mirror([0,0,1])
    // From translated_extruder_motor_and_drive
    extruder_motor_translate(extruder_motor_twist)
      // From Nema17_with_drive
      translate([0,0,Nema17_shaft_height-Small_extruder_gear_height+1]){
        // drive_support is called by assembled_drive only
        //from assembled_drive
        translate([ // Center 623 in x-dim 
            -Bearing_623_outer_diameter/2 -5 //match 5 in drive_support
            // Take rotation into account x-dim
            + sin(rotation)*Pitch_difference_extruder,
            // Take rotation into account y-dim (place hobb on edge)
            -cos(rotation)*Pitch_difference_extruder
            - Hobb_from_edge,
            // Big extruder gear placed below this structure, z-dim
            Big_extruder_gear_height + 0.2]) // Big gear |.2mm| support
          for(k = [0,Drive_support_thickness//Bring to same z
              + Bearing_623_width
              + 0.2 // 623 |.2mm| Hobb |.2mm| 623
              + Hobbed_insert_height
              + 0.2])
            translate([0,0, k])
              mirror([0,0,k])
              // Found in drive_support()
              translate([0,
                  Drive_support_height,
                  -Hobbed_insert_height - 1*Bearing_623_width])
              Drive_support_holes(Drive_support_v);
      }

    // Screw holes for extruder motor mounting screws
    rotate([0,0,Extruder_motor_twist])
      translate([-18.5,77,Bottom_plate_thickness/2])
      rotate([-90,0,0])
      cylinder(h=Big, r=2.0);
    rotate([0,0,Extruder_motor_twist])
      translate([-50,77,Bottom_plate_thickness/2])
      rotate([-90,0,0])
      cylinder(h=Big, r=2.0);
    rotate([0,0,Extruder_motor_twist])
      translate([-18.5,7,Bottom_plate_thickness/2])
      rotate([-90,0,0])
      cylinder(h=Big, r=M3_diameter/2+0.1);
    rotate([0,0,Extruder_motor_twist])
      translate([-50,7,Bottom_plate_thickness/2])
      rotate([-90,0,0])
      cylinder(h=Big, r=M3_diameter/2+0.1);

    rotate([0,0,Extruder_motor_twist])
      translate([-18.5,11,Bottom_plate_thickness/2])
      rotate([-90,0,0])
      cube([9,9,30], center=true);

    rotate([0,0,Extruder_motor_twist])
      translate([-50,11,Bottom_plate_thickness/2])
      rotate([-90,0,0])
      cube([9,9,30], center=true);

    // Dig out filament hole in sandwich stick and base.
    translate([0, 0, -1]) cylinder(r = 2.3, h = Big);

    // Letters for easier identification
    translate([0,0,-1]){
      rotate([0,0,120*A+7])
        translate(Line_action_point_abc_xy + [0,-8,th])
        scale([1,1,1.5])
        linear_extrude(height=2)
        text("A",halign="center",valign="center");
      rotate([0,0,120*B+7])
        translate(Line_action_point_abc_xy + [0,-8,th])
        scale([1,1,1.5])
        linear_extrude(height=2)
        text("B",halign="center",valign="center");
      rotate([0,0,120*C+7])
        translate(Line_action_point_abc_xy + [0,-8,th])
        scale([1,1,1.5])
        linear_extrude(height=2)
        text("C",halign="center",valign="center");
    }

  }
}
//rotate([0,0,15])
bottom_plate();

//** bottom_plate end **//

// Sandwich is defined in Gears.scad
// Motors are defined in Nema17_and_Ramps_and_bearings.scad


//** extruder start **//

module Drive_support_holes(v=Drive_support_v){
    rotate([-90,0,0]){
      for(k=[1,-1])
        translate([k*Support_rx+v[0]/2,
            -v[2]/2 + Drive_support_thickness/2,
            -Big/2])
          M3_screw(h=Big);
    }
}

module punched_cube(v){
  difference(){
    cube(v);
    Drive_support_holes(v);
  }
}
//punched_cube(Drive_support_v);

// height of the tower depends on big extruder gear rotation
// Used in assembled_drive in placed_parts.scad
module drive_support(flag){
  th = Drive_support_thickness;
  difference(){
    cube([Bearing_623_outer_diameter + 14,
        Drive_support_height,
        th]);
    // Hole for bearings supporting hobbed insert screw
    translate([Bearing_623_outer_diameter,Hobb_from_edge,-Big/2])
      M3_screw(Big);
    translate([Bearing_623_outer_diameter/2 + 5,
        Hobb_from_edge,
        -1])
      cylinder(r=Bearing_623_outer_diameter/2, h=Big);
    // Hole for support bearing M3
    //translate([Hobbed_insert_diameter/2
    //           + Bearing_623_outer_diameter
    //           + Extruder_filament_opening,
    //    Hobb_from_edge,-1])
    translate([Bearing_623_outer_diameter + 5 // Center of hobb x-dir
               + Hobbed_insert_diameter/2
               + Extruder_filament_opening,
        Hobb_from_edge,-1])
      M3_screw(Big);
    // Tightening mechanism
    translate([1.7 + (Bearing_623_outer_diameter + 14)/2,
        -Big + 30, // Depth of skåra
        -1])
      cube([2,Big,th+2]);
    translate([17.6,0,-1])
    rotate([0,0,15+90]) 
      special_tri(13,13);
    if(flag == 0){
      translate([-10,3,th/2])
      rotate([0,90,0])
      M3_screw(h=Big);
    }
  }
  if(flag != 0){
    difference(){
      translate([-3 + 1.7 + (Bearing_623_outer_diameter + 14)/2,
          0,
          -7]){
        cube([3,7,th+7]);
        translate([5,0,0])
          cube([2.7,7,th+7]);
      }
      translate([9.5,3.5,-3.2])
        rotate([0,90,0])
        M3_screw(h=Big);
    }
  }

  // Foot to screw on to bottom_plate
  difference(){
    translate([0,Drive_support_height,
                 -Drive_support_v[2]+th])
      punched_cube(Drive_support_v);
  }
}
//drive_support(0);

//** Plates start **//

// An upside down hook that can be printed without support structure
module hook(height=10){
  line_radius = 0.75;
  big=30;
  difference(){
    // Main cube
    translate([-2,-1.5,0])
      cube([4,6.5,height]);
    // Hole
    translate([0,-line_radius/2,height])
      rotate([30,0,0])
        cylinder(r=line_radius, h=15.5, center=true);
    // Spår
    translate([0,5,height-2])
      rotate([-56,0,0])
        rotate_extrude(convexity=4)
          translate([2.70,0,0])
            circle(r=line_radius-0.2); 
    translate([0,4.57,4])
    // Bent end of channel
    difference(){
      rotate([0,90,0])
        rotate_extrude(convexity=4)
          translate([1.3,0,0])
            circle(r=line_radius); 
      rotate([30,0,0])
        translate([-big/2,-big/2,0])
          cube(big);
    }
  }
}
//hook();

module top_flerp(side_length){
  difference(){
    eq_tri(side_length,Top_plate_thickness);
    translate([0,1,0]) cylinder(r=M3_diameter/2,h=Big,center=true);
  }
}

// Translation, iterating and rotating modules
module z_gatt_translate(back = 0){
  for(i=[0,120,240])
    rotate([0,0,i])
      translate([0,Full_tri_side/Sqrt3 - back,0])
        children(0);
}

// Flip before printing
module top_plate(){
  th = Top_plate_thickness;
  flerp_side=22;
  height = 15;
  melt=0.1;
  translate([0,0,height]){
    mirror([0,0,1]){
      // Base plate
      difference(){
        eq_tri(Full_tri_side, th);
        translate([0,0,-1])
          eq_tri(Full_tri_side-15, th+2);
      }
      for(i=[0,120,240])
        // Screw holes
        rotate([0,0,i]){
          translate(Line_contact_d_xy)
            translate([0,-7.5,0])
            top_flerp(flerp_side);
          // Hook holes for line
          translate(Line_contact_d_xy)
            translate([0,0,th-melt])
            hook(height-th+melt);
        }
      // Mark action point d
      cylinder(r=2, h=height);
      rotate([0,0,60])
        for(i=[0,120,240]) rotate([0,0,i])
          difference(){
            translate([-1.5,0,0])
              cube([3,Full_tri_side*Sqrt3/6,height]);
            translate([-2.5,0,height])
              rotate([-10,0,0])
              cube([5,Full_tri_side*Sqrt3/6+3,height]);
          }
    }
  }
}
//top_plate();

module side_plate1(height=15){
  s = Full_tri_side;
  th = Bottom_plate_thickness;
  // Frame
  difference(){
    translate([-s/4,-s*Sqrt3/4,-height/2])
      rotate([0,0,30])
      difference(){
        special_tri(s,height);
        translate([6,6,-1]) special_tri(s-34,height+2);
        translate([24,10,height/2])
          rotate([90,0,0])
          cylinder(r=M3_diameter/2, h=20);
        translate([s*Sqrt3/2-17,20,height/2])
          rotate([90,0,0]){
            cylinder(r=M3_diameter/2, h=30);
            translate([0,0,-8])
              cylinder(r=M3_head_diameter/2, h=19);
          }
      }
    // hook holes
    translate([0,-7,0])
    for(k=[1,-1])
      translate([k*Abc_xy_split/2,0,0])
        rotate([-90,0,0])
        cylinder(r=0.75, h=20);
    // Mark wall action point
    rotate([15,0,0]) translate([-1,0,0]) cube([2,5,height]);
    mirror([0,0,1])
      rotate([15,0,0]) translate([-1,0,0]) cube([2,5,height]);
  }
  // Pulleys to wind line around
  for(k=[1,-1])
    translate([k*Abc_xy_split/2,0,0]){
      translate([-5,-3,height/2-0.1]) cylinder(r=3, h=7);
      translate([ 5,-3,height/2-0.1]) cylinder(r=3, h=7);
    }
}
//side_plate1();

module side_plate2(height=15,th=7){
  s = Abc_xy_split + 2*15;
  difference(){
    translate([-s/2,-th,-height/2])
      cube([s,th,height]);
    // Wall screw holes
    for(k=[1,0])
      mirror([k,0,0])
        translate([Abc_xy_split/2 + 7.5,-th-1,0])
          rotate([-90,0,0]){
            cylinder(r=M3_diameter/2, h=Big);
            translate([0,0,th/2]) cylinder(r=M3_head_diameter/2,h=Big);
          }
    // Hook holes
    for(k=[1,0])
      mirror([k,0,0]){
        translate([Abc_xy_split/2,-th-1,0])
          rotate([-90,0,0])
            cylinder(r=0.75, h=Big);
        translate([-1 + Abc_xy_split/2, -th - th +2, -height])
          cube([2, th, 2*height]);
      }
    // Mark wall action point
    rotate([15,0,0]) translate([-1,0,0]) cube([2,5,height]);
    mirror([0,0,1])
      rotate([15,0,0]) translate([-1,0,0]) cube([2,5,height]);
  }
  // Pulleys to wind line around
  for(k=[1,-1])
    translate([k*Abc_xy_split/2,0,0]){
      translate([-4.5,-3,height/2-0.1]) cylinder(r=2.5, h=7);
      translate([ 4.5,-3,height/2-0.1]) cylinder(r=2.5, h=7);
    }
}
//side_plate2();

