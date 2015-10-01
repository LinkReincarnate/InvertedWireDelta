include <utl.NEMA.scad>
include <rampsMount.scad>
include<cointube.scad>
module printerBody(){

    difference(){
        union(){
            //MainBody
            cylinder($fn=6, h=5, r=100);
            //StepperMounts
            for ( i = [0 : 2] ){
                    rotate( i * 120, [0, 0, 1])
                    translate([-14,65,-21]){
                        rotate([0,90,0]){
                            difference(){
                                cube([44,43,10], center=true);
                                nema17DiffBlock();
                                #nema17();
                            }
                            
                        }
                    }
                }
            //TopLineAnchors
            rotate(60,[0,0,1]){
                for ( i = [0 : 2] ){
                    rotate( i * 120, [0, 0, 1])
                    translate([0,76,15]){
                            difference(){
                                cube([10,20,30], center=true);
                                rotate([0,90,0]){
                                    translate([-9,0,-6]){
                                        cylinder(h=12, r=4);
                                    }
                                }
                            }
                        }
                }
            }
            //ramps mounting nubs
            rotate([0,0,330])
            translate([28,-52,4.99]){
                rampsMount();
                
            }
            //cointube
            rotate([0,0,330])
            translate([-28,-22,-42]){
                coinTube();
                
            }
            
        }
        //center hole
        translate([0,0,-1]){
            cylinder(h=7, r=8);
        }
        //ramps mounting holes and nut countersinks
        rotate([0,0,330])
            translate([28,-52,2.98]){
                mountHoles();
                
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
