class Boundary{
  // Variables to keep track of
  Body body;
  float x, y, w, h;
  
  Boundary(float x_, float y_, float w_, float h_){
    /*
      Boundary(float x_, y_, w_, h_) - Boundary Constructor
      float x_, y_ - position in pixel coord
      float w_, y_ - width and height
    */
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    makeBody();
  }
  
  void makeBody(){
    /*
      void makeBody() - define and create body
    */
    
    BodyDef bd = new BodyDef();
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    bd.type = BodyType.STATIC;
    bd.linearDamping = 0.9;
    
    body = box2d.createBody(bd);
    
    PolygonShape rect = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    rect.setAsBox(box2dW, box2dH);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = rect;
    fd.friction = 0;
    fd.restitution = 0;
    fd.density = 900.0;
    body.createFixture(fd);
    body.setUserData(this);
  }
  
  void render(){
    /*
      void render() - display the Boundary
    */
    Vec2 pos = box2d.getBodyPixelCoord(body);
    fill(255,255,255,0);
    stroke(255, 0,255);
    strokeWeight(1);
    pushMatrix();
    translate(pos.x, pos.y);
    rectMode(CENTER);
    rect(0,0,w,h);
    popMatrix();
  }
  
 

  void killBoundary(){
    /*
      void killBoundary() - kills the box2d body
    */
    box2d.destroyBody(body);
  }
  
  
}