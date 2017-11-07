/* Matrix Module
 Methods: setElem(), getElem(), showMatrix(), copyMatrix(), addMatrix(), subtractMatrix(), transpose()
 
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

  void copyMatrix(Matrix m) {
    /*
      void copyMatrix(matrix m) - copy the values from m into this matrix
     Matrix m - matrix object
     */
    row = m.row;
    col = m.col;
    matrix = m.matrix;
  }

  float[][] addMatrix(Matrix m) {
    /*
      float[][] addMatrix(Matrix m) - return the sum of the values of m and this matrix
     Matrix m - matrix object
     */
    float [][] result = new float[row][col];
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < col; c++) {
        result[r][c] = matrix[r][c] + m.matrix[r][c];
      }
    }
    return result;
  }

  float[][] subtractMatrix(Matrix m) {
    /*
      float[][] subtractMatrix(Matrix m) - return the difference b/w the values of m and this matrix
     Matrix m - matrix object
     */
    float [][] result = new float[row][col];
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < col; c++) {
        result[r][c] = matrix[r][c] - m.matrix[r][c];
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
  
  float[][]  transpose() {
    /*
      float[][] transpose - "rotate" the matrix and return the new value
     */
    float [][] result = new float[col][row];

    for (int c = 0; c < col; c++) {
      for (int r = 0; r < row; r++) {
        result[c][r] = matrix[r][c];
      }
    }
    /*
     matrix = result;
     row = matrix.length;
     col = matrix[0].length;
     */
    return result;
  }

  void  transposeLocal() {
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

  float[][] dotProduct(Matrix m) {
    /*
      float[][] dotProduct(Matrix m) - return the dot product of m and this
     Matrix m - matrix object
     */
    float [][] result = new float[row][m.col];
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
        result[r][c] = data;
      }
    }
    return result;
  }
}
