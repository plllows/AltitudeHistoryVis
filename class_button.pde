class Button { //this is the normal buttons for the user interface, not the ones on the graph that display summaries
  int x, y, wide, high, style, type; //default style is rect, 1 == ellipse
  int R1, G1, B1, R2, G2, B2; //different colours for active and inactive modes
  float hoverScale; //adjust rgb values for when mouse is hovered over the button
  boolean active;
  boolean above = false; //is the mouse over the button?
  
  Button(int Px, int Py, int Pwide, int Phigh) {
    x = Px;
    y = Py;
    wide = Pwide;
    high = Phigh;
    type = 0;
    style = 0;
    active = false;
    R1 = 0; G1 = 255; B1 = 0;
    R2 = 255; G2 = 0; B2 = 0;
  }
  
  Button(int Px, int Py, int Pwide, int Phigh, int Ptype) { //whether default state is active or inactive
    x = Px;
    y = Py;
    wide = Pwide;
    high = Phigh;
    type = Ptype;
    style = 0;
    if (type==1) {
      active = true;
    } else {
      active = false;
    }
    R1 = 0; G1 = 255; B1 = 0;
    R2 = 255; G2 = 0; B2 = 0;
  }
  
  Button(int Px, int Py, int Pwide, int Phigh, int Ptype, int Pstyle) { //whether button is rectangular or circle (both are used)
    x = Px;
    y = Py;
    wide = Pwide;
    high = Phigh;
    style = Pstyle;
    type = Ptype;
    if (type==1) {
      active = true;
    } else {
      active = false;
    }
    R1 = 0; G1 = 255; B1 = 0;
    R2 = 255; G2 = 0; B2 = 0;
  }
  
  Button(int Px, int Py, int Pwide, int Phigh, int Ptype, int Pstyle, int PR1, int PG1, int PB1, int PR2, int PG2, int PB2) { //different colours for on and off states 
    x = Px; 
    y = Py;
    wide = Pwide;
    high = Phigh;
    style = Pstyle;
    type = Ptype;
    if (type==1) {
      active = true;
    } else {
      active = false;
    }
    R1 = PR1; G1 = PG1; B1 = PB1;
    R2 = PR2; G2 = PG2; B2 = PB2; 
  }
  
  void display() {
    if (!above) {
      hoverScale = 1;
    } else {
      hoverScale = 0.7; //darker when hovered over
    }
    
    if (active) {
      stroke(10);
      fill(floor(hoverScale*R1),floor(hoverScale*G1),floor(hoverScale*B1)); //different colours when active and inactive
    } else {
      stroke(10);
      fill(floor(hoverScale*R2),floor(hoverScale*G2),floor(hoverScale*B2));
    }
    
    if (style==1) { //rect or ellipse?
      ellipse(x,y,wide,high);
    } else if (style==0) {
      rect(floor(x-0.5*wide),floor(y-0.5*high),wide,high);
    }
  }
  
  void hover() { //boolean to check whether mouse is over the button (note elliptical buttons have rectangular hitbox - ease of use)
    if ((mouseX>=floor(x-0.5*wide))&&(mouseX<=ceil(x+0.5*wide))&&(mouseY>=floor(y-0.5*high))&&(mouseY<=ceil(y+0.5*high))) {
      above = true; 
    } else {
      above = false;
    }
  }

  void press() { //this is the function that is in the mousepressed part of GC_II - changes the state of the button if mousepressed and mouse within hitbox
    if ((mouseX>=floor(x-0.5*wide))&&(mouseX<=ceil(x+0.5*wide))&&(mouseY>=floor(y-0.5*high))&&(mouseY<=ceil(y+0.5*high))) {
      active = !active;
    } 
  }
  
  boolean getHover() { //returns a bunch of stuff
    return above;
  }
  
  boolean getActive() {
    return active;
  }
  
  int getStyle() {
    return style;
  }
  
  int getType() {
    return type;
  }
  
  void resetActive() { //resets button to default state
    if (type==0) {
      active = false;
    } else if (type==1) {
      active = true;
    }
  }
}