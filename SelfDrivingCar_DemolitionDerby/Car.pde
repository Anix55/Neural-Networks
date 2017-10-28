
class RayCastClosestCallback implements RayCastCallback {

  boolean m_hit;
  Vec2 m_point;
  Vec2 m_normal;
  float m_fraction;

  void reset() {
    m_hit = false;
    m_point = new Vec2();
    m_normal = new Vec2();
    m_fraction = 1;
  }

  float reportFixture(Fixture fixture, Vec2 point, Vec2 normal, float fraction) {
    /*
      public float reportFixture() - triggers when collision with ray occurs
     returns distance of collision
     */
    m_hit = true;
    m_point = point.clone();  // this returns an error : "The function "cpy()" does not exist"
    m_normal = normal;
    m_fraction = fraction;
    return fraction;
  }
}

class Timer {

  int start;

  Timer() {
    start = millis();
  }

  float timeElapsed() {
    return millis() - start;
  }

  void reset() {
    start = millis();
  }
}


class Car implements Comparable {
  // Variables to keep track of
  Body body;
  Neural_Network NN;
  Timer timer;
  Vec2 [] sensors;
  Vec2 currPos, prevPos;
  float [] sensorLocalAngles, sensorFractions;
  float [] genes;
  float [][]input;
  float x, y, fitness, w, h, rayLength, dist, prevLocalAngle;
  boolean displayNN, isColliding;
  int ID;
  int [] rgb;
  int numSensors;
  RayCastClosestCallback ccallback;

  // Debugging tools and variables


  Car(float [] genes_, boolean mutate) {
    /*
      Car(float[] genes) - Car constructor
     float[] genes - list of weight values used to create NN
     */
    rayLength = 150; 
    fitness = 0; 
    w = 14; 
    h = 7;
    genes = genes_;
    rgb = new int[4]; 
    rgb[0] = 150; 
    rgb[1] = 150; 
    rgb[2] = 150; 
    rgb[3] = 150;
    ID = int (random(1, 1000));
    isColliding = false;
    NN = new Neural_Network(genes, mutate);
    if (genes.length == 0) {
      genes = NN.chromosome;
    }

    // Give the Car a random position around the ring
    x = random(110, width-110);
    y = random(160, height-160);

    currPos = new Vec2(x, y);
    prevPos = currPos;
    prevLocalAngle = random(0, TAU);

    /*
      Intializing the car's COLLISION AVERSION SENSORS (C.A.S)
     These are Vec2 objects that contain the end point for future ray casts
     */
    numSensors = 6;
    sensorLocalAngles = new float[numSensors];
    sensorLocalAngles[0] = 0;
    sensorLocalAngles[1] = PI/8;
    sensorLocalAngles[2] = PI/4;
    sensorLocalAngles[3] = -PI/8;
    sensorLocalAngles[4] = -PI/4;
    sensorLocalAngles[5] = PI;
    sensors = new Vec2[numSensors]; // contains end point of ray
    for (int i = 0; i < numSensors; i++) {
      float f = sensorLocalAngles[i];
      sensors[i] = new Vec2(cos(f), sin(f));
    }
    sensorFractions = new float[numSensors];
    sensorFractions[0] = 1.0;
    sensorFractions[1] = 1.0;
    sensorFractions[2] = 1.0;
    sensorFractions[3] = 1.0;



    input = new float [NN.numExamples][numSensors+1];
    timer = new Timer();
    makeBody();
    ccallback = new RayCastClosestCallback();
    checkSensors();
    displayNN = false;
  }

  void makeBody() {
    /*
      void makeBody() - define and create body
     */
    BodyDef bd = new BodyDef();
    Vec2 initPos = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    bd.position.set(initPos);
    bd.angle = prevLocalAngle;

    body = box2d.createBody(bd);

    PolygonShape rect = new PolygonShape();
    float box2Dw = box2d.scalarPixelsToWorld(w/2);
    float box2Dh = box2d.scalarPixelsToWorld(h/2);
    rect.setAsBox(box2Dw, box2Dh);

    FixtureDef fd = new FixtureDef();
    fd.shape = rect;
    fd.friction = 0.1;
    fd.restitution = 0;
    fd.density = 1.0;
    body.createFixture(fd);
    body.setUserData(this);
  }

  Vec2 getLateralVelocity() {
    /*
      Vec2 getLateralVelocity() - return the lateral velocity of the car
     */
    Vec2 currentRightNormal = body.getWorldVector(new Vec2(0, 1));
    float magnitude = Vec2.dot( currentRightNormal, body.getLinearVelocity());
    return currentRightNormal.mul(magnitude);
  }

  Vec2 getForwardVelocity() {
    /*
      Vec2 getForwardVelocity() - return the forward velocity of the car
     */
    Vec2 currentForwardNormal = body.getWorldVector(new Vec2(1, 0));
    float magnitude = Vec2.dot(currentForwardNormal, body.getLinearVelocity());
    return currentForwardNormal.mul(magnitude);
  }

