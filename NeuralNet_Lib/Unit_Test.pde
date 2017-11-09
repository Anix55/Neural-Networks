//<>// //<>// //<>//
class UnitTest {
  boolean errorFlag;
  Matrix m;
  Matrix n;
  Matrix r;
  Matrix s;
  UnitTest() {
  }

  // MATRIX TESTING

  void instantiateMatrix() {
    println("TESTING CONSTRUCTOR");
    errorFlag = false;

    try {
      m = new Matrix(new String("4;4;2;5"), 2, 2);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag) {
        println("Test 1: Success");
        m.showMatrix();
      } else {
        println("Test 1: Failure");
      }
    }

    errorFlag = false;

    try {
      m = new Matrix(new String("4;4;2;5;4;5;6;2;7;3"), 5, 2);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag) {
        println("Test 2: Success");
        m.showMatrix();
      } else {
        println("Test 2: Failure");
      }
    }

    boolean errorFlag = false;

    try {
      m = new Matrix(new String("4;4;2;5;5"), 1, 5);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag) {
        println("Test 3: Success");
        m.showMatrix();
      } else {
        println("Test 3: Failure");
      }
    }


    errorFlag = false;

    try {
      m = new Matrix(new String("4;4;2;5;5;3;26;4;5;2;6;3;6;2;6;5;42;4;23;4"), 4, 5);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag) {
        println("Test 4: Success");
        m.showMatrix();
      } else {
        println("Test 4: Failure");
      }
    }
  }
  void multiplyScalarTest() {
    println("\nTESTING SCALAR MULTIPLICATION");
    errorFlag = false;

    try {
      m = new Matrix(new String("4;4;2;5"), 2, 2);
      m.multiplyScalarLocal(0.01);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag) {
        println("Test 1: Success");
        //m.showMatrix();
      } else {
        println("Test 1: Failure");
      }
    }


    errorFlag = false;

    try {
      m = new Matrix(new String("4;4;2;5;43;5;3;53;3"), 3, 3);
      n = m.multiplyScalar(10);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag) {
        println("Test 2: Success");
        //n.showMatrix();
      } else {
        println("Test 2: Failure");
      }
    }
  }

  void equalsToTest() {
    println("TESTING EQUALS TO FUNCTION");
    errorFlag = false;

    try {
      m = new Matrix(new String("4;4;2;5"), 2, 2);
      n = new Matrix(new String("4;4;2;5"), 2, 2);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && m.equalsTo(n)) {
        println("Test 1: Success");
      } else {
        println("Test 1: Failure");
      }
    }

    try {
      m = new Matrix(new String("4;4;2;5"), 2, 2);
      n = new Matrix(new String("4;4;2;5;5;2"), 2, 3);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && !m.equalsTo(n)) {
        println("Test 2: Success");
      } else {
        println("Test 2: Failure");
      }
    }

    try {
      m = new Matrix(new String("4;4;2;5"), 2, 2);
      n = new Matrix(new String("4;4;2;6"), 2, 2);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && !m.equalsTo(n)) {
        println("Test 3: Success");
      } else {
        println("Test 3: Failure");
      }
    }

    try {
      m = new Matrix(new String("4;4;2;5"), 2, 2);
      n = new Matrix(new String("5;2;4;4"), 2, 2);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && !m.equalsTo(n)) {
        println("Test 4: Success");
      } else {
        println("Test 4: Failure");
      }
    }
  }

  void multiplyMatrixTest() {
    println("\nTESTING MATRIX MULTIPLICATION");
    errorFlag = false;

    try {
      m = new Matrix(new String("4;4;2;5"), 2, 2);
      n = new Matrix(new String("12;4;6;2"), 2, 2);
      r = m.multiplyMatrix(n);
      s = new Matrix(new String("48;16;12;10"), 2, 2);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && r.equalsTo(s)) {
        println("Test 1: Success");
      } else {
        println("Test 1: Failure");
      }
    }

    errorFlag = false;

    try {
      m = new Matrix(new String("1;2;3;4;5;6"), 2, 3);
      n = new Matrix(new String("6;5;4;3;2;1"), 2, 3);
      r = m.multiplyMatrix(n);
      s = new Matrix(new String("6;10;12;12;10;6"), 2, 3);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && r.equalsTo(s)) {
        println("Test 2: Success");
      } else {
        println("Test 2: Failure");
      }
    }

    errorFlag = false;

    try {
      m = new Matrix(new String("4;4;2;5;4;2;5;2;4"), 1, 9);
      n = new Matrix(new String("1;1;1;1;1;1;1;1;1"), 1, 9);
      r = m.multiplyMatrix(n);
      s = new Matrix(new String("4;4;2;5;4;2;5;2;4"), 1, 9);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && r.equalsTo(s)) {
        println("Test 3: Success");
      } else {
        println("Test 3: Failure");
      }
    }
  }

  void dotProductTest() {
    println("\nTESTING DOT PRODUCT");
    errorFlag = false;

    try {
      m = new Matrix(new String("4;4;2;5"), 2, 2);
      n = new Matrix(new String("12;4;6;2"), 2, 2);
      r = m.dotProduct(n);
      s = new Matrix(new String("72;24;54;18"), 2, 2);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && r.equalsTo(s)) {
        println("Test 1: Success");
      } else {
        println("Test 1: Failure");
        r.showMatrix();
      }
    }

    errorFlag = false;

    try {
      m = new Matrix(new String("4;4;2;5;1;5;2;5;2;8;12;5;7;18;3"), 3, 5);
      n = new Matrix(new String("12;4;6;2;2;5;23;7;6;5;34;8;9;1;12"), 5, 3);
      r = m.dotProduct(n);
      s = new Matrix(new String("136;209;108;261;135;182;432;722;319"), 3, 3);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && r.equalsTo(s)) {
        println("Test 2: Success");
      } else {
        println("Test 2: Failure");
        r.showMatrix();
      }
    }

    errorFlag = false;

    try {
      m = new Matrix(new String("1;1;1;1;1;1;1;1;1;1"), 1, 10);
      n = new Matrix(new String("1;1;1;1;1;1;1;1;1;1"), 10, 1);
      r = m.dotProduct(n);
      s = new Matrix(new String("10"), 1, 1);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && r.equalsTo(s)) {
        println("Test 3: Success");
      } else {
        println("Test 3: Failure");
        r.showMatrix();
      }
    }
  }

  void transposeTest() {
    println("\nTRANSPOSE TEST");

    errorFlag = false;

    try {
      m = new Matrix(new String("4;4;2;5"), 2, 2);
      r = m.transpose();
      s = new Matrix("4;2;4;5", 2, 2);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && r.equalsTo(s)) {
        println("Test 1: Success");
      } else {
        println("Test 1: Failure");
        r.showMatrix();
      }
    }

    errorFlag = false;

    try {
      m = new Matrix(new String("1;1;1;1;1;1;1;1;1;1"), 1, 10);
      m.transposeLocal();
      s = new Matrix(new String("1;1;1;1;1;1;1;1;1;1"), 10, 1);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && m.equalsTo(s)) {
        println("Test 2: Success");
        //m.showMatrix();
      } else {
        println("Test 2: Failure");
      }
    }

    errorFlag = false;

    try {
      m = new Matrix(new String("1"), 1, 1);
      r = m.transpose();
      s = new Matrix("1", 1, 1);
    } 
    catch(java.lang.RuntimeException e) {
      e.printStackTrace();
      errorFlag = true;
    }
    finally {
      if (!errorFlag && r.equalsTo(s)) {
        println("Test 3: Success");
      } else {
        println("Test 3: Failure");
        r.showMatrix();
      }
    }
  }
  
  // NEURAL NETWORK TEST

  void test() {
    println("Beginning Unit Test: \n");
    instantiateMatrix();
    equalsToTest();
    multiplyScalarTest();
    multiplyMatrixTest();
    dotProductTest();
    transposeTest();
  }
}