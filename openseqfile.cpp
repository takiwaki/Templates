#include <stdio.h>
#include <iostream>
#include <fstream>

using namespace std;

main(){
  int n;
  FILE *fp;
  int ret;

  int i;

  char outfile[10];
  for(n=1;n<10;n++){
    ret=sprintf(outfile,"n%05d.dat",n);
    cout << outfile << endl;

    ofstream fout(outfile);
    for(i=1;i<10;i++){
      fout << i << endl;
    }
    fout.close();

  }
}
