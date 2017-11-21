//<>// //<>//
class Neural_Network {
  /* 
   Neural Network Procedure Overview
   z2 = XW1
   a2 = f(z2)
   z3 = a2W2
   y = f(z3)
   */

  // Variables to keep track of
  Matrix x, yHat;
  Matrix [] weights; // stores matrices of each layer of weights
  Matrix [] a; // stores matrices of each layer of activity
  Matrix [] z; // stores each layer of weighted sums
  Matrix [] biases; // stores all baises
  Matrix [] biasNodes; // used in backpropagation
  float [] displaySize; // controls display size of the NN
  float [][][] nodePos; // stores positions of nodes on screen
  float nodeSize, weightDecay, learningRate;
  int inputLayerSize, hiddenLayerSize, outputLayerSize, numHiddenLayers, numExamples, MAX;
  float [] visWeights; // used to visualize 


  Neural_Network(int inputLayerSize_, int hiddenLayerSize_, int outputLayerSize_, int numHiddenLayers_, int numExamples_ ) {

    //Define HyperParameters
    inputLayerSize = inputLayerSize_;
    hiddenLayerSize = hiddenLayerSize_;
    outputLayerSize= outputLayerSize_;
    numHiddenLayers = numHiddenLayers_;
    numExamples = numExamples_;
    weightDecay = 0;
    learningRate = 0.07;

    // Set lenghts of array matrix containers
    weights = new Matrix[numHiddenLayers+1];
    biases = new Matrix[numHiddenLayers+1];
    biasNodes = new Matrix[numHiddenLayers+1];
    a = new Matrix[numHiddenLayers+1]; // a[1] (last elem) is yHat
    z = new Matrix[numHiddenLayers+1]; // z[1] (last elem) is yHat w/o sigmoid
    if (numHiddenLayers == 0) {
      visWeights = new float[(inputLayerSize + 1)*outputLayerSize];
    } else {
      visWeights = new float[(inputLayerSize + 1)*hiddenLayerSize + (numHiddenLayers - 1)*(hiddenLayerSize + 1)*(hiddenLayerSize) + (hiddenLayerSize + 1)*outputLayerSize];
    }

    // Weights are matrix that are multiplied by activity of prev layer to get activity of next layer
    // Dimension of Weights -> inputLayerSize * hiddenLayerSize or hiddenLayerSize^2 or hiddenLayerSize * outputLayerSize
    // Dimensions of Biases -> numExamples * hiddenLayerSize or numExamples * outputLayerSize

    int weight_iter = 0;
    int bias_iter = 0;
    float [][] B;
    float [] b;

    int vis_iter = 0;
    if (numHiddenLayers == 0) {
      // Weight and Bias Matrix between input and output layer
      float [][] W = new float [inputLayerSize][outputLayerSize];
      for (int i = 0; i < inputLayerSize; i++) {
        for (int j = 0; j < outputLayerSize; j++) {
          W[i][j] = random(-1, 1);
          visWeights[vis_iter] = W[i][j];
          vis_iter++;
        }
      }
      weights[weight_iter] = new Matrix(W);
      weight_iter++;
      // Creating Bias Matrix
      B = new float [1][outputLayerSize];
      b = new float[outputLayerSize];
      for (int i = 0; i < outputLayerSize; i++) {
        b[i] = random(-1, 1);
        visWeights[vis_iter] = b[i];
        vis_iter++;
      }
      for (int i = 0; i < 1; i++) {
        B[i] = b;
      }
      biases[bias_iter] = new Matrix(B);
      bias_iter++;
    } else {
      // Weight and Bias matrix between input and first hidden layer
      float [][] W = new float [inputLayerSize][hiddenLayerSize];
      for (int i = 0; i < inputLayerSize; i++) {
        for (int j = 0; j < hiddenLayerSize; j++) {
          W[i][j] = random(-1, 1);
          visWeights[vis_iter] = W[i][j];
          vis_iter++;
        }
      }
      weights[weight_iter] = new Matrix(W);
      weight_iter++;

      B = new float [1][hiddenLayerSize];
      b = new float[hiddenLayerSize];
      for (int i = 0; i < hiddenLayerSize; i++) {
        b[i] = random(-1, 1);
        visWeights[vis_iter] = b[i];
        vis_iter++;
      }
      for (int i = 0; i < 1; i++) {
        B[i] = b;
      }
      biases[bias_iter] = new Matrix(B);
      bias_iter++;


      // Weight and Bias matrix between hidden layers
      for (int h = 0; h < numHiddenLayers-1; h++) {
        W = new float [hiddenLayerSize][hiddenLayerSize];
        for (int i = 0; i < hiddenLayerSize; i++) {
          for (int j = 0; j < hiddenLayerSize; j++) {
            W[i][j] = random(-1, 1);
            visWeights[vis_iter] = W[i][j];
            vis_iter++;
          }
        }
        weights[weight_iter] = new Matrix(W);
        weight_iter++;
        B = new float [1][hiddenLayerSize];
        b = new float [hiddenLayerSize];
        for (int i = 0; i < hiddenLayerSize; i++) {
          b[i] = random(-1, 1);
          visWeights[vis_iter] = b[i];
          vis_iter++;
        }
        for (int i = 0; i < 1; i++) {
          B[i] = b;
        }
        biases[bias_iter] = new Matrix(B);
        bias_iter++;
      }


      // Weight and Bias matrix between hidden and output layer
      W = new float [hiddenLayerSize][outputLayerSize];
      for (int i = 0; i < hiddenLayerSize; i++) {
        for (int j = 0; j < outputLayerSize; j++) {
          W[i][j] = random(-1, 1);
          visWeights[vis_iter] = W[i][j];
          vis_iter++;
        }
      }
      weights[weight_iter] = new Matrix(W);
      weight_iter++;
      B = new float[1][outputLayerSize];
      b = new float [outputLayerSize];
      for (int i = 0; i < outputLayerSize; i++) {
        b[i] = random(-1, 1);
        visWeights[i] = b[i];
        vis_iter++;
      }
      for (int i = 0; i < 1; i++) {
        B[i] = b;
      }
      biases[bias_iter] = new Matrix(B);
      bias_iter++;
    }

    // Initialize bias nodes
    B = new float[numExamples][1];
    for (int i = 0; i < numExamples; i++) {
      B[i][0] = 1.0;
    }
    Arrays.fill(biasNodes, new Matrix(B));

    /*
      INITIALIZING NEURAL NETWORK VISUALIZATION VALUES
     */
    displaySize = new float[2];
    displaySize[0] = width * (0.35);
    displaySize[1] = height * (0.35);
    nodeSize = 10;
    if (inputLayerSize+1 > hiddenLayerSize+1 && inputLayerSize+1 > outputLayerSize) { // +1 for biases
      MAX = inputLayerSize+1;
    } else if (hiddenLayerSize+1 > outputLayerSize && hiddenLayerSize+1 > outputLayerSize) {
      MAX = hiddenLayerSize+1;
    } else {
      MAX = outputLayerSize;
    }
    nodePos = new float[numHiddenLayers+2][MAX][2];

    // Initialize variables
    float [][] init_x = new float [numExamples][inputLayerSize];
    for (int i = 0; i < numExamples; i++) {
      for (int j = 0; j < inputLayerSize; j++) {
        init_x[i][j] = 0.0;
      }
    }

    forward(new Matrix(init_x)); // initialize activation matrix
    initNN();
  }

