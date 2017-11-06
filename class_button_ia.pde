class Button_ia { //special purpose buttons for use with the animation graph 
  int wide, high, year; 
  int R1, G1, B1, R2, G2, B2;
  float hoverScale; 
  boolean active;
  boolean above = false;
  String aircraft, description; //aircraft actually means the mode of transport, description is the summary
  long altitude;
  
  int textbox_w = 325; //standardised textbox width, so that textboxes never extend over the canvas
  int textbox_h; //textbox height custom selected
  int textSize = 12; //textsize is adjusted manually because I am lazy - won't be too hard to enter this into a function but whats the point it'll just be harder to change later
  int datacol; 
  
  Button_ia(int Pwide, int Phigh, int Pyear, String Paircraft, int PR1, int PG1, int PB1, int Ptextbox_h) { //second construction but you get to pick colours
    wide = Pwide;
    high = Phigh;
    aircraft = Paircraft;
    year = Pyear;
    R1 = PR1; G1 = PG1; B1 = PB1;
    switch (aircraftSelect(aircraft)) { //switch statement used to initialise button's data from the appropriate data
      case 0:
        for (int i=0;i<p_p_holdercount;i++) {
          if (year==p_p.getYear().getInt(i)) {
            datacol = i; //selects which column (year - event) this button takes data from
            break;
          }
        }
        altitude = p_p.getAltitude().getInt(datacol);
        description = p_p.getSummary().getString(datacol);
         break;
      case 1:
        for (int i=0;i<tj_holdercount;i++) {
          if (year==tj.getYear().getInt(i)) {
            datacol = i;
            break;
          }
        }
        altitude = tj.getAltitude().getInt(datacol);
        description = tj.getSummary().getString(datacol);
        break;
      case 2:
        for (int i=0;i<p_j_holdercount;i++) {
          if (year==p_j.getYear().getInt(i)) {
            datacol = i;
            break;
          }
        }
        altitude = p_j.getAltitude().getInt(datacol);
        description = p_j.getSummary().getString(datacol);
        break;
      case 3:
        for (int i=0;i<bloon_holdercount;i++) {
          if (year==bloon.getYear().getInt(i)) {
            datacol = i;
            break;
          }
        }
        altitude = bloon.getAltitude().getInt(datacol);
        description = bloon.getSummary().getString(datacol);
        break;
      case 4:
        for (int i=0;i<gli_holdercount;i++) {
          if (year==gli.getYear().getInt(i)) {
            datacol = i;
            break;
          }
        }
        altitude = gli.getAltitude().getInt(datacol);
        description = gli.getSummary().getString(datacol);
        break;
      case 5:
        for (int i=0;i<mtnA_holdercount;i++) {
          if (year==mtnA.getYear().getInt(i)) {
            datacol = i;
            break;
          }
        }
        altitude = mtnA.getAltitude().getInt(datacol);
        description = mtnA.getSummary().getString(datacol);
        break;
      case 6:
        for (int i=0;i<mtnS_holdercount;i++) {
          if (year==mtnS.getYear().getInt(i)) {
            datacol = i;
            break;
          }
        }
        altitude = mtnS.getAltitude().getInt(datacol);
        description = mtnS.getSummary().getString(datacol);
        break;
      case 7: 
        for (int i=0;i<p_alr_holdercount;i++) {
          if (year==p_alr.getYear().getInt(i)) {
            datacol = i;
            break;
          }
        }
        altitude = p_alr.getAltitude().getInt(datacol);
        description = p_alr.getSummary().getString(datacol);
        break;
      case 8: 
        for (int i=0;i<spcfl_holdercount;i++) {
          if (year==spcfl.getYear().getInt(i)) {
            datacol = i;
            break;
          }
        }
        altitude = spcfl.getAltitude().getInt(datacol);
        description = spcfl.getSummary().getString(datacol);
        break;
    }
    textbox_h = Ptextbox_h;
  }
  
  void display() {
    if (!above) { //darker when hovered over
      hoverScale = 1;
    } else {
      hoverScale = 0.7;
    }
    
    fill(floor(hoverScale*R1),floor(hoverScale*G1),floor(hoverScale*B1)); 
    stroke(255);
    strokeWeight(0);
    ellipse(60+x_axis_counter,floor(480-(altitude*yscale)),wide,high); //displays an ellipse onto the graph
  }
  
  void summary() { //displays a rectangle containing the altitude and the summary of the event
    if (above) {
      textFormat(240,240,240,textSize,1,0);  
      pushMatrix();
      translate(15,-8);
      rect(60+x_axis_counter,floor(490-(altitude*yscale)-((480.0-(altitude*yscale))/(480.0))*textbox_h),textbox_w,textbox_h);
      fill(0);
      text("Altitude: ["+str(altitude)+" m]",70+x_axis_counter,floor(508-(altitude*yscale))-((480.0-(altitude*yscale))/(480.0))*(textbox_h));
      text(description,70+x_axis_counter,floor(528-(altitude*yscale))-((480.0-(altitude*yscale))/(480.0))*(textbox_h));
      popMatrix(); //note that the textboxes's position relative to the button adjusts based on the altitude and the current max altitude
    } //which ensures that the textboxes never go off the screen
  }
  
  void hover() {
    if ((mouseX>=50+x_axis_counter-floor(0.5*wide))&&(mouseX<=50+x_axis_counter+ceil(0.5*wide))&&(mouseY>=floor(480-(altitude*yscale))-floor(0.5*high))&&(mouseY<=floor(480-(altitude*yscale))+ceil(0.5*high))) {
      above = true; 
    } else {
      above = false;
    }
  }

  void press() { 
    if ((mouseX>=floor(60+x_axis_counter-0.5*wide))&&(mouseX<=ceil(60+x_axis_counter+0.5*wide))&&(mouseY>=floor(floor(480-(altitude*yscale))-0.5*high))&&(mouseY<=ceil(floor(480-(altitude*yscale))+0.5*high))) {
      active = !active;
    } 
  }
  
  void setAltitude(long a) {
    altitude = a;
  }
  
  boolean getHover() {
    return above;
  }
  
  boolean getActive() {
    return active;
  }
  
  String getAircraft() {
    return aircraft;
  }
  
  int getYear() {
    return year;
  }
  
  long getAltitude() {
    return altitude;
  }
  
  String getDescription() {
    return description;
  }
  
  void resetActive() {
    active = false;
  }
}

int aircraftSelect(String aircraft) { //changes natural language (?) to an integer to select the dataset this button takes data from
  if (aircraft=="p_p") {
    return 0;
  } else if (aircraft=="tj") {
    return 1;
  } else if (aircraft=="p_j") {
    return 2;
  } else if (aircraft=="bloon") {
    return 3;
  } else if (aircraft=="gli") {
    return 4;
  } else if (aircraft=="mtnA") {
    return 5;
  } else if (aircraft=="mtnS") {
    return 6;
  } else if (aircraft=="p_alr") {
    return 7;
  } else if (aircraft=="spcfl") {
    return 8;
  } else {
    return -1;
  }
}