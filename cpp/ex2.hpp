#ifndef _EX2
#define _EX2

#include <iostream>

constexpr int imax=3;
constexpr int jmax=2;

namespace variables{
  extern double A[jmax][imax];
};

void setA();

template <std::size_t imax, std::size_t jmax>
void changeB(double (&B)[jmax][imax]);

#endif
