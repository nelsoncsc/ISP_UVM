#include "systemc.h"
#include "tlm.h"
using namespace tlm;

void rgb2ycbcr(unsigned long long);

struct tr {
  unsigned long long a;
};

#include "uvmc.h"
using namespace uvmc;
UVMC_UTILS_1(tr, a)


SC_MODULE(refmod) {
  sc_port<tlm_get_peek_if<tr> > in;
  sc_port<tlm_put_if<tr> > out;

  void p() {
    tr tr;
    while (1) {

      tr = in->get();
      rgb2ycbcr(tr.a); // in place
      out->put(tr);

    }
  }
  SC_CTOR(refmod): in("in"), out("out") { SC_THREAD(p); }
};

int sc_main(int argc, char* argv[]) {
 
  refmod  refmod_i("refmod_i");
  
  uvmc_connect(refmod_i.in, "refmod_i.in");
  uvmc_connect(refmod_i.out, "refmod_i.out");

  sc_start();
  return(0);
}

