/* 
    * Encabulator Mk.2 
    * Freeware (c) Neko Mittz 2022
    * No warranties of any kind whatsoever.
    * An OpenSCAD STL Generator for mindexedand simplified mt32-pi modules in eurorack.
    * DOES NOT support the button to select between munt and fluidsynth modes - I always run mine as fluidsynth, but YMMV.
    * Allows menu customisation of width in HP, Material thickness, screw slot centre, distances from edge of panel, and slot lenths from round, to "much too long".
    * Screw slot placement will be improved at some point.
*/
// Specifications - editable via customisation menu.
TopText="SYNTH-DIY";
TopTextX=35;
TopTextY=122;
TextBottomX=14;
TextBottomY=4;
TextBottom="Retro-Encabulator Mk.II";
Resolution = 360;                   // Configure Low (18) for fast test rendering, high (360) for final render.
PanelColor="silver";                // Configurable option, mostly irrelevant.
TextColour="black";                 // mostly irrelevant
PanelWidthHP=20;                    // Suggest 18 to 21 HP limits because LCD width but YMMV.
MaterialThickness=2;                // 3mm is nice too.
PanelScrewInsetX=5.08;              // Variable to needs
PanelScrewHoleSlot=2.54;            // 0 for circular hole, more for a slot.
DisplayCentreY=95;                  // Don't forget clearance between the PCB and the rack rail. 
LCDScrewDiameter=3.2;               // Note: this varies between panels.
MencoderHeight=44;                   // Where do you want your MechanicalEncoder?
MencoderThreadDiameter=7.5;            // Check your encoder. I'm thinking of making this a little smaller and tapping a  thread, so that the encoder screws into the hole, and the nut acts as a locknut only. This allows the encoder to be adjusted so that the knob is just the right height. The mechanical encoders I am using have M7x0.75 threads.

// Calculations - do not edit.
PanelWidth=PanelWidthHP*5.08;
MencoderThreadRadius=(MencoderThreadDiameter/2)+0.2;



// OLD - Moving to LCD-as-module()
// Screws inset from edge of panel.

/*
    Generate cuts for a Quapass 1602 LCD display or exact equivalent. I have found "1602" displays to be a little inconsistent, so may need tweaks
*/


// Modules - probably don't edit these.

// Generate a screw hole 
module Hole(screwholex,screwholey,screwholeradius,screwholecolor){
    translate([screwholex,screwholey,-1])
    color(screwholecolor)
    cylinder(MaterialThickness+2,screwholeradius,screwholeradius,$fn=Resolution);
}

// Generate a screw slot.
module ScrewSlot(x,y,r,thickness,slotlen,slotcolour,res) { 
    translate([x-(slotlen/2),y,-1])
    color(slotcolour)
    cylinder(thickness+2,r,r, $fn=res);
    translate([x+(slotlen/2),y,-1])
    color(slotcolour)
    cylinder(thickness+2,r,r, $fn=res);
    translate([(x-(slotlen/2)),y-r,-1])
    color(slotcolour)
    cube([slotlen,r*2,thickness+2]);
}


module Quapass1602(centrex,centrey,screwholeradius){
    Hole(centrex-37.7,centrey+15.7,screwholeradius,PanelColor);
    Hole(centrex+37.7,centrey+15.7,screwholeradius,PanelColor);
    Hole(centrex-37.7,centrey-15.7,screwholeradius,PanelColor);
    Hole(centrex+37.7,centrey-15.7,screwholeradius,PanelColor);
    // the display letterbox
    translate([centrex-35.5,centrey-12,-1])
    color(PanelColor)
    cube([71,24,MaterialThickness+2]); 
}

module Mencoder(Mencodery,radius) {
    color(PanelColor)
    Hole(PanelWidth/2,Mencodery,radius);
}



module Panel(HolePoints,PanelThickness,SlotLength,Colour) { 
    PanelHeight=128.5;//Standards - Do not change.
    HP=5.08; //Standards - Do not change
    PanelScrewSize=3; // For M3 thread
    PanelScrewHoleRadius=(PanelScrewSize/2)+0.2; // Drill 3.2mm to clear M3
    PanelScrewInsetY=3; // Screws insets from edges of panel.
    PanelWidth=HolePoints*HP;
    
    difference() {
        translate([0,0,0])
        color(Colour)
        cube([PanelWidth-0.2,PanelHeight,PanelThickness]);
        ScrewSlot(PanelScrewInsetX,PanelHeight-PanelScrewInsetY,PanelScrewHoleRadius,PanelThickness,SlotLength,Colour,Resolution);
        ScrewSlot(PanelWidth-PanelScrewInsetX,PanelHeight-PanelScrewInsetY,PanelScrewHoleRadius,PanelThickness,SlotLength,Colour,Resolution);
        ScrewSlot(PanelScrewInsetX,PanelScrewInsetY,PanelScrewHoleRadius,PanelThickness,SlotLength,Colour,Resolution);
        ScrewSlot(PanelWidth-PanelScrewInsetX,PanelScrewInsetY,PanelScrewHoleRadius,PanelThickness,SlotLength,Colour,Resolution);
    }
}

module Text(textx,texty,textstring,textcolour) {
    translate([textx,texty,1.99]) 
    {
        color(textcolour)
        linear_extrude(height=0.011) 
        text(textstring,size=4,font="Liberation Mono:style=Bold"); 
    }
}

// The main program (edit for extra customisations)
 difference() {
     // The Panel (including screw slots)
    Panel(PanelWidthHP,MaterialThickness,PanelScrewHoleSlot,PanelColor);    
    // 1602 LCD display
    Quapass1602((PanelWidthHP*5.08)/2,DisplayCentreY,LCDScrewDiameter/2);
    // the encoder
    Mencoder(MencoderHeight,MencoderThreadRadius);
    //the text
    Text(TopTextX,TopTextY,TopText,"black");
    Text(TextBottomX,TextBottomY,TextBottom,"black");
    
}