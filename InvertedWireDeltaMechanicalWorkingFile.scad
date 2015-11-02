include <measured_numbers.scad>
include <design_numbers.scad>
include <utl.NEMA.scad>
include <rampsMount.scad>
use <parts.scad>
use <placed_parts.scad>
use <render_parts.scad>
use <Nema17_and_Ramps_and_bearings.scad>
use <Gears.scad>

// TODO:
//  - Place hot end reliably
// Style:
//  - Spaces separate arguments and long words only
//  - Global parameters starts with capital letter, others don't
//  - Modules that are meant as anti-materia starts with capital letter

// Rendering control
render_bottom_plate = false;
render_sandwich     = false;
render_abc_motors   = false;
render_fish_rings   = false;
render_lines        = false;
render_extruder     = false;
render_hotend       = false;
render_ramps        = false;
render_plates       = false;
render_filament     = false;

module full_render(){
  if(render_bottom_plate){
    bottom_plate();
  }
  if(render_sandwich){
    placed_sandwich();
  }
  if(render_abc_motors){
      rotate([0,0,0])
    placed_abc_motors();
  }
  if(render_fish_rings){
    placed_fish_rings();
  }
  if(render_lines){
    color("green")
    placed_lines();
  }
  if(render_extruder){
    placed_extruder();
  }
  if(render_hotend){
    placed_hotend();
  }
  if(render_ramps){
    placed_ramps();
  }
  if(render_plates){
    placed_plates();
  }
  if(render_filament){
    filament();
  }
}
full_render();

///// alternate body

module printerBody(){

    difference(){
        union(){
            //MainBodyTop
            cylinder($fn=6, h=5, r=100);
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
        }//end of union
    //center hole
    translate([0,0,-90]){
        cylinder(h=100, r=4);
    }
        //StepperMounts
    
     translate([0, 0, -.1]){
      four_point_translate()
        Nema17_schwung_screw_holes(M3_diameter, 6);
      four_point_translate()
        translate([0,0,th-2.5])
          Nema17_screw_holes(M3_head_diameter, 6);
     }
     for ( i = [0 : 2] ){
                rotate( i * 120, [0, 0, 30])
                translate([0,55,8]){
                    rotate([0,0,0]){
                        nema17DiffBlock();
                    }
                }
     }
     /* for ( i = [0 : 2] ){
                rotate( i * 120, [0, 0, 30])
                translate([0,65,8]){
                    rotate([0,0,0]){
                        nema17DiffBlock();
                        //#nema17();   
                    }
                }
        }*/
        //tensioning pins
       /* rotate(30,[0,0,1])
        for ( i = [0 : 2] ){
                rotate( i * 120, [0, 0, 1])
                translate([-3,44,-4]){
                    rotate([0,0,0]){
                        cylinder(h=10, r=1.5);  
                    }
                }
        }
        */
            //quadcopter or baloon mounting holes
            for ( i = [0 : 2] ){
                rotate( i * 120, [0, 0, 1])
                    translate([90,10,-1]){
                       cylinder(h=10, r=2); 
                       rotate([0,0,30]){
                           translate([0,73,0])
                           cylinder(h=10, r=2); 
                        }
                    }
            }//end of baloon mounting for loop
            lowerPrinterBody();
     }// end of difference
}//end of printer body module

module lowerPrinterBody(){
    difference(){
        union(){
            translate([0,0,-81])
            cylinder($fn=6, h=5.001, r=100);
            //upper and lower connecting bars
            
            //TopLineAnchors
              rotate([0,0,180])
                rotate(30, [0, 0, 1])
                   for ( i = [2 : 7] ){
                      rotate( i * -60, [0, 0, 1])
                        translate([0,95,10]){
                            rotate(90 , [0,0,1])
                                difference(){
                                    translate([0,0,-91])
                                    if(i%2==0){cylinder(h=98 + (i*Sandwich_height/2), r=5);}
                                    else{cylinder(h=98 + ((i-1)*Sandwich_height/2), r=5);}
                                    if(i%2==0){translate([-10,0,(Bottom_plate_thickness + Bottom_plate_sandwich_gap + Snelle_height/2 +  (i*  (Sandwich_height + Sandwich_gap))/2)-10])
                                        rotate([0,90,0])
                                        cylinder(h=30, r=2);}
                                    else{translate([-10,0,(Bottom_plate_thickness + Bottom_plate_sandwich_gap + Snelle_height/2 +   ((i-1)* (Sandwich_height + Sandwich_gap))/2)-10])
                                        rotate([0,90,0])
                                        cylinder(h=30, r=2);}
                                         
                                 }// end of differece
                             translate([0,0,-20]){
                                 cylinder(h=10 , r1=5 , r2= 8);
                             }               
                     }
                   }// end of for loop
        }//end of inner union  
        translate([0,0,-84])
        cylinder(r=4, h=10); 
    }//end of difference
}
module spool(){
    difference(){
        union(){
            //near flange
            translate([0,0,9])
                cylinder(d1=19,d2=14, h=5);
            //far flange
            translate([0,0,29])
                cylinder(d=19, h=3);
            difference(){
                //outer spool part
                translate([0,0,.1])
                   cylinder($fn=64, d=14, h=30);
                //inner spool cutout
               cylinder($fn=20, d=12, h=14); 
           }
       }
       //stringhole
       rotate([0,90,0])
       translate([-14,0,-15])
       cylinder(d=2, h=40);
    }
}

//printerBody();
lowerPrinterBody();
//spool();

