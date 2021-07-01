#include <iostream>
#include "ex3.hpp"

constexpr int imax=3;
constexpr int jmax=2;

namespace variables{
  matrix<double> A;
};


int main(){
  using namespace std;
  using namespace variables;
  setA();
  cout<<"A[0][0]="<<A(0,0)<<endl;
  matrix<double> B(jmax,imax);
  
  for(int j=0;j<jmax;j++){
  for(int i=0;i<imax;i++){
    B(j,i) = A(j,i);
  }
  }
  cout<<"B[0][0]="<<B(0,0)<<endl;
  changeB(B);
  cout<<"B[0][0]="<<B(0,0)<<endl;
  showB(B);
  cout<<"B[10][10]="<<B(10,10)<<endl;
}

void setA(){
  using namespace variables;
  A.allocate(jmax,imax);
  for(int j=0;j<jmax;j++){
  for(int i=0;i<imax;i++){
    A(j,i) =1.0e0;
  }
  }
}

void changeB(matrix<double> (&B)){
  for(int j=0;j<jmax;j++){
  for(int i=0;i<imax;i++){
    B(j,i) =2.0e0;
  }
  }
}
void showB(const matrix<double> (&B)){
  for(int j=0;j<jmax;j++){
  for(int i=0;i<imax;i++){
    std::cout<<B(j,i)<<std::endl;
  }
  }
}



