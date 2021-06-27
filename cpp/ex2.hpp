#ifndef _EX2
#define _EX2

constexpr int imax=3;
constexpr int jmax=2;

namespace variables{
  extern double A[jmax][imax];
};

void setA();

template <size_t imax, size_t jmax>
void changeB(double (&B)[jmax][imax]);

#endif
