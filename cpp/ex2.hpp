#ifndef _CGS_UNITS
#define _CGS_UNITS

#define IMAX 2
#define JMAX 3

namespace variables{
  extern double A[JMAX][IMAX];
};

void setA();

template <size_t imax, size_t jmax>
void changeB(double (&B)[jmax][imax]);

#endif