  void testNetwork() {
    /*
      void testNetwork() - creates a deterministic simple network
     */

    //Define HyperParameters
    inputLayerSize = 1;
    hiddenLayerSize = 0;
    outputLayerSize= 1;
    numHiddenLayers = 0;
    numExamples = 3;
    weightDecay = 0;
    learningRate = 0.07;

    // Set lenghts of array matrix containers
    weights = new Matrix[numHiddenLayers+1];
    biasNodes = new Matrix[numHiddenLayers+1];
    biases = new Matrix[numHiddenLayers+1];
    a = new Matrix[numHiddenLayers+1]; // a[1] (last elem) is yHat
    z = new Matrix[numHiddenLayers+1]; // z[1] (last elem) is yHat w/o sigmoid
    if (numHiddenLayers == 0) {
      visWeights = new float[(inputLayerSize + 1)*outputLayerSize];
    } else {
      visWeights = new float[(inputLayerSize + 1)*hiddenLayerSize + (numHiddenLayers - 1)*(hiddenLayerSize + 1)*(hiddenLayerSize) + (hiddenLayerSize + 1)*outputLayerSize];
    }


    int weight_iter = 0;
    int bias_iter = 0;
    float [][] B;
    float [] b;

    int vis_iter = 0;

    // Weight and Bias Matrix between input and output layer
    float [][] W = new float [inputLayerSize][outputLayerSize];
    for (int i = 0; i < inputLayerSize; i++) {
      for (int j = 0; j < outputLayerSize; j++) {
        W[i][j] = 0.5; // deterministic
        visWeights[vis_iter] = W[i][j];
        vis_iter++;
      }
    }
    weights[weight_iter] = new Matrix(W);
    weight_iter++;

    B = new float [1][outputLayerSize];
    b = new float[outputLayerSize];
    for (int i = 0; i < outputLayerSize; i++) {
      b[i] = 0.5;
      visWeights[vis_iter] = b[i];
      vis_iter++;
    }
    for (int i = 0; i < 1; i++) {
      B[i] = b;
    }
    biases[bias_iter] = new Matrix(B);
    bias_iter++;

    // Initialize bias nodes
    B = new float[numExamples][1];
    for (int i = 0; i < numExamples; i++) {
      B[i][0] = 1.0;
    }
    Arrays.fill(biasNodes, new Matrix(B));

    /*
      INITIALIZING NEURAL NETWORK VISUALIZATION VALUES
     */
    displaySize = new float[2];
    displaySize[0] = width * (0.35);
    displaySize[1] = height * (0.35);
    nodeSize = 10;
    if (inputLayerSize+1 > hiddenLayerSize+1 && inputLayerSize+1 > outputLayerSize) { // +1 for biases
      MAX = inputLayerSize+1;
    } else if (hiddenLayerSize+1 > outputLayerSize && hiddenLayerSize+1 > outputLayerSize) {
      MAX = hiddenLayerSize+1;
    } else {
      MAX = outputLayerSize;
    }
    nodePos = new float[numHiddenLayers+2][MAX][2];

    // Initialize variables
    float [][] init_x = new float [numExamples][inputLayerSize];
    for (int i = 0; i < numExamples; i++) {
      for (int j = 0; j < inputLayerSize; j++) {
        init_x[i][j] = 0.0;
      }
    }

    forward(new Matrix(init_x)); // initialize activation matrix
    initNN();
  }



