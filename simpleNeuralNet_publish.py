import numpy as np
from random import random

class Neural_Network(object):
    def __init__(self, input_, hidden_, output_, numHiddenLayer_, numExamples_):
        # Define Hyperparameters
        self.inputLayerSize = input_
        self.outputLayerSize = output_
        self.hiddenLayerSize = hidden_
        self.numHiddenLayer = numHiddenLayer_
        self.numExamples = numExamples_
        self.learningRate = 0.07 # LEARNING RATE: Why does ReLU produce such large dJdW values?
        self.weightDecay = 0
        # in -> out
        self.weights = [] # stores matrices of each layer of weights
        self.z = [] # stores matrices of each layer of weighted sums
        self.a = [] # stores matrices of each layer of activity 
        self.biases = [] # stores all biases
        self.biasNodes = []
        
        # Biases are matrices that are added to activity matrix
        # Dimensions -> numExamples_*hiddenLayerSize or numExamples_*outputLayerSize
        if (self.numHiddenLayer == 0 ):
            # Biases for output layer
            b = [np.random.random() for x in range(self.outputLayerSize)]
            B = [b for x in range(1)];
            self.biases.append(np.mat(B))
        else:
            for i in range(self.numHiddenLayer):
                # Biases for hidden layer
                b = [np.random.random() for x in range(self.hiddenLayerSize)];
                B = [b for x in range(1)];
                self.biases.append(np.mat(B))
            # Biases for output layer
            b = [np.random.random() for x in range(self.outputLayerSize)]
            B = [b for x in range(1)];
            self.biases.append(np.mat(B))
    
            
        # Initilaize bias nodes
        b= [1 for x in range(self.numExamples)]
        for i in range(self.numHiddenLayer):
            self.biasNodes.append(np.mat(b).reshape([self.numExamples,1]))
        self.biasNodes.append(np.mat(b).reshape([self.numExamples,1]))
        
        # Weights (Parameters)
        # Weight matrix between input and first layer
        if (self.numHiddenLayer == 0):
            W = np.matrix(np.random.random());
            self.weights.append(W)
        else:
            W = np.random.rand(self.inputLayerSize, self.hiddenLayerSize)
            self.weights.append(W)
    
            for i in range(self.numHiddenLayer-1):
                # Weight matrices between hidden layers
                W = np.random.rand(self.hiddenLayerSize, self.hiddenLayerSize)
                self.weights.append(W)
            # Weight matric between hiddenlayer and outputlayer
            self.weights.append(np.random.rand(self.hiddenLayerSize, self.outputLayerSize))
    
    def testNetwork(self):
        # Create a simple deterministic network for testing
        
        # Define Hyperparameters
        self.inputLayerSize = 1
        self.outputLayerSize = 1
        self.hiddenLayerSize = 0
        self.numHiddenLayer = 0
        self.numExamples = 9
        self.learningRate = 0.7 # LEARNING RATE
        self.weightDecay = 0
        # in -> out
        self.weights = [] # stores matrices of each layer of weights
        self.z = [] # stores matrices of each layer of weighted sums
        self.a = [] # stores matrices of each layer of activity 
        self.biases = [] # stores all biases
        self.biasNodes = []

        # Biases are matrices that are added to activity matrix
        # Dimensions -> numExamples_*hiddenLayerSize or numExamples_*outputLayerSize

        # Biases for output layer
        b = [0.5 for x in range(self.outputLayerSize)]
        B = [b for x in range(1)];
        self.biases.append(np.mat(B))
        
        # Bias nodes
        b= [1 for x in range(self.numExamples)]
        for i in range(self.numHiddenLayer):
            self.biasNodes.append(np.mat(b).reshape([self.numExamples,1]))
        self.biasNodes.append(np.mat(b).reshape([self.numExamples,1]))

        # Weights (Parameters)
        # Weight matrix between input and output layer
        W = np.matrix("0.5");
        self.weights.append(W)


   
    def regularize(self, x):
        # regularizes the data
        pass
        
    def setBatchSize(self, numExamples):
        # Changes the number of rows (examples) for biases
        if (self.numExamples > numExamples):
            self.biases = [b[:numExamples] for b in self.biases]
            
    def hypTan(self, z):
        # Apply hyperbolic tangent function
        return (np.exp(z) - np.exp(-z)) / (np.exp(z) + np.exp(-z))
    
    def hypTanPrime(self, z):
        # Apply derivative hyperbolic tangent function
        return 4/np.multiply((np.exp(z) + np.exp(-z)), (np.exp(z) + np.exp(-z)))
    
    def sigmoid(self, z):
        # Apply sigmoid activation function
        return 1/(1+np.exp(-z))

    def sigmoidPrime(self, z):
        # Derivative of sigmoid function
        return self.sigmoid(x)*(1-self.sigmoid(z))

    def ReLU(self, z):
        # Apply activation function
        '''
        for (i, j), item in np.ndenumerate(z):
            if (item < 0):
                item *= 0.01
            else:
                item = item
        return z'''
        return np.multiply((z < 0), z * 0.01)  + np.multiply((z >= 0), z)


    def ReLUPrime(self, z):
        # Derivative of ReLU activation function\
        '''
        for (i, j), item in np.ndenumerate(z):
            if (item < 0):
                item = 0.01
            else:
                item = 1
        return z'''
        return (z < 0) * 0.01 + (z >= 0) * 1

    def forward(self, X):
        # Propagate outputs through network
        self.z = []
        self.a = []
        
        self.z.append(np.dot(X, self.weights[0]) + self.biases[0])
        self.a.append(self.ReLU(self.z[0]))
            
        if (self.numHiddenLayer != 0):
            for i in range(1, self.numHiddenLayer):
                self.z.append(np.dot(self.a[-1], self.weights[i]) + self.biases[i])
                self.a.append(self.ReLU(self.z[i]))
    
            self.z.append(np.dot(self.z[-1], self.weights[-1]) + self.biases[-1])
            self.a.append(self.ReLU(self.z[-1]))
        yHat = self.a[-1]
        return yHat

    def backProp(self, X, y):
        # Compute derivative wrt W
        # out -> in
        dJdWb = [] # stores matrices of each dJdWb value 
        dJdW = [] # stores matrices of each dJdW (equal in size to self.weights[])
        delta = [] # stores matrices of each backpropagating error
        result = () # stores dJdW and dJdWb
        self.yHat = self.forward(X)
        
        # Quantifying Error
        print(np.linalg.norm(y-self.yHat)/np.linalg.norm(y+self.yHat))
        
        if (self.numHiddenLayer == 0):
            delta.insert(0,np.multiply(-(y-self.yHat), self.ReLUPrime(self.z[-1]))) # delta = (y-yHat)(sigmoidPrime(final layer unactivated))
            dJdW.insert(0, np.dot(X.T, delta[0]) + (self.weightDecay*self.weights[-1]))
            dJdWb.insert(0, np.dot(self.biasNodes[-1].T, delta[0]) + (self.weightDecay*self.biases[-1])) # you need to backpropagate to bias nodes
        else :  
            delta.insert(0,np.multiply(-(y-self.yHat), self.ReLUPrime(self.z[-1]))) # delta = (y-yHat)(sigmoidPrime(final layer unactivated))
            dJdW.insert(0, np.dot(self.a[-2].T, delta[0]) + (self.weightDecay*self.weights[-1])) # dJdW
            dJdWb.insert(0, np.dot(self.biasNodes[-1].T, delta[0]) + (self.weightDecay*self.biases[-1]))
            for i in range(len(self.weights)-1, 1, -1): # loop through weights from prev layer to compute delta and dJdW for curr layer
                # Iterate from self.weights[-1] -> self.weights[1]
                delta.insert(0, np.multiply(np.dot(delta[0], self.weights[i].T), self.ReLUPrime(self.z[i-1])))
                dJdW.insert(0, np.dot(self.a[i-2].T, delta[0]) + (self.weightDecay*self.weights[i-1]))
                dJdWb.insert(0, np.dot(self.biasNodes[i-1].T, delta[0]) + (self.weightDecay*self.biases[i-1]))
    
            delta.insert(0, np.multiply(np.dot(delta[0], self.weights[1].T), self.ReLUPrime(self.z[0])))
            dJdW.insert(0, np.dot(X.T, delta[0]) + (self.weightDecay*self.weights[0]))
            dJdWb.insert(0, np.dot(self.biasNodes[0].T, delta[0]) + (self.weightDecay*self.biases[0]))

        result = (dJdW, dJdWb)
        return result

    def train(self, X, y):
        for t in range(6000):
            dJ = self.backProp(X, y)
            dJdW = dJ[0]
            dJdWb = dJ[1]
            for i in range(len(dJdW)):
                print("dJdW:", dJdW[i], sep = " ", end = "\n")
                print("dJdWb:", dJdWb[i], sep = " ", end = "\n\n")
                print("Weights:", self.weights[i]);
                self.weights[i] -= self.learningRate*dJdW[i]
                self.biases[i] -= self.learningRate*dJdWb[i]




# Instantiating Neural Network

NN = Neural_Network(1,3,1,1,9)
#NN.testNetwork() # create a deterministic NN for testing
x = np.matrix("0.1; 0.15; 0.2; 0.25; 0.3; 0.35; 0.4; 0.45; 0.5")
y = np.matrix("0.2; 0.3; 0.4; 0.5; 0.6; 0.7; 0.8; 0.9; 1.0")

# Training
print("INPUT: ", end = '\n')
print(x, end = '\n\n')

print("BEFORE TRAINING", NN.forward(x), sep = '\n', end = '\n\n')
print("ERROR: ")
NN.train(x,y)
print("\nAFTER TRAINING", NN.forward(x), sep = '\n', end = '\n\n')

NN.setBatchSize(1) # changing settings to receive one input at a time

while True:
    inputs = input()
    x = np.mat([float(i) for i in inputs.split(" ")])
    print(NN.forward(x))

