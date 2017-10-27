import controlP5.*;

ControlP5 control;
Perceptron brain;

Point[] points =  new Point[1000]; // Initiallizing/Instantiating Point objects 
int trainingIndex = 0;
float L_RATE = 0.01;


void setup() {
  size(600, 600);
  control = new ControlP5(this);
  brain = new Perceptron(3); // Constructing a new brain
  for (int i = 0; i < points.length; i++) {
    points[i] = new Point(); // Constructing new Point objects
  }
  Slider slider = control.addSlider("L_RATE", 0.01, 0.1, 0.1, 100, 50, 50, 10 );
  //control.addSlider("var_name", min, max, default, x, y, w, l)


  //float [] inputs = {-1, 0.5};
  //int guess = brain.guess(inputs);
  ///println(guess);
}

void draw() {
  background(255);
  brain.lr = L_RATE/10;
  stroke(0);
  Point p1 = new Point(-1, f(-1));
  Point p2 = new Point (1, f(1));
  line(p1.pixelX(), p1.pixelY(), p2.pixelX(), p2.pixelY());
  Point p3 = new Point(-1, brain.guessY(-1));
  Point p4 = new Point(1, brain.guessY(1));
  stroke(0, 0, 255);
  line(p3.pixelX(), p3.pixelY(), p4.pixelX(), p4.pixelY());

  for (Point pt : points) {
    pt.show();
    float[] inputs = {pt.x, pt.y, pt.bias};
    int target = pt.label;
    int guess = brain.guess(inputs);
    if (guess == target) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }
    noStroke();
    ellipse(pt.pixelX(), pt.pixelY(), 8, 8);
  }

  Point training = points[trainingIndex];
  float[] inputs = {training.x, training.y, training.bias};
  int target = training.label;
  brain.train(inputs, target);
  trainingIndex++;
  if (trainingIndex == points.length) {
    trainingIndex = 0;
  }

  brain.visualize();
}

/*
void mousePressed(){
 // Training occurs only when mouse is pressed
 for (Point pt: points){
 float[] inputs = {pt.x, pt.y};
 int target = pt.label;
 brain.train(inputs, target);
 }
 }
 */