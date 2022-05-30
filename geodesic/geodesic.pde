OPC opc;
Table table;

int n = 5;     //pentagram
float r = 170; //size of pentagram
 
void setup() {
  size(600, 600);
  
  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  table = loadTable("locations.csv", "header");
  rectMode(CENTER);  
  ellipseMode(RADIUS);
  noFill();
  stroke(255);
  smooth();
  
  setupLEDs();

}
 
void draw() {
  background(0);
  
  fill(255, 0, 0);
  rect(mouseX, mouseY, 10,10);
  noFill();
  
  translate(width/2, height/2); //move 0,0 coordinates to centre
   

  //configure();
  //drawPent(0,0,r);
  spinner(0,0,r);

}

void setupLEDs(){
  //  Map the 64-LED strip to the center of the struts
  // ONLY 3 FADECANDIES = 24 BUT 25 LED STRIPS SO STRIP 5 USES STRIP 20 DATA
  for (int i = 0; i<table.getRowCount(); i++) {

    TableRow row = table.getRow(i);
    int x = row.getInt("x");
    int y = row.getInt("y");
    int r = row.getInt("radian");
    String rev = row.getString("reversed"); 
    boolean b = boolean(rev);
    println("i:" + i +"x:" +x + " y:" +y + " rad:" +r);

    // Set the location of several LEDs arranged in a strip.
    // Angle is in radians, measured clockwise from +X.
    // (x,y) is the center of the strip.
    //void ledStrip(int index, int count, float x, float y, float spacing, float angle, boolean reversed)
    opc.ledStrip(i*30, 30, x, y, 3.3, radians(r), b);
    
  }
}


void configure(){
    for (int i = 0; i<table.getRowCount(); i++) {

    TableRow row = table.getRow(i);
    int x = row.getInt("x");
    int y = row.getInt("y");
    int r = row.getInt("radian");
    String id = row.getString("id");

    pushMatrix();
    translate(-width/2, -height/2); 
    translate(x,y);
    rotate(radians(r)); //rotate scene to make it look more natural
    line(-50,0,50,0);
    textAlign(CENTER);
    text(id, 0,0);
    ellipse(0, 0, 10, 10);
    popMatrix();
  }
    
  println("x " + mouseX + " y " + mouseY);
}


void spinner(float x, float y, float r){
  float basicA = frameCount*0.01f;
  //ellipse(0, 0, r, r);
  for (int i=0; i < n;i++) {
    float angle = (2*PI*i/n)+basicA;
    x = cos(angle)*r;
    y = sin(angle)*r;
    
    pushMatrix();
    translate(x,y);
    rotate(angle);
    fill(0, 255, 0);
    rect(0, 0, 80, 20);
    noFill();
    popMatrix();
  }

}


void drawPent(float x, float y, float r) {
  for (int i=0; i < n;i++) {
    //float angle = (2*PI*i/n)+basicA;
    float angle = (2*PI*i/n);
    x = cos(angle)*r;
    y = sin(angle)*r;
    
    pushMatrix();
    translate(x,y);
    rotate(angle);
    //rect(0, 0, 20, 20);
    rotate(radians(30));
    drawHex(0,0,100);
    popMatrix();
  }


}

void drawHex(float x, float y, float gs) {
  beginShape();
  for(int i=0;i<6;i++){
    float angle = i * 2 * PI / 6;
    vertex(x + gs*cos(angle),y + gs*sin(angle));
  }
  endShape(CLOSE);
  for(int i=0;i<6;i++){
    float angle = i * 2 * PI / 6;
    line(0,0, x + gs*cos(angle),y + gs*sin(angle));
  }

}

void drawgrid(){
    for(int i = 0; i < 6; i++){
    line(i*100, 0, i*100, height);
  }  
  for(int j = 0; j < 6; j++){
    line(0, j*100, width, j*100);
  }
}
