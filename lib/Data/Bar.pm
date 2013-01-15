use strict;
use warnings;
package Data::Bar;

sub new { return bless {}, shift }

sub _a { return shift->_b }
sub _b { return shift->_c }
sub _c { return shift->_d }
sub _d { return shift->_e }
sub _e { return shift->_f }
sub _f { return shift->_g }
sub _g { return shift->_h }
sub _h { return shift->_i }
sub _i { return shift->_j }
sub _j { return shift->_k }
sub _k { return shift->_l }
sub _l { return shift->_m }
sub _m { return shift->_n }
sub _n { return shift->_o }
sub _o { return shift->_p }
sub _p { return shift->_q }
sub _q { return shift->_r }
sub _r { return shift->_s }
sub _s { return shift->_t }
sub _t { return shift->_u }
sub _u { return shift->_v }
sub _v { return shift->_w }
sub _w { return shift->_x }
sub _x { return shift->_z }
sub _z { return 2 }

1;