  void setBatchSize(int numExamples_) {
    /*
      void setBatchSize(int numExamples) - changes the number of rows for biases
     int numExamples - number of rows for input
     */
    if (numExamples_ < numExamples) {
      for (int i = 0; i < biases.length; i++) {
      }
    }
  }


  Matrix logistic(Matrix z) {
    /*
      float [][] logistic(float[][] z) - Applies logistic sigmoid function
     float [][] z - matrix values
     */
    for (int i = 0; i < z.matrix.length; i++) {
      for (int j = 0; j < z.matrix[0].length; j++) {
        z.matrix[i][j] = 1/(1+exp(-1*z.matrix[i][j]));
      }
    }
    return z;
  }

  Matrix logistic_Prime(Matrix z) {
    /*
      float [][] logistic_Prime(float[][] z) - Applies the derivative of logistic sigmoid function
     float [][] z - matrix values
     */
    for (int i = 0; i < z.matrix.length; i++) {
      for (int j = 0; j < z.matrix[0].length; j++) {
        z.matrix[i][j] = 1 - (1/(1+exp(-1*z.matrix[i][j])));
      }
    }
    return z;
  }

  Matrix hypTan(Matrix z) {
    /*
      float [][] hypTan(float[][] z) - Applies hyperbolic tangent sigmoid activation funtion
     float [][] z - matrix values
     */
    for (int i = 0; i < z.matrix.length; i++) {
      for (int j = 0; j < z.matrix[0].length; j++) {
        float x = z.matrix[i][j];
        z.matrix[i][j] = ( exp(x) - exp(-x) )/( exp(x) + exp(-x) );
      }
    }
    return z;
  }

