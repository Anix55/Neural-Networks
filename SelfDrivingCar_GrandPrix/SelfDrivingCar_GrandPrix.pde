/*  //<>//
 Evolving Neural Network: Grand Prix
 Author: Aniekan Umoren
 Created: Sun Sep 10, 2017
 Completed (Functional): Fri Oct 6, 2017
 */

// Imports

import controlP5.*;
import java.util.*;
import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.callbacks.ContactImpulse;
import org.jbox2d.callbacks.ContactListener;
import org.jbox2d.collision.Manifold;
import org.jbox2d.dynamics.contacts.Contact;
import org.jbox2d.callbacks.RayCastCallback;
import org.jbox2d.dynamics.World;


class StatePrintWriter extends PrintWriter {
  StatePrintWriter(PrintWriter writer) {
    super(writer);
  }

  boolean isOpen() {
    return out != null;
  }
}


Box2DProcessing box2d;
ControlP5 cp5;
int populationSize, numBoundaries, HI_LITE, ticks, GENERATION;
float fitness[];
float minFitness, maxFitness, MUTATION_RATE, COLLISION_DMG;
ArrayList <Car> Population;
ArrayList<Boundary> boundaries;
ArrayList<float[]> genePool;
PFont font;
Environment outerRing, innerRing;
ArrayList<Vec2> outer, inner;
int numOuterPoints, numInnerPoints;
StatePrintWriter fossilRecord;
String [] fossil;
String MODE, input;


void setup() {
  fullScreen();
  //size(1000, 700);
  frameRate(60);
  MODE = "EVOLVE"; // Possibles Modes: EVOLVE, REVIVE and QUIT
  fossilRecord = new StatePrintWriter(createWriter("fossilRecord.txt"));
  box2d = new Box2DProcessing(this);

  // Initializing a BOX2D world
  box2d.createWorld();
  box2d.setGravity(0, 0);
  box2d.listenForCollisions();

  // Creating World Boundaries
  boundaries = new ArrayList<Boundary>();
  numBoundaries = 50;
  for (int i = 0; i < numBoundaries; i++) {
    float angle = random(0, TWO_PI);
    Vec2 point = new Vec2 (sin(angle), cos(angle));
    point.mulLocal(random(160, 320));
    point.addLocal(new Vec2(width/2, height/2));
    boundaries.add(new Boundary(point.x, point.y, 10, 10));
  }
  // Initializing the environment
  numOuterPoints = 12;
  numInnerPoints = 12;
  outer = new ArrayList<Vec2>();
  inner = new ArrayList<Vec2>();
  for (float angle = 3*PI/2; angle < 7*PI/2; angle += TWO_PI/numOuterPoints) {
    Vec2 point = new Vec2(sin(angle), cos(angle));
    point.mulLocal(340);
    point.addLocal(new Vec2(width/2, height/2));
    outer.add(point);
  }
  for (float angle = 3*PI/2; angle < 7*PI/2; angle += TWO_PI/numInnerPoints) {
    Vec2 point = new Vec2(sin(angle), cos(angle));
    point.mulLocal(150);
    point.addLocal(new Vec2(width/2, height/2));
    inner.add(point);
  }
  outerRing = new Environment(outer);
  innerRing = new Environment(inner);

  // Creating Initial Population
  populationSize = 20;
  Population = new ArrayList<Car>();
  for (int i = 0; i < populationSize; i++) {
    Population.add(new Car(new float[0], true));
  }
  minFitness = 0;
  maxFitness = 0;
  font = createFont("Consolas", 12);

  // Creating User Control Interface
  HI_LITE = 0;
  input = new String();
  cp5 = new ControlP5(this);
  cp5.addSlider("HI_LITE", 0, populationSize-1, 0, 10, height-20, 55, 10) 
    .setColorBackground(color(255, 255, 255))
    .setFont(font)
    ;

  cp5.addKnob("MUTATION_RATE")
    .setRange(0.01, 0.1)
    .setValue(0.01)
    .setPosition(width-80, 20)
    .setFont(font)
    .setRadius(25)
    .setDragDirection(Knob.HORIZONTAL)
    .setNumberOfTickMarks(10)
    .setColorForeground(color(255))
    .setColorBackground(color(100, 100, 100))
    .setColorActive(color(255, 255, 0))
    ;

  cp5.addKnob("COLLISION_DMG")
    .setRange(5, 50)
    .setValue(5)
    .setPosition(width-200, 20)
    .setFont(font)
    .setRadius(25)
    .setDragDirection(Knob.HORIZONTAL)
    .setNumberOfTickMarks(10)
    .setColorForeground(color(255))
    .setColorBackground(color(100, 100, 100))
    .setColorActive(color(255, 255, 0))
    ;



  ticks = 0;
  GENERATION = 1;
  fitness = new float[populationSize];
}

