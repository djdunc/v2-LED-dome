class Tunnel {
  float xPos, yPos;
  ArrayList<TunnelSegment> tunnelPieces;
  float tunnelSpeed;
  float numOfPieces;
  float maxSize;
  
  Tunnel(float x, float y, float n, float s, float m) {
    xPos = x;
    yPos = y;
    numOfPieces = n;
    tunnelSpeed = s;
    maxSize = m;
    tunnelPieces = new ArrayList<TunnelSegment>();
    float distanceBetween = maxSize/numOfPieces;
    for (int iter = 0; iter<numOfPieces; iter++) {
      tunnelPieces.add(new TunnelSegment(xPos, yPos, distanceBetween*iter, tunnelSpeed, maxSize));
    }
  }

  void renderTunnel() {
    for (int iter = 0; iter<tunnelPieces.size(); iter++) {
      tunnelPieces.get(iter).renderTunnelSegment();
    }
  }
}

class TunnelSegment {
  float xPos, yPos, dia, growth, maxSize;
  color colour;

  TunnelSegment(float x, float y, float d, float g, float m) {
    xPos = x;
    yPos = y;
    dia = d; 
    growth = g;
    maxSize = m;
    colour = color(255*(int)random(2),255*(int)random(2),255*(int)random(2));
  }

  void renderTunnelSegment() {
    noFill();
    if (dia>maxSize-growth*10) {
      stroke(colour,50);
    } else {
      stroke(colour);
    }
    strokeWeight(10);
    ellipse(xPos, yPos, dia, dia);
    dia += growth;
    if (dia>maxSize) {
      dia = 0;
    }
  }
}