  Matrix hypTan_Prime(Matrix z) {
    /*
      float [][] hypTan_Prime(float[][] z) - Applies the derivative of thhe hyperbolic tangent sigmoid activation funtion
     float [][] z - matrix values
     */
    for (int i = 0; i < z.matrix.length; i++) {
      for (int j = 0; j < z.matrix[0].length; j++) {
        float x = z.matrix[i][j];
        if (x == 0) {
          z.matrix[i][j] = 1;
        } else {
          z.matrix[i][j] = (  pow(2/(exp(x) + exp(-x)), 2) );
        }
      }
    }
    return z;
  }

  Matrix ReLU(Matrix z) {
    /*
      float [][] ReLU(float[][] z) - Applies the rectified linear unit activation funtion
     float [][] z - matrix values
     */
    Matrix result = new Matrix("0", 1, 1);
    result.copyMatrix(z);
    for (int i = 0; i < result.matrix.length; i++) {
      for (int j = 0; j < result.matrix[0].length; j++) {
        if (result.matrix[i][j] < 0) {
          result.matrix[i][j] = 0.01*(result.matrix[i][j]);
        } else {
          result.matrix[i][j] = result.matrix[i][j];
        }
      }
    }
    return result;
  }

  Matrix ReLU_Prime(Matrix z) {
    /*
      float [][] ReLU_Prime(float[][] z) - Applies the derivative of the rectified linear unit activation funtion
     float [][] z - matrix values
     */
    Matrix result = new Matrix("0", 1, 1);
    result.copyMatrix(z);
    for (int i = 0; i < result.matrix.length; i++) {
      for (int j = 0; j < result.matrix[0].length; j++) {
        if (result.matrix[i][j] < 0) {
          result.matrix[i][j] = 0.01;
        } else {
          result.matrix[i][j] = 1;
        }
      }
    }
    return result;
  }

  void forward(Matrix x_) {
    /*
      void forward(float [][]x_) - Propagate inputs and activites through the network
     float [][] x_ - input values
     */

    x = x_; // stores values in Matrix object to get functionality

    if (numHiddenLayers == 0) { 
      // Propagate inputs to output layer
      z[0] = x.dotProduct(weights[0]).addMatrix(biasNodes[0].dotProduct(biases[0]));
      a[0] = ReLU(z[0]);
    } else {
      // Propagate inputs to first hidden layer
      z[0] = x.dotProduct(weights[0]).addMatrix(biasNodes[0].dotProduct(biases[0]));
      a[0] = ReLU(z[0]);
      for (int i = 1; i < numHiddenLayers; i++) {
        // Propagate inputs through hidden layers
        z[i] = a[i-1].dotProduct(weights[i]).addMatrix(biasNodes[i].dotProduct(biases[i]));
        a[i] = ReLU(z[i]);
      }
      // Propagate inputs from last hidden layer to output layer
      z[z.length - 1] = a[a.length-2].dotProduct(weights[weights.length - 1]).addMatrix(biasNodes[biases.length - 1].dotProduct(biases[biases.length - 1]));
      a[a.length - 1] = ReLU(z[z.length - 1]);
    } 
    yHat = new Matrix( a[a.length - 1].matrix );
  }