void draw() {
  background(0);

  box2d.step();

  if (MODE == "EVOLVE") {
    if (!fossilRecord.isOpen()) {
      fossilRecord = new StatePrintWriter(createWriter("fossilRecord.txt"));
      Population = new ArrayList<Car>();
      for (int i = 0; i < populationSize; i++) {
        Population.add(new Car(new float[0], true));
      }
      cp5.remove("input");
      cp5.getController("MUTATION_RATE").show();
      cp5.getController("COLLISION_DMG").show();
      HI_LITE = 0;
      ticks = 0;
      GENERATION = 1;
      fitness = new float[populationSize];
    }
    outerRing.display();
    innerRing.display();
    for (Boundary b : boundaries) {
      b.render();
    }

    for ( Car c : Population) {
      if (Population.indexOf(c) == HI_LITE) {
        c.displayNN(true);
      } else {
        c.displayNN(false);
      }
      c.update();
      c.render();
      fitness[Population.indexOf(c)] = c.fitness;
    }
    fill(255);
    textFont(createFont("Consolas", 15));
    text("GENERATION: " + str(GENERATION), 10, height-30);

    /*
    Genetic Algorithm Portion
     */
    if (ticks >= frameRate*30) {
      genePool = new ArrayList<float[]>();
      ticks = 0;
      float total = 0.0;
      for (Car c : Population) {
        if (c.fitness < minFitness) {
          minFitness = c.fitness;
        } else if (c.fitness > maxFitness) {
          maxFitness = c.fitness;
        }
      }
      for (Car c : Population) {
        c.fitness = map(c.fitness, minFitness, maxFitness, 0, 10);
        fitness[Population.indexOf(c)] = c.fitness;
      }
      for (int i = 0; i < populationSize; i++) {
        total += fitness[i];
      }
      for (int i = 0; i < populationSize; i++) {
        fitness[i] = fitness[i] / total;
        float [] tempDNA = Population.get(i).genes;
        for (int j = 0; j < fitness[i]*100; j++) {
          genePool.add(tempDNA);
        }
      }
      Collections.sort(Population);
      /*for (Car c : Population) {
       println(c.fitness);
       }*/
      for (int i = 0; i < populationSize/2; i++) { // Making room for the next generation
        Population.get(0).die();
        Population.remove(0);
      }
      String tDNA = new String();
      for (float f : Population.get(Population.size()/2 - 1).genes) {
        tDNA = tDNA + str(f) + " ";
      }
      fossilRecord.println(tDNA.substring(0, tDNA.length()-1));

      for (int i = 0; i < 2; i++) { // Implementing elitism
        boolean mutate = false;
        if (random(0, 1) < MUTATION_RATE) {
          mutate = true;
        }
        Car parent = new Car(Population.get(Population.size()/2 - 1).genes, false); // Implementation of elitism
        Population.add(new Car(parent.genes, mutate));
        parent.die();
      }

      for (int i = 0; i < populationSize * 0.2 - 2; i++) { //allow 20% percent of population to be clones
        boolean mutate = false;
        if (random(0, 1) < MUTATION_RATE) {
          mutate = true;
        }
        int p = int(random(genePool.size()));
        Car parent = new Car(genePool.get(p), false);
        Population.add(new Car(parent.genes, mutate));
        parent.die();
      }

      for (int i = 0; i < Population.size(); i++) {
        Population.get(i).fitness = 0;
      }

      for (int i = Population.size(); i < populationSize; i++) {
        boolean mutate = false;
        int a = int(random(genePool.size()));
        int b = int(random(genePool.size()));
        Car parentA = new Car(genePool.get(a), false);
        Car parentB = new Car(genePool.get(b), false);
        if (random(0, 1) < MUTATION_RATE) {
          mutate = true;
        }
        Population.add(new Car(parentA.NN.crossOver(parentB.NN.chromosome), mutate));
        parentA.die();
        parentB.die();
      }
      GENERATION++;
    }
    ticks++;
  } else if (MODE == "REVIVE") {
    background(0);
    if (fossilRecord.isOpen()) {
      /*
        This if statement acts as a run-time setup() function
       It is called when ever the MODE is changed to "REVIVE"
       */
      fossilRecord.flush();
      fossilRecord.close();
      input = new String();
      cp5.addTextfield("input")
        .setPosition(12, height-55)
        .setSize(102, 12)
        .setFont(font)
        .setColorLabel(color(255))
        .setFocus(true)
        .setColorCursor(color(255))
        .setColor(color(255))
        .setAutoClear(true)
        ;

      cp5.getController("MUTATION_RATE").hide();
      cp5.getController("COLLISION_DMG").hide();

      for (int i = 0; i < populationSize; i++) {
        Population.get(i).die();
      }
      Population = new ArrayList<Car>();
    }

    outerRing.display();
    innerRing.display();
    for (Boundary b : boundaries) {
      b.render();
    }
    if (Population.size() == populationSize) {
      /*
        Draw Environment and cars
       */
      for ( Car c : Population) {
        if (Population.indexOf(c) == HI_LITE) {
          c.displayNN(true);
        } else {
          c.displayNN(false);
        }
        c.update();
        c.render();
      }
    }
  } else if (MODE == "QUIT") {
    if (fossilRecord.isOpen()) {
      fossilRecord.flush();
      fossilRecord.close();
    }
    exit();
  }
} 


