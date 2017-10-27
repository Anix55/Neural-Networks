
class Neuro_Evolution {
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
  float [] chromosome; // used to initialize weights
  float [] displaySize; // controls display size of the NN
  float [][][] nodePos; // stores positions of nodes on screen
  float nodeSize;
  int inputLayerSize, hiddenLayerSize, outputLayerSize, numHiddenLayers, numExamples, MAX;

  Neuro_Evolution(float [] chrm, boolean mutate) {

    //Define HyperParameters
    inputLayerSize = 5;
    hiddenLayerSize = 3;
    outputLayerSize= 2;
    numHiddenLayers = 1;
    numExamples = 1;

    if (chrm.length != 0) {
      if (mutate) {
        chromosome = mutate(chrm); // Inheriting chromsomes from parents
      } else {
        chromosome = chrm;
      }
    } else {
      createChromosome(); // Use for spawning first generation
    }

    /*print("Chromosome: \n");
     for (float i : chromosome) {
     print(str(i) + " ");
     }
     print("\n\n");
     */

    // Set lenghts of array matrix containers
    weights = new Matrix[numHiddenLayers+1];
    biases = new Matrix[numHiddenLayers+1];
    a = new Matrix[numHiddenLayers+1]; // a[1] (last elem) is yHat
    z = new Matrix[numHiddenLayers+1]; // z[1] (last elem) is yHat w/o sigmoid

    /*
      INTIALIZE WEIGHTS OF NEURAL NETWORK USING CHROMOSOME
     Weights are matrix that are multiplied by activity of prev layer to get activity of next layer
     Dimension of Weights -> inputLayerSize * hiddenLayerSize or hiddenLayerSize^2 or hiddenLayerSize * outputLayerSize
     Biases are matrices that are added to activity
     Dimensions of Biases -> numExamples * hiddenLayerSize or numExamples * outputLayerSize
     */

    int chrm_iter = 0;
    int weight_iter = 0;
    int bias_iter = 0;
    float [][] B;
    float [] b;


    if (numHiddenLayers == 0) {
      // Weight and Bias Matrix between input and output layer
      float [][] W = new float [inputLayerSize][outputLayerSize];
      for (int i = 0; i < inputLayerSize; i++) {
        for (int j = 0; j < outputLayerSize; j++) {
          W[i][j] = chromosome[chrm_iter];
          chrm_iter++;
        }
      }
      weights[weight_iter] = new Matrix(W);
      weight_iter++;

      B = new float [numExamples][outputLayerSize];
      b = new float[outputLayerSize];
      for (int i = 0; i < outputLayerSize; i++) {
        b[i] = chromosome[chrm_iter];
        chrm_iter++;
      }
      for (int i = 0; i < numExamples; i++) {
        B[i] = b;
      }
      biases[bias_iter] = new Matrix(B);
      bias_iter++;
    } else {
      // Weight and Bias matrix between input and first hidden layer
      float [][] W = new float [inputLayerSize][hiddenLayerSize];
      for (int i = 0; i < inputLayerSize; i++) {
        for (int j = 0; j < hiddenLayerSize; j++) {
          W[i][j] = chromosome[chrm_iter];
          chrm_iter++;
        }
      }
      weights[weight_iter] = new Matrix(W);
      weight_iter++;

      B = new float [numExamples][hiddenLayerSize];
      b = new float[hiddenLayerSize];
      for (int i = 0; i < hiddenLayerSize; i++) {
        b[i] = chromosome[chrm_iter];
        chrm_iter++;
      }
      for (int i = 0; i < numExamples; i++) {
        B[i] = b;
      }
      biases[bias_iter] = new Matrix(B);
      bias_iter++;


      // Weight and Bias matrix between hidden layers
      for (int h = 0; h < numHiddenLayers-1; h++) {
        W = new float [hiddenLayerSize][hiddenLayerSize];
        for (int i = 0; i < hiddenLayerSize; i++) {
          for (int j = 0; j < hiddenLayerSize; j++) {
            W[i][j] = chromosome[chrm_iter];
            chrm_iter++;
          }
        }
        weights[weight_iter] = new Matrix(W);
        weight_iter++;
        B = new float [numExamples][hiddenLayerSize];
        b = new float [hiddenLayerSize];
        for (int i = 0; i < hiddenLayerSize; i++) {
          b[i] = chromosome[chrm_iter];
          chrm_iter++;
        }
        for (int i = 0; i < numExamples; i++) {
          B[i] = b;
        }
        biases[bias_iter] = new Matrix(B);
        bias_iter++;
      }


      // Weight and Bias matrix between hidden and output layer
      W = new float [hiddenLayerSize][outputLayerSize];
      for (int i = 0; i < hiddenLayerSize; i++) {
        for (int j = 0; j < outputLayerSize; j++) {
          W[i][j] = chromosome[chrm_iter];
          chrm_iter++;
        }
      }
      weights[weight_iter] = new Matrix(W);
      weight_iter++;
      B = new float[numExamples][outputLayerSize];
      b = new float [outputLayerSize];
      for (int i = 0; i < outputLayerSize; i++) {
        b[i] = chromosome[chrm_iter];
        chrm_iter++;
      }
      for (int i = 0; i < numExamples; i++) {
        B[i] = b;
      }
      biases[bias_iter] = new Matrix(B);
      bias_iter++;
    }



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

    /*
    print("Biases: \n");
     for (Matrix m : biases) {
     m. showMatrix();
     }
     print("Weights: \n");
     for (Matrix m : weights) {
     m.showMatrix();
     }
     */

    forward(init_x); // initialize activation matrix
    initNN();
  }