  ArrayList<ArrayList<Matrix>> backProp(Matrix X, Matrix y) {
    /*
      void backProp(Matrix X, MatrixY) - used to train Neural Network
     Determines the contribution of each weight towards the error
     */
    ArrayList <Matrix> dJdW = new ArrayList(); // stores matrices of each dJdW value
    ArrayList <Matrix> dJdWb = new ArrayList(); // stores matrices of each dJdWb value
    ArrayList <Matrix> delta = new ArrayList(); // stores matrices of each backpropagating error
    ArrayList<ArrayList<Matrix>> result = new ArrayList<ArrayList<Matrix>>(); 
    forward(X);

    // Quantifying Error
    println("ERROR: " + str(y.relativeError(yHat)));

    if (numHiddenLayers == 0) {
      // Backpropagate error from output layer to input Layer
      delta.add(0, y.subtractMatrix(yHat).multiplyScalar(-1).multiplyMatrix(ReLU_Prime(z[z.length-1])));
      dJdW.add(0, X.transpose().dotProduct(delta.get(0)).addMatrix(weights[0].multiplyScalar(weightDecay)));
      dJdWb.add(0, biasNodes[0].transpose().dotProduct(delta.get(0)).addMatrix(biases[0].multiplyScalar(weightDecay)));
    } else {
      // Compute derivative wrt to W
      delta.add(0, y.subtractMatrix(yHat).multiplyScalar(-1).multiplyMatrix(ReLU_Prime(z[z.length-1])));
      dJdW.add(0, a[a.length-2].transpose().dotProduct(delta.get(0)).addMatrix(weights[weights.length-1].multiplyScalar(weightDecay)));
      dJdWb.add(0, biasNodes[biasNodes.length-1].transpose().dotProduct(delta.get(0)).addMatrix(biases[biasNodes.length-1].multiplyScalar(weightDecay)));
      for (int i = weights.length-1; i > 1; i--) {
        // Iterate from self.weights[-1] -> self.weights[1]
        delta.add(0, delta.get(0).dotProduct(weights[i].transpose()).multiplyMatrix(ReLU_Prime(z[i-1])));
        dJdW.add(0, a[i-2].transpose().dotProduct(delta.get(0)).addMatrix(weights[i-1].multiplyScalar(weightDecay)));
        dJdWb.add(0, biasNodes[i-1].transpose().dotProduct(delta.get(0)).addMatrix(biases[i-1].multiplyScalar(weightDecay)));
      }
      delta.add(0, delta.get(0).dotProduct(weights[1].transpose()).multiplyMatrix(ReLU_Prime(z[0])));
      dJdW.add(0, X.transpose().dotProduct(delta.get(0)).addMatrix(weights[0].multiplyScalar(weightDecay)));
      dJdWb.add(0, biasNodes[0].transpose().dotProduct(delta.get(0)).addMatrix(biases[0].multiplyScalar(weightDecay)));
    }
    result.add(dJdW);
    result.add(dJdWb);
    return result;
  }

  float error(Matrix a, Matrix b) {
    /*
      float error(Matrix a, Matrix b): quantifies error between a and b
     */
    // Quantifying Error
    Matrix t = a.subtractMatrix(b);
    t.multiplyMatrixLocal(t);
    Matrix J = t.multiplyScalar(0.5);
    float [][] sumMatrix = new float[1][ numExamples];
    for (int j = 0; j < sumMatrix[0].length; j++) {
      sumMatrix[0][j] = 1;
    }
    J.transposeLocal();
    float result = J.dotProduct(new Matrix(sumMatrix)).matrix[0][0];
    return result;
  }

