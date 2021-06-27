#ifndef _EX2
#define _EX2

#define IMAX 2
#define JMAX 3

namespace variables{
  extern double A[JMAX][IMAX];
};

void setA();

template <size_t imax, size_t jmax>
void changeB(double (&B)[jmax][imax]);

#endif
