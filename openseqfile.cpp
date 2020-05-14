#include <iostream>
#include <iomanip>
#include <fstream>

using namespace std;

main(){
  // index for time
  int n;
  double t;

  // for output file
  char outfile[10];
  FILE *fout;
  int ret;

  // some array
  const int in=100;
    double   x[in];
    double rho[in];
  int i;
  
  for(i=1;i<in;i++){
    x[i] = 0.1*i;
  }

  for(n=1;n<10;n++){
    t=0.1*n;
    for(i=0;i<in;i++){
      rho[i] = (x[i]-t);
    }

    ret=sprintf(outfile,"n%05d.dat",n);
    cout << outfile << endl;

    fout = fopen(outfile,"wt");
      fprintf(fout, "# %12.7e\n",t);
      fprintf(fout, "# %12s %12s\n","x[cm]","rho[g/cm^3]");
    for(i=0;i<in;i++){
      fprintf(fout, "  %12.5e %12.5e\n",x[i],rho[i]);
    }
    fclose(fout);

  }
}
