#ifndef _EX3
#define _EX3

#include <vector>

template <typename T>
class matrix{
private:
  std::vector <T> data_;
  int row_ = 0;
  int col_ = 0;

public:
  matrix () = default;
  matrix (int col, int row) : data_(row*col), row_{row}, col_{col} {}
  T&  operator()(int j, int i) {
    return this-> data_[j*row_ + i];
  }

  int row() {
    return row_;
  }
  int col() {
    return col_;
  }
  void allocate(int newcol, int newrow){
    data_.resize(newrow*newcol);
    data_=&data_.at(0)
    row_= newrow;
    col_= newcol;
  }
};


namespace variables{
  extern matrix<double> A;
};

void setA();

void changeB(matrix<double> (&B));


#endif
