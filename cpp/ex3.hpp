#ifndef _EX3
#define _EX3

#include <iostream>
#include <vector>
#include <cassert>

template <typename T>
class matrix{

private:
  std::vector <T> data_;
  std::size_t rows_ = 0;
  std::size_t cols_ = 0;

public:
// constructor 
  matrix () = default;
  matrix (std::size_t cols, std::size_t rows) : data_(rows*cols), rows_{rows}, cols_{cols} {
    // if you need initialze. write someting here.
  }

  matrix(const matrix&) = default;
  matrix(matrix&&) = default;

// = 
  matrix& operator=(const matrix&) = default;
  matrix& operator=(matrix&&) = default;

// access
  T&  operator()(const std::size_t j,const std::size_t i) noexcept {
    assert(j < cols_ && i < rows_); // check whether the index is in the range or not
    return this-> data_[j*rows_ + i];
  }
  const T&  operator()(const std::size_t j,const std::size_t i)const  noexcept {
    assert(j < cols_ && i < rows_); // check whether the index is in the range or not
    return data_[j*rows_ + i];
  }

// size
  std::size_t size() const noexcept { return data_.size(); }
  std::size_t rows() const noexcept { return rows_; }
  std::size_t cols() const noexcept { return cols_; }


// resize, allocate
  void allocate(const std::size_t newcols, const std::size_t newrows){
    data_.resize(newrows*newcols);
    rows_= newrows;
    cols_= newcols;
  }
};

namespace variables{
  extern matrix<double> A;
};

void setA();

void changeB(matrix<double> (&B));

void showB(const matrix<double> (&B));

#endif
