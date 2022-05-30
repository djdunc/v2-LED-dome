OPC opc;
Table table;
Tunnel tunnel;
PImage img1;  
PImage img2;  


int n = 5;     //pentagram
float r = 170; //size of pentagram
int timer;
int displaymode = 1;
 
void setup() {
  
  // Set some sketch drawing settings
  size(600, 600);
  rectMode(CENTER);  
  ellipseMode(RADIUS);
  noFill();
  stroke(255);
  smooth();
  
  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);
  
  // Load in locations of LEDs in geodesic dome layout
  table = loadTable("locations.csv", "header");
  setupLEDs();
  
  // Setup a tunnel instance
  tunnel = new Tunnel(0, 0, 20, 3, width);

  img1 = loadImage("spiralsquare.jpeg");  // Load the image into the program  
  img2 = loadImage("wheelsegmentsquare.jpeg");  // Load the image into the program  
  imageMode(CENTER);  

}
 
void draw() {
  background(0); // need to keep redrawing canvas so set ot black at each loop
  translate(width/2, height/2); //since radial about centre -> move 0,0 coordinates to centre
  
  if (millis() - timer >= 20000) {
    println(displaymode);
    displaymode = displaymode + 1;
    if (displaymode > 4){
      displaymode = 1;
    }
    timer = millis();
  }
  
  //testLeds();         // test function
  //configure();        // function for confuguring sketch
  //drawPent(0,0,r);    // show geodesic dome layout
  
  switch(displaymode) {
    case 1: 
      fuzz();
      //spinner(0,0,r);     // simple test spinner
      break;
    case 2: 
      tunneller();
      break;
    case 3:
      loadpicture(img1);
      break;
    case 4:
      loadpicture(img2);
      break;
    default:
      println("no displaymode");   // Does not execute
      break;
  }  
}
void mouseClicked() {
  displaymode = displaymode + 1;
  timer = millis();
}

void loadpicture(PImage img){
  // Displays the image at its actual size at point (0,0)
  pushMatrix();
  rotate(radians(frameCount % 360));
  image(img, 0, 0);
  popMatrix();
}

void tunneller(){
  //noStroke(0); 
  fill(0,20);
  rect(0,0,width,height);
  tunnel.renderTunnel();
}

void testLeds(){
  // Create a red box that follows mouse to test leds
  //fill(255, 0, 0);
  //rect(mouseX, mouseY, 10,10);
  //noFill();
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

void fuzz(){
  pushMatrix();
  translate(-width/2, -height/2); 
  for (int i = 0; i < width; i = i+5) {
    for (int j = 0; j < height; j = j+5) {
      fill(255*(int)random(2),255*(int)random(2),255*(int)random(2));
      rect(i, j, 5,5);
    }
  }
  popMatrix();
  delay(50);
}

void spinner(float x, float y, float r){
  float basicA = frameCount*0.02f;
  //ellipse(0, 0, r, r);
  for (int i=0; i < n;i++) {
    float angle = (2*PI*i/n)+basicA;
    x = cos(angle)*r;
    y = sin(angle)*r;
    
    pushMatrix();
    translate(x,y);
    rotate(angle);
    fill(random(150,255), 0, 0);
    noStroke();
    rect(0, 0, 180, 40);
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