  void train(Matrix X, Matrix y) {
    /*
      void traing() - trains the Neural Network using feedForward and backProp
     Matrix X - inputs for feed forward
     Matrix y - correct answers
     */
    ArrayList<Matrix> dJdW;
    ArrayList<Matrix> dJdWb;
    for (int t = 0; t < 60000; t++) {
      ArrayList<ArrayList<Matrix>> result = backProp(X, y);
      dJdW = result.get(0);
      dJdWb = result.get(1);
      print("dJdW: ");
      dJdW.get(0).showMatrix();
      print("dJdWb: ");
      dJdWb.get(0).showMatrix();
      for (int i = 0; i < dJdW.size(); i++) {
        weights[i].subtractMatrixLocal(dJdW.get(i).multiplyScalar(learningRate));
        biases[i].subtractMatrixLocal(dJdWb.get(i).multiplyScalar(learningRate));
      }
    }
  }

  void initNN() {
    /*
      void initNN() -  Initialize values of weights and activities (nodes)
     */

    float x_offset, y_offset, x_curr, y_curr;

    x_offset = displaySize[0]/(numHiddenLayers + 3);
    y_offset = displaySize[1]/(inputLayerSize + 2);
    x_curr = 20;
    y_curr = 0;

    // Initializing input layer
    for (int i = 0; i < inputLayerSize + 1; i++) { // +1 fot bias
      y_curr += y_offset;
      nodePos[0][i][0] = x_curr;
      nodePos[0][i][1] = y_curr;
    }

    // Initializing hidden layers
    y_offset = displaySize[1]/(hiddenLayerSize + 2);
    for (int i = 0; i < numHiddenLayers; i++) {
      x_curr += x_offset;
      y_curr = 0;
      for (int j = 0; j < hiddenLayerSize + 1; j++) {
        y_curr += y_offset;
        nodePos[i+1][j][0] = x_curr;
        nodePos[i+1][j][1] = y_curr;
      }
    }

    // Initializing output layer
    x_curr += x_offset;
    y_curr = 0;
    y_offset = displaySize[1]/(outputLayerSize + 1);
    for (int i = 0; i < outputLayerSize; i++) {
      y_curr += y_offset;
      nodePos[numHiddenLayers+1][i][0] = x_curr;
      nodePos[numHiddenLayers+1][i][1] = y_curr;
    }
    /*
    print("Node Pos: \n");
     for (int i = 0; i < numHiddenLayers + 2; i++) {
     for (int j = 0; j < MAX; j++) {
     print("(" + str(nodePos[i][j][0]) + "," + str(nodePos[i][j][1]) + ") ");
     }
     print("\n");
     }
     */
  }

