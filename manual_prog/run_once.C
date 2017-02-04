#include <iostream>
#include <fstream>
#include <string>
#include<stdio.h>
using namespace std;
bool is_file_exist(const char *fileName)
{
    ifstream infile(fileName);
    return infile.good();
}

void run_once()
{
  // pls set the indices...
  Int_t i,j,k,n=5,m=5,o=6;

  Double_t max=0,min=0,c=0;

  // set n,m,o to be cardinality of set of energy,mass, and charge
  string hist,filename, histname,
  energy[5]={"1","100","500","1000","10000"},
  charge[6]={"1","0.1","0.01","0.005","0.002","0.0001"},
  mass="105*MeV";


  TH1D * Hist1[n][o];

  ifstream infile;
  ofstream out;
  // Creating a limit file....

  if(!is_file_exist("limit.h")) //checking whether the file exists and if it doesn't writing in it!
  {
    out.open("limit.h", std::ios::out | std::ios::app);
    out<<"// energy[5]={1,100,500,1000,10000}"<<endl<<"// charge[6]={1,0.1,0.01,0.005,0.002,0.0001}"<<endl;
    out<<"Double_t limit["<<n<<"]["<<m<<"][2]={"<<endl; //The starting line.


    // Recording to the created limit file.
    for(i=0;i<n;i++)
    {
      out<<"{ // Incident energy = "<<energy[i]<<"MeV"<<endl;
      for(j=0;j<m;j++)
      {
        histname = "For Charge = "+charge[j];
        filename="Muon_Stable=true_Energy="+energy[i]+"MeV_Mass_"+mass+"_Charge="+charge[j]+".txt";
        hist = histname+";Deposited Energy in  MeV; Counts";
        Hist1[i][j]= new TH1D(histname.c_str(),hist.c_str(),10000000,0.000000001,40);


        // Checking for filename...
        if(is_file_exist(filename.c_str()))
        {
          // cout<<filename<<" FOUND!"<<endl;
          infile.open(filename.c_str());

          while(!infile.eof())
             {
                infile >> c;
                // cout<<c<<endl;
                Hist1[i][j]->Fill(c);

              }


              // max = Hist1[i][j]->FindLastBinAbove(0,1);
              // min = Hist1[i][j]->FindFirstBinAbove(0,1);
          max = Hist1[i][j]->GetXaxis()->GetBinCenter(Hist1[i][j]->FindLastBinAbove(3,1));
          min = Hist1[i][j]->GetXaxis()->GetBinCenter(Hist1[i][j]->FindFirstBinAbove(3,1));
          infile.close();
          out<<"{"<<min<<","<<max<<"}";
          if(j!=m-1) out<<", // charge = "<<charge[j]<<endl;
          else out<<"//charge = "<<charge[j]<<endl;
          cout<<charge[j]<<"\t"<<Hist1[i][j]->GetMean()<<"\t"<<min<<","<<max<<endl;
          delete Hist1[i][j];
        }
        else
        {
          cout<<endl<<"Sorry, "<<filename<<" doesn't exist"<<endl;
          // mean[i][j]=0;
        }
      }
      out<<"}"<<endl;
      if(i!=n-1) out<<","<<endl;
      else out<<endl;

  }
  out<<"};"<<endl;
  }
  else{
    cout<<"limit.h file exists, please delete the file and run the programme."<<endl;
  }

}