  float[][] logistic(float[][] z) {
    /*
      float [][] logistic(float[][] z) - Applies logistic sigmoid function
     float [][] z - matrix values
     */
    for (int i = 0; i < z.length; i++) {
      for (int j = 0; j < z[0].length; j++) {
        z[i][j] = 1/(1+exp(-1*z[i][j]));
      }
    }
    return z;
  }

  float[][] hyp_tan(float[][] z) {
    /*
      float [][] hyp_tan(float[][] z) - Applies hyperbolic tangent sigmoid activation funtion
     float [][] z - matrix values
     */
    for (int i = 0; i < z.length; i++) {
      for (int j = 0; j < z[0].length; j++) {
        z[i][j] = ( exp(z[i][i]) - exp(-1*z[i][j]) )/( exp(z[i][j]) + exp(-1*z[i][j]) );
      }
    }
    return z;
  }

  void forward(float [][]x_) {
    /*
      void forward(float [][]x_) - Propagate inputs and activites through the network
     float [][] x_ - input values
     */

    x = new Matrix(x_); // stores values in Matrix object to get functionality
    Matrix t_dot;

    if (numHiddenLayers == 0) { 
      // Propagate inputs to output layer

      t_dot = new Matrix(x.dotProduct(weights[0]));
      z[0] = new Matrix(t_dot.addMatrix(biases[0]));
      a[0] = new Matrix(hyp_tan(z[0].matrix));
    } else {
      // Propagate inputs to first hidden layer

      t_dot = new Matrix(x.dotProduct(weights[0]));
      z[0] = new Matrix(t_dot.addMatrix(biases[0]));
      a[0] = new Matrix(hyp_tan(z[0].matrix));

      // Propagate inputs through hidden layers

      for (int i = 1; i < numHiddenLayers; i++) {
        t_dot = new Matrix(a[i-1].dotProduct(weights[i]));
        z[i] = new Matrix(t_dot.addMatrix(biases[i]));
        a[i] = new Matrix(hyp_tan(z[i].matrix));
      }
      // Propagate inputs from last hidden layer to output layer

      t_dot = new Matrix(a[a.length-2].dotProduct(weights[weights.length - 1]));
      z[z.length - 1] = new Matrix(t_dot.addMatrix(biases[biases.length - 1]));
      a[a.length - 1] = new Matrix(hyp_tan(z[z.length - 1].matrix));
    } 
    yHat = new Matrix( a[a.length - 1].matrix );
  }

  void createChromosome() {
    /*
      void createChromosome() - encode weights into linear gene for first generation of cars
     */
    int numGenes;
    if (hiddenLayerSize == 0) {
      numGenes = (inputLayerSize + 1)*outputLayerSize;
    } else {
      numGenes = (inputLayerSize + 1)*hiddenLayerSize + (numHiddenLayers - 1)*(hiddenLayerSize + 1)*(hiddenLayerSize) + (hiddenLayerSize + 1)*outputLayerSize;
    }
    chromosome = new float [numGenes];
    for (int i = 0; i< numGenes; i++) {
      chromosome[i] = random(-1, 1);
    }
  }

