//
//  resonance_singleCELL.cpp
//  
//
//  Created by james roach on 5/10/16.
//
//

#include "resonance_singleCELL.hpp"



int main(int argc, char* argv[])
{

    if (argc != 5)
    {
        cout << "wrong number of input arguments" << endl;
        return -1;
    }
    int xl=1*time(NULL);
    Ran ICRand(xl);
    
    double gks   = atof(argv[1]);
    double amp = atof(argv[2]);
    double freq_osc = atof(argv[3]);
    double amp_dc   = atof(argv[4]);
    
    ofstream prams("params.txt");
    prams << gks << endl << amp << endl << freq_osc << endl << amp_dc << endl;
    prams.close();
    
    double tstep     =   0.05;
    double tfinal    = 50000.0;
    int no_steps     = 1*(tfinal/tstep);
    double time_now;
    double I_osc      =   .0;
    
    solutions out;
    double V     = -70.0 + 10.0*ICRand.doub();
    double h     =  0.5*ICRand.doub();
    double n_v   =  0.5*ICRand.doub();
    double s     =  0.5*ICRand.doub();
    double Vprev = V;
    
    int numspikes = 0;
    
    //ofstream vfile("V.txt");
    ofstream rast_file("raster_dat.txt");
    for (int i_t=0; i_t<no_steps; i_t++)
    {
        time_now = i_t*tstep;
        if ((Vprev<0.0)&&(V>=0.0))
        {
            rast_file << time_now << endl;
            ++ numspikes;
        }
        if ((time_now>=1000.0)&&(time_now<=40000.0))
        {
            I_osc = amp*cos(2.0*pi*freq_osc*time_now/1000.0);
        }
        else
        {
            I_osc = 0.0;
        }
        out = v_integrate (gks,V,h,n_v,s,I_osc+amp_dc,tstep);
        Vprev = V;
        V   = out.Vnew;
        h   = out.hnew;
        n_v = out.nnew;
        s   = out.snew;
        //vfile << time_now << " " << V << " " << I_osc+amp_dc << endl;
    }
    cout << numspikes << endl;
    //vfile.close();
    rast_file.close();
}