/*
 Collisions Listeners: beginContact(), endContact()
 Detect when collisions have begun/ended
 */
void beginContact(Contact cp) {
  //print("collided\n");
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  /*print("BEGIN CONTACT:\n");
   print(o1.getClass());
   print("\n");
   print(o2.getClass());
   print("\n");
   */

  if (o1.getClass() == Car.class) {
    Car c1 = (Car) o1;
    c1.fitness -= COLLISION_DMG;
    c1.isColliding = true;
  } else if (o2.getClass() == Car.class) {
    Car c2 = (Car) o2;
    c2.fitness -= COLLISION_DMG;
    c2.isColliding = true;
  }
}

void endContact(Contact cp) {
  //print("collided\n");
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();

  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  /*print("END CONTACT:\n");
   print(o1.getClass());
   print("\n");
   print(o2.getClass());
   print("\n");
   */

  if (o1.getClass() == Car.class) {
    Car c1 = (Car) o1;
    c1.isColliding = false;
  } else if (o2.getClass() == Car.class) {
    Car c2 = (Car) o2;
    c2.isColliding = false;
  }
}

void keyPressed() {
  if (key == 'R') {
    MODE = "REVIVE";
  }
  if (key == 'E') {
    MODE = "EVOLVE";
  }
  if (key == 'Q') {
    MODE = "QUIT";
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Textfield.class)) {
    input = theEvent.getStringValue();
  }

  if (input.equals("new race")) {
    for (int i = 0; i < populationSize; i++) {
      Population.get(i).die();
    }
    Population = new ArrayList<Car>();
    
  } else if (input.equals("new course")) {
    for (int i = 0; i < numBoundaries; i++) {
      boundaries.get(i).killBoundary();
    }
    boundaries = new ArrayList<Boundary>();
    for (int i = 0; i < numBoundaries; i++) {
      float angle = random(0, TWO_PI);
      Vec2 point = new Vec2 (sin(angle), cos(angle));
      point.mulLocal(random(160, 320));
      point.addLocal(new Vec2(width/2, height/2));
      boundaries.add(new Boundary(point.x, point.y, 10, 10));
    }
    input = "";
    
  } else if (input.equals("random")) {
    while (Population.size() < populationSize) {
      String[] lines = loadStrings("revival.txt");
      int genNum = int(random(0, lines.length));
      float [] DNA = float(split(lines[genNum], ' '));
      print("success");
      Population.add(new Car(DNA, true));
    }
    
  } else if (input.matches("[0-9]+")) {
    if (Population.size() < populationSize) {
      String[] lines = loadStrings("revival.txt");
      int genNum = Integer.parseInt(input) - 1;
      float [] DNA = float(split(lines[genNum], ' '));
      for (float f : DNA) {
        print(str(f) + " ");
      }
      print("\n");
      println(str(genNum) + " success");
      Population.add(new Car(DNA, false));
    }
  }
}