  void updateFriction() {
    /*
      void updateFriction() - update linear (drag) and angular friction (inertia)
     */

    // Lateral Linear Velocity (Friction)
    float maxLateralImpulse = 20; // allows for skidding and drifting
    Vec2 impulse = getLateralVelocity().mul(-body.getMass());
    if (impulse.length() > maxLateralImpulse) {
      impulse.mulLocal(maxLateralImpulse / impulse.length());
    }
    body.applyLinearImpulse(impulse, body.getWorldCenter(), true); // partially cancel lateral velocity
    // Angular Velocity (Inerita)
    body.applyAngularImpulse(-0.1*body.getInertia()*body.getAngularVelocity()); // prevents rotating in place
    // Forward Linear Velocity (Drag)
    Vec2 currentForwardNormal = getForwardVelocity();
    float currentForwardSpeed = currentForwardNormal.normalize();
    float dragForceMagnitude = -2 * currentForwardSpeed;
    body.applyForce(currentForwardNormal.mul(dragForceMagnitude), body.getWorldCenter());
  }

  void updateFitness() {
    /*
      void updateFitness() - updates fitness of car
     */
    if (isColliding) {
      fitness -= 10;
    }
    //println(str(millis()-timer.start));
    if (timer.timeElapsed() >= 3000) {
      timer.reset();
      currPos =  box2d.getBodyPixelCoord(body);
      dist = abs((currPos.sub(prevPos)).length());
      if (dist < 10) {
        fitness -= 2000;
      } else {
        fitness += 7 * dist;
      }
    }
    prevPos = currPos;
  }


  void update() {
    /*
      void update() - update states of the Car
     */

    float throttle, steerTorque; // throttle is linear force and steerTorque is angular force
    updateFriction();
    checkSensors();
    NN.forward(input);

    // Update steering direction
    steerTorque = map(NN.yHat.matrix[0][0], -1, 1, -50, 50);
    body.applyTorque(steerTorque);
    throttle = map(NN.yHat.matrix[0][1], -1, 1, 0, 50); 
    // Update throttle and apply necessary force
    float desiredSpeed = 50;
    float currentForwardSpeed =  getForwardVelocity().length();  //.normalize()?
    //print("\nSpeed: " + str(currentForwardSpeed) + "\n");
    if (abs(currentForwardSpeed) < desiredSpeed) {
      float angle = body.getAngle() % TWO_PI;
      //println(angle *(180/PI));
      Vec2 force = new Vec2(throttle*cos(angle), throttle*sin(angle)); // apply force is forward direction of car
      body.applyForce(force, body.getWorldCenter());
    }

    // Update Sensors
    float currLocalAngle = body.getAngle() % TWO_PI;
    for (int i = 0; i < numSensors; i++) {
      float f = sensorLocalAngles[i] + currLocalAngle;
      sensors[i] = new Vec2(cos(f), sin(f));
    }


    prevLocalAngle = currLocalAngle;
    updateFitness();
  }

  void checkSensors() {
    /*
      void checkSensors() - give the car inputs from its sensors
     */

    Vec2 p1 = box2d.coordPixelsToWorld(box2d.getBodyPixelCoord(body));
    for (int i = 0; i < numSensors; i++) {
      Vec2 p2  = sensors[i].mul(box2d.scalarPixelsToWorld(rayLength));
      p2.addLocal(p1);
      ccallback.reset();
      box2d.world.raycast(ccallback, p1, p2);
      if (ccallback.m_hit) {
        sensorFractions[i] = ccallback.m_fraction;
        input[0][i] = 1.0 - ccallback.m_fraction;
      } else {
        input[0][i] = 0;
        sensorFractions[i] = 1;
      }
      //println("Fraction : " + str(ccallback.m_fraction));
    }
  }

  void die() {
    /*
      void die() - kills the box2d body
     */
    box2d.destroyBody(body);
  }

  void render() {
    /*
      void render() - display the Car, Sensors and NN
     */


    rectMode(CENTER); 
    ellipseMode(CENTER); 
    Vec2 p1 = box2d.getBodyPixelCoord(body); // We look are each body and get its screen position
    x = p1.x;
    y = p1.y;
    float a = body.getAngle(); // Get its angle of rotation

    if (displayNN) { 
      rgb[0] = 255; 
      rgb[1] = 0; 
      rgb[2] = 0; 
      //NN.render();
    } else { 
      rgb[0] = 150; 
      rgb[1] = 150; 
      rgb[2] = 150;
    }
    fill(rgb[0], rgb[1], rgb[2], rgb[3]); 
    stroke(rgb[0], rgb[1], rgb[1]);


    pushMatrix();
    translate(p1.x, p1.y);
    if (displayNN) {
      for (int i = 0; i < numSensors; i++) {
        float f = sensorLocalAngles[i] + (body.getAngle()%TWO_PI) - PI/2;
        Vec2 p2 = new Vec2(sin(f), cos(f));
        p2.mulLocal(-rayLength * sensorFractions[i]);
        strokeWeight(0);
        line(0, 0, p2.x, p2.y);
      }
    }

    rotate(-a);

    strokeWeight(1); 
    rect(0, 0, w, h);
    ellipse(w/3, 0, 2, 2);

    popMatrix();
  }

  void displayNN(boolean flag) {
    displayNN = flag;
    if (displayNN) {
      println("ID: " + str(ID));
      println("Fitness: " + str(fitness));
      println("Distance:" + str(dist));
      println("Velocity: " + str(getForwardVelocity().length()));
      println("Position: " + str(currPos.x) + ", " + str(currPos.y));
      print("Collision: ");
      if (isColliding) { 
        println("true\n");
      } else {
        println("false\n");
      }
    }
  }


  int compareTo(Object compareCar) {
    float compareFitness = ((Car)compareCar).fitness;
    return Float.compare(fitness, compareFitness);
  }

  String toString() {
    return "";
  }
}