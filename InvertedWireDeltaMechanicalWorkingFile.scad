include <measured_numbers.scad>
include <design_numbers.scad>
include <utl.NEMA.scad>
include <rampsMount.scad>
use <parts.scad>
use <placed_parts.scad>
use <render_parts.scad>

// TODO:
//  - Place hot end reliably
// Style:
//  - Spaces separate arguments and long words only
//  - Global parameters starts with capital letter, others don't
//  - Modules that are meant as anti-materia starts with capital letter

// Rendering control
render_bottom_plate = false;
render_sandwich     = true;
render_abc_motors   = true;
render_fish_rings   = true;
render_lines        = true;
render_extruder     = true;
render_hotend       = true;
render_ramps        = true;
render_plates       = true;
render_filament     = true;

module full_render(){
  if(render_bottom_plate){
    bottom_plate();
  }
  if(render_sandwich){
    placed_sandwich();
  }
  if(render_abc_motors){
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
            //main body lower
            translate([0,0,-81])
            cylinder($fn=6, h=5, r=100);
            //upper and lower connecting bars
            
            //TopLineAnchors
            rotate(30, [0, 0, 1])
               for ( i = [0 : 5] ){
                  rotate( i * 60, [0, 0, 1])
                    translate([0,95,10]){
                        rotate(90 , [0,0,1])
                            difference(){
                                translate([0,0,-91])
                                cylinder(h=100, r=5);
                                //cube([5,10,15], center=true);
                                rotate([0,90,0]){
                                    translate([-1,0,-6]){
                                        cylinder(h=12, r=2);
                                    }
                                }
                            }
                        }
                }
        }//end of union
        //center hole
        translate([0,0,-90]){
            cylinder(h=100, r=4);
        }
        //StepperMounts
            for ( i = [0 : 2] ){
                    rotate( i * 120, [0, 0, 30])
                    translate([0,65,8]){
                        rotate([0,0,0]){
                            nema17DiffBlock();
                            //#nema17();   
                        }
                    }
            }
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
            //top panel connector
            for ( i = [0 : 2] ){
                    rotate( i * 120, [0, 0, 1])
                    translate([59,10,-1]){
                        rotate([0,0,0]){
                            cylinder(h=10, r=2); 
                            translate([-20,35,0])
                            cylinder(h=10, r=2); 
                        }
                    }
            }
            
            
    }
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

printerBody();
//spool();

