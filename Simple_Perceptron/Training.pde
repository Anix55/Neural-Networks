float f(float x){
  // y = mx + b
  return -4.53 * x + .23;
}


// Data set to train perceptron with
class Point{
  float x;
  float y;
  float bias;
  int label;
  
  Point(){
    // cartesian coordinates
    x = random(-1, 1);
    y = random(-1,1);
    bias = 1;
    //println(slope);
    if (f(x) < y){
      label = 1;
    }else{
      label = -1;
    }
  }
  
  Point (float x_, float y_){
    // overloaded constructor
    x = x_;
    y = y_;
  }
  float pixelX(){
    return map(x, -1, 1, 0, width);
  }
  float pixelY(){
    return map(y, -1, 1, height, 0);
  }
  
  void show(){
    stroke(0);
    if (label == 1){
      fill(255);
    }else{
      fill(0);
    }
    float px = pixelX();
    float py = pixelY();
    ellipse(px,py,16, 16);
  }
}