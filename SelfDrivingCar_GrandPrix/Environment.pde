
class Environment{
  ArrayList<Vec2> enviro;
  
  Environment(ArrayList<Vec2> enviro_){
    enviro = enviro_;
    ChainShape chain = new ChainShape();
    
    Vec2[] vertices = new Vec2[enviro.size()];
    for (int i = 0; i < vertices.length; i++){
      vertices[i] = box2d.coordPixelsToWorld(enviro.get(i));
    }
    
    chain.createChain(vertices, vertices.length);
    
    BodyDef bd = new BodyDef();
    Body body = box2d.world.createBody(bd);
    body.createFixture(chain, 1);
    body.setUserData(this);
  }
  
  void display(){
    strokeWeight(2);
    stroke(255);
    fill(0);
    beginShape();
    for (Vec2 v: enviro){
      vertex(v.x, v.y);
    }
    endShape();
  }
}