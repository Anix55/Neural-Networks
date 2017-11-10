/* Matrix Module
 Methods: setElem(), getElem(), showMatrix(), copyMatrix(), addMatrix(), subtractMatrix(), transpose(), multiplyScalar(), dotProduct(), equalTo(), almostEqualTo, relativeError()
 
 */
class Matrix {
  // Variables to keep track of
  int row;
  int col;
  float [][] matrix;

  Matrix(float [][] m) {
    /*
      Matrix(float[][]m) - Matrix constructor
     float[][] m - values
     */
    matrix = m;
    row = m.length;
    col = m[0].length;
  }

  Matrix(String elemStr, int row_, int col_) {
    /*
      Matrix(String m, int row_, int col_) - Matrix constructor (Overloaded)
     String m - values
     int row_, col_: dimensionality of matrix
     */
    row = row_;
    col = col_;
    matrix = new float[row][col];
    String [] elems = split(elemStr, ';');
    int iter = 0;
    if (elems.length == row * col) {
      for (int i  = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
          matrix[i][j] = float(elems[iter]);
          iter++;
        }
      }
    } else {
      println("ERROR: dimensionality error");
    }
  }

  Matrix multiplyScalar(float scalar) {
    /*
      Matrix multiplyScalar(float scalar) - return scaled version of this matrix
     float scalar - scalar value
     */
    Matrix result = new Matrix(new float [row][col]);
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        result.matrix[i][j] = matrix[i][j] * scalar;
      }
    }
    return result;
  }

  void multiplyScalarLocal(float scalar) {
    /*
      Matrix multiplyScalar(float scalar) - multiply this matrix  by a scalar
     float scalar - scalar value
     */
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        matrix[i][j] = matrix[i][j] * scalar;
      }
    }
  }

  Matrix multiplyMatrix(Matrix m) {
    /*
      Matrix multiple(Matrix m) - return a matrix of the product of two matrix of same dim
     */
    Matrix result = new Matrix(new float[row][col]);
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        result.matrix[i][j] = matrix[i][j] * m.matrix[i][j];
      }
    }
    return result;
  }

  void multiplyMatrixLocal(Matrix m) {
    /*
      Matrix multiple(Matrix m) - compute the product of two matrix of same dim
     */
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < col; j++) {
        matrix[i][j] *= m.matrix[i][j];
      }
    }
  }

  void deleteLocal(int index, int axis) {
    /*
      void delete(int index, int axis) - deletes entire rows or columns
     int axis - 0: row, 1: column
     int index - index of row/column to delete
     */
    if (axis == 0) {
      // Delete specified row
      row -= 1;
      float[][] t = new float[row][col];
      for (int i = 0, i_ = 0; i < row+1; i++) {
        if (i != index) {
          t[i_] = matrix[i];
          i_++;
        }
      }
      matrix = t;
    } else {
      // Delete specified column
      col -= 1;
      float[][] t = new float[row][col];
      for (int i = 0; i < row; i++) {
        for (int j = 0, j_ = 0; j < col+1; j++) {
          if (j != index) {
            t[i][j_] = matrix[i][j];
            j_++;
          }
        }
      }
      matrix = t;
    }
  }

  void setElem(int r, int c, float x) {
    /*
      void setElem(int r, int c, float x) - change an element with the matric
     int r, c - position in the matrix
     flaot x - new value
     */

    matrix[r][c] = x;
  }

  float getElem(int r, int c) {
    /*
      float getElem(int r, int c) - return specific element
     int r, c- position in thematrix
     */
    return matrix[r][c];
  }

  void showMatrix() {
    /*
      void showMatrix() - prints the matrix to the console
     */
    String buff = new String();
    for (int r = 0; r < row; r++) {
      buff = "";
      for (int c = 0; c < col; c++) {
        buff = buff + str(matrix[r][c]) + " ";
      }
      println(buff);
    }
    println("\n");
  }
  
  float matrixNorm(){
    /*
      float matrixNorm() - returns norm of the matrix
    */
    float result = 0;
    for (int i  = 0; i < row; i++){
      for (int j = 0; j < col; j++){
        result += pow(matrix[i][j], 2);
      }
    }
    result = sqrt(result);
    return result;
  }
  float relativeError(Matrix m){
    /*
      float relativeError(Matrix m): quantifies error between a and b
    */

    float normDiff = subtractMatrix(m).matrixNorm();
    float normSum = addMatrix(m).matrixNorm();
    float result = normDiff / normSum;
    return result;
  }
  
  void copyMatrix(Matrix m) {
    /*
      void copyMatrix(matrix m) - copy the values from m into this matrix
     Matrix m - matrix object
     */
    row = m.row;
    col = m.col;
    matrix = m.matrix;
  }

  Matrix addMatrix(Matrix m) {
    /*
      Matrix addMatrix(Matrix m) - return the sum of the values of m and this matrix
     Matrix m - matrix object
     */
    Matrix result = new Matrix(new float[row][col]);
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < col; c++) {
        result.matrix[r][c] = matrix[r][c] + m.matrix[r][c];
      }
    }
    return result;
  }

  void addMatrixLocal(Matrix m) {
    /*
      Matrix addMatrix(Matrix m) - return the sum of the values of m and this matrix
     Matrix m - matrix object
     */
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < col; c++) {
        matrix[r][c] += m.matrix[r][c];
      }
    }
  }

  Matrix subtractMatrix(Matrix m) {
    /*
      Matrix subtractMatrix(Matrix m) - return the difference b/w the values of m and this matrix
     Matrix m - matrix object
     */
    Matrix result = new Matrix(new float[row][col]);
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < col; c++) {
        result.matrix[r][c] = matrix[r][c] - m.matrix[r][c];
      }
    }
    return result;
  }

  void subtractMatrixLocal(Matrix m) {
    /*
      void subtractMatrix(Matrix m) - subtract Matrix m from this matrix
     Matrix m - matrix object
     */
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < col; c++) {
        matrix[r][c] -= m.matrix[r][c];
      }
    }
  }

  Matrix transpose() {
    /*
      Matrix transpose - "rotate" the matrix and return the new value
     */
    Matrix result = new Matrix(new float[col][row]);

    for (int c = 0; c < col; c++) {
      for (int r = 0; r < row; r++) {
        result.matrix[c][r] = matrix[r][c];
      }
    }
    return result;
  }

  void transposeLocal() {
    /*
      void transpose - "rotate" this matrix
     */
    float [][] result = new float[col][row];

    for (int c = 0; c < col; c++) {
      for (int r = 0; r < row; r++) {
        result[c][r] = matrix[r][c];
      }
    }

    matrix = result;
    row = matrix.length;
    col = matrix[0].length;
  }

  Matrix dotProduct(Matrix m) {
    /*
      Matrix dotProduct(Matrix m) - return the dot product of m and this
     Matrix m - matrix object
     */
    Matrix result = new Matrix(new float[row][m.col]);
    for (int r = 0; r < row; r++) {

      // current row of first matrix
      float [] rowVec = new float[col];
      rowVec = matrix[r];
      for (int c = 0; c < m.col; c++) {

        // current col of second matrix
        float [] colVec = new float[m.row];
        for (int i = 0; i < m.row; i++) {
          colVec[i] = m.matrix[i][c];
        }

        // Column multiplication step
        float data = 0;
        for (int i = 0; i < colVec.length; i++) {
          data += rowVec[i] * colVec[i];
        }
        result.matrix[r][c] = data;
      }
    }
    return result;
  }

  boolean equalTo(Matrix m) {
    /*
      boolean equalsTo(Matrix m) - determines if matrices are equal
    */
    boolean result = true;
    if (row == m.row && col == m.col) {
      for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
          if (matrix[i][j] != m.matrix[i][j]) {
            result = false;
            break;
          }
        }
      }
    } else {
      result = false;
    }
    return result;
  }
  
  boolean almostEqualTo(Matrix m, float tolerance){
    /*
      boolean almostEqualTo(Matrix m, float tolerance) - determines if matrices are similar
    */
    boolean result= false;
    float rError = relativeError(m);
    if (rError < tolerance){
      result = true;
    }
    return result;
  }
}