  float [] mutate(float[] chrm) {
    float mutationProb = 0.1;
    for (int i = 0; i < chrm.length; i++) {
      float chance = random(0, 1);
      if (chance < mutationProb) {
        chrm[i] = random(-1, 1);
      }
    }
    return chrm;
  }

  float [] crossOver(float[] chrm2) {
    int numGenes;
    if (hiddenLayerSize == 0) {
      numGenes = (inputLayerSize + 1)*outputLayerSize;
    } else {
      numGenes = (inputLayerSize + 1)*hiddenLayerSize + (numHiddenLayers - 1)*(hiddenLayerSize + 1)*(hiddenLayerSize) + (hiddenLayerSize + 1)*outputLayerSize;
    }
    float [] newChrm = new float[numGenes];
    for (int i = 0; i < numGenes; i++) {
      if (i % 2 == 0) {
        newChrm[i] = chromosome[i];
      } else {
        newChrm[i] = chrm2[i];
      }
    }
    return newChrm;
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

    int chrm_iter = 0;
    float thickness = 0; // Visualizes the magnitude of the weight
    float translucence = 0; // Visualizes the magnitude of node activity

    if (numHiddenLayers == 0) {
      // Draw Synapses between input and output layer
      for (int p1 = 0; p1 < inputLayerSize + 1; p1++) { // +1 for bias
        for (int p2 = 0; p2 < outputLayerSize; p2++) { // no bias in output layer
          thickness = map(abs(chromosome[chrm_iter]), 0, 1, 0, 2);
          if (chromosome[chrm_iter] < 0) {
            stroke(255, 0, 0);
          } else {
            stroke(0, 255, 0);
          }
          strokeWeight(thickness);
          line(nodePos[0][p1][0], nodePos[0][p1][1], nodePos[1][p2][0], nodePos[1][p2][1]);
          chrm_iter++;
        }
      }
    } else {
      //Draw Synapses between input and hidden layer
      for (int p1 = 0; p1 < inputLayerSize + 1; p1++) { // +1 for bias
        for (int p2 = 0; p2 < hiddenLayerSize; p2++) { // exclude bias
          thickness = map(abs(chromosome[chrm_iter]), 0, 1, 0, 2);
          if (chromosome[chrm_iter] < 0) {
            stroke(255, 0, 0);
          } else {
            stroke(0, 255, 0);
          }
          strokeWeight(thickness);
          line(nodePos[0][p1][0], nodePos[0][p1][1], nodePos[1][p2][0], nodePos[1][p2][1]);
          chrm_iter++;
        }
      }

      // Draw Synapses between hidden layers
      for (int i = 1; i < numHiddenLayers; i++) { // loop up until 2nd last layer
        for (int p1 = 0; p1 < hiddenLayerSize+1; p1++) {  // +1 for bias
          for (int p2 = 0; p2 < hiddenLayerSize; p2++) { // exclude bias
            thickness = map(abs(chromosome[chrm_iter]), 0, 1, 0, 2);
            if (chromosome[chrm_iter] < 0) {
              stroke(255, 0, 0);
            } else {
              stroke(0, 255, 0);
            }
            strokeWeight(thickness);
            line(nodePos[i][p1][0], nodePos[i][p1][1], nodePos[i+1][p2][0], nodePos[i+1][p2][1]);
            chrm_iter++;
          }
        }
      }

      // Draw Synapses between hidden and output layer
      for (int p1 = 0; p1 < hiddenLayerSize + 1; p1++) { // +1 for bias
        for (int p2 = 0; p2 < outputLayerSize; p2++) { // no bias in output layer
          thickness = map(abs(chromosome[chrm_iter]), 0, 1, 0, 2);
          if (chromosome[chrm_iter] < 0) {
            stroke(255, 0, 0);
          } else {
            stroke(0, 255, 0);
          }
          strokeWeight(thickness);
          line(nodePos[numHiddenLayers][p1][0], nodePos[numHiddenLayers][p1][1], nodePos[numHiddenLayers+1][p2][0], nodePos[numHiddenLayers+1][p2][1]);
          chrm_iter++;
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