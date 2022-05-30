OPC opc;
PImage dot;

void setup()
{
  size(800, 200);

  // Load a sample image
  //dot = loadImage("color-dot.png");

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  // Map one 64-LED strip to the center of the window
  //opc.ledStrip(0, 128, width/2, height/2, width / 140.0, 0, false);

  for (int i = 0; i< 2; i++){
    opc.ledStrip(i*64, 64, width/2, i*15 + 30, width / 70, 0, false);
  }

}

void draw()
{
  background(0);
  fill(255, 0, 0);
  rect(mouseX, mouseY, 50,50);
  }
