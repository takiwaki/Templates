#include <iostream>
#include "ex1.hpp"

namespace cgs_units{
  const double c = 2.997924562e+10;
};

int main(){
  using namespace std;
  using namespace cgs_units;
  double kousoku;
  kousoku = c;
  cout<<"c=" <<kousoku <<endl;
  return 1;
}