  void render() {
    /*
      void render() - Visualizes the Neural Network in the top corner of the screen
     */

    int vis_iter = 0;
    float thickness = 0; // Visualizes the magnitude of the weight
    float translucence = 0; // Visualizes the magnitude of node activity

    if (numHiddenLayers == 0) {
      // Draw Synapses between input and output layer
      for (int p1 = 0; p1 < inputLayerSize + 1; p1++) { // +1 for bias
        for (int p2 = 0; p2 < outputLayerSize; p2++) { // no bias in output layer
          thickness = map(abs(visWeights[vis_iter]), 0, 1, 0, 2);
          if (visWeights[vis_iter] < 0) {
            stroke(255, 0, 0);
          } else {
            stroke(0, 255, 0);
          }
          strokeWeight(thickness);
          line(nodePos[0][p1][0], nodePos[0][p1][1], nodePos[1][p2][0], nodePos[1][p2][1]);
          vis_iter++;
        }
      }
    } else {
      //Draw Synapses between input and hidden layer
      for (int p1 = 0; p1 < inputLayerSize + 1; p1++) { // +1 for bias
        for (int p2 = 0; p2 < hiddenLayerSize; p2++) { // exclude bias
          thickness = map(abs(visWeights[vis_iter]), 0, 1, 0, 2);
          if (visWeights[vis_iter] < 0) {
            stroke(255, 0, 0);
          } else {
            stroke(0, 255, 0);
          }
          strokeWeight(thickness);
          line(nodePos[0][p1][0], nodePos[0][p1][1], nodePos[1][p2][0], nodePos[1][p2][1]);
          vis_iter++;
        }
      }

      // Draw Synapses between hidden layers
      for (int i = 1; i < numHiddenLayers; i++) { // loop up until 2nd last layer
        for (int p1 = 0; p1 < hiddenLayerSize+1; p1++) {  // +1 for bias
          for (int p2 = 0; p2 < hiddenLayerSize; p2++) { // exclude bias
            thickness = map(abs(visWeights[vis_iter]), 0, 1, 0, 2);
            if (visWeights[vis_iter] < 0) {
              stroke(255, 0, 0);
            } else {
              stroke(0, 255, 0);
            }
            strokeWeight(thickness);
            line(nodePos[i][p1][0], nodePos[i][p1][1], nodePos[i+1][p2][0], nodePos[i+1][p2][1]);
            vis_iter++;
          }
        }
      }

      // Draw Synapses between hidden and output layer
      for (int p1 = 0; p1 < hiddenLayerSize + 1; p1++) { // +1 for bias
        for (int p2 = 0; p2 < outputLayerSize; p2++) { // no bias in output layer
          thickness = map(abs(visWeights[vis_iter]), 0, 1, 0, 2);
          if (visWeights[vis_iter] < 0) {
            stroke(255, 0, 0);
          } else {
            stroke(0, 255, 0);
          }
          strokeWeight(thickness);
          line(nodePos[numHiddenLayers][p1][0], nodePos[numHiddenLayers][p1][1], nodePos[numHiddenLayers+1][p2][0], nodePos[numHiddenLayers+1][p2][1]);
          vis_iter++;
        }
      }
    }

    strokeWeight(1);
    ellipseMode(CENTER);

    // Draw input layer nodes
    for (int p = 0; p < inputLayerSize; p++) {
      translucence = map(abs(x.matrix[0][p]), 0, 1, 0, 255);
      stroke(0, 0, 255);
      fill(0, 0, 255, translucence);
      ellipse(nodePos[0][p][0], nodePos[0][p][1], nodeSize, nodeSize);
    }
    translucence = 255; // bias nodes alwasy output 1
    stroke(0, 255, 255);
    fill(0, 255, 255, translucence);
    ellipse(nodePos[0][inputLayerSize][0], nodePos[0][inputLayerSize][1], nodeSize, nodeSize);

    if (numHiddenLayers != 0) {
      // Draw hidden layer nodes
      for (int i = 1; i < numHiddenLayers+1; i++) {
        for (int p = 0; p < hiddenLayerSize; p++) {
          translucence = map(abs(a[i-1].matrix[0][p]), 0, 1, 0, 255);
          stroke(0, 0, 255);
          fill(0, 0, 255, translucence);
          ellipse(nodePos[i][p][0], nodePos[i][p][1], nodeSize, nodeSize);
        }
        translucence = 255;
        stroke(0, 255, 255);
        fill(0, 255, 255, translucence);
        ellipse(nodePos[i][hiddenLayerSize][0], nodePos[i][hiddenLayerSize][1], nodeSize, nodeSize);
      }
    }

    // Draw output layer nodes
    for (int p = 0; p < outputLayerSize; p++) {
      translucence = map(abs(a[a.length-1].matrix[0][p]), 0, 1, 0, 255);
      stroke(0, 0, 255);
      fill(0, 0, 255, translucence);
      ellipse(nodePos[numHiddenLayers+1][p][0], nodePos[numHiddenLayers+1][p][1], nodeSize, nodeSize);
    }
  }
}
