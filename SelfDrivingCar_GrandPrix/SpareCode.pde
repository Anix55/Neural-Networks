/* 
  Give surviving cars a new random position each generation
  TAB: SelfDrivingCar_GrandPrix
  Belongs in for-loop that resets fitness back to 0 for survivors
*/

/*float chance = random(0,1);
 Vec2 pos = new Vec2();
 if (chance < 0.25) {
 pos = box2d.coordPixelsToWorld(  new Vec2(width/2 - int(random(200, 290)), height/2 - int(random(-100, 100))));
 Population.get(i).body.setTransform(pos, PI/2);
 } else if (chance < 0.5) {
 pos = box2d.coordPixelsToWorld(  new Vec2(width/2 + int(random(200, 290)), height/2 - int(random(-100, 100))));
 Population.get(i).body.setTransform(pos, PI/2);
 } else if (chance < 0.75){
 pos = box2d.coordPixelsToWorld(new Vec2(width/2 + int(random(-100, 100)), height/2 - int(random(200, 290))));
 Population.get(i).body.setTransform(pos, 0);
 } else {
 pos = box2d.coordPixelsToWorld(  new Vec2(width/2 + int(random(-100, 100)), height/2 + int(random(200, 290))));
 Population.get(i).body.setTransform(pos, PI);
 }
 Population.get(i).currPos = pos;
 Population.get(i).prevPos = pos;
 */