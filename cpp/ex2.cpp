#include <iostream>
#include "ex2.hpp"

namespace variables{
  double A[jmax][imax];
};


int main(){
  using namespace std;
  using namespace variables;
  setA();
  cout<<"A[0][0]="<<A[0][0]<<endl;
  double B[jmax][imax];
  
  for(int j=0;j<jmax;j++){
  for(int i=0;i<imax;i++){
    B[j][i] =A[j][i];
  }
  }
  cout<<"B[0][0]="<<B[0][0]<<endl;
  changeB(B);
  cout<<"B[0][0]="<<B[0][0]<<endl;
}

void setA(){
  using namespace variables;
  for(int j=0;j<jmax;j++){
  for(int i=0;i<imax;i++){
    A[j][i] =1.0e0;
  }
  }
}

template <size_t imax, size_t jmax>
void changeB(double (&B)[jmax][imax]){
  using namespace variables;
  for(int j=0;j<jmax;j++){
  for(int i=0;i<imax;i++){
    B[j][i] =2.0e0;
  }
  }
}



