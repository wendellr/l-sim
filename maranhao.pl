#!/bin/perl

# limites do Maranhao (Bounderies num retangulo)
# http://www.mapdevelopers.com/geocode_bounding_box.php
$m_northlat = -1.049999;
$m_southlat = -10.261768;
$m_eastlon  = -41.795879;
$m_westlon  = -48.755145;

#Area do maranhao
$m_pol[0]{'lon'}=-46.054688; $m_pol[0]{'lat'}=-1.142502;
$m_pol[1]{'lon'}=-46.186523; $m_pol[1]{'lat'}=-1.450040;
$m_pol[2]{'lon'}=-46.164551; $m_pol[2]{'lat'}=-1.801461;
$m_pol[3]{'lon'}=-46.274414; $m_pol[3]{'lat'}=-2.086941;
$m_pol[4]{'lon'}=-46.450195; $m_pol[4]{'lat'}=-2.438229;
$m_pol[5]{'lon'}=-46.691895; $m_pol[5]{'lat'}=-2.635789;
$m_pol[6]{'lon'}=-46.691895; $m_pol[6]{'lat'}=-3.030812;
$m_pol[7]{'lon'}=-46.867676; $m_pol[7]{'lat'}=-3.403758;
$m_pol[8]{'lon'}=-47.087402; $m_pol[8]{'lat'}=-3.798484;
$m_pol[9]{'lon'}=-47.416992; $m_pol[9]{'lat'}=-4.214943;
$m_pol[10]{'lon'}=-47.658691; $m_pol[10]{'lat'}=-4.543570;
$m_pol[11]{'lon'}=-47.812500; $m_pol[11]{'lat'}=-4.609278;
$m_pol[12]{'lon'}=-48.164063; $m_pol[12]{'lat'}=-4.850154;
$m_pol[13]{'lon'}=-48.449707; $m_pol[13]{'lat'}=-5.134715;
$m_pol[14]{'lon'}=-48.142090; $m_pol[14]{'lat'}=-5.287887;
$m_pol[15]{'lon'}=-47.746582; $m_pol[15]{'lat'}=-5.397273;
$m_pol[16]{'lon'}=-47.416992; $m_pol[16]{'lat'}=-5.681584;
$m_pol[17]{'lon'}=-47.460938; $m_pol[17]{'lat'}=-5.856475;
$m_pol[18]{'lon'}=-47.416992; $m_pol[18]{'lat'}=-6.380812;
$m_pol[19]{'lon'}=-47.482910; $m_pol[19]{'lat'}=-6.773716;
$m_pol[20]{'lon'}=-47.680664; $m_pol[20]{'lat'}=-7.100893;
$m_pol[21]{'lon'}=-47.570801; $m_pol[21]{'lat'}=-7.449624;
$m_pol[22]{'lon'}=-47.329102; $m_pol[22]{'lat'}=-7.667441;
$m_pol[23]{'lon'}=-47.131348; $m_pol[23]{'lat'}=-8.015716;
$m_pol[24]{'lon'}=-46.911621; $m_pol[24]{'lat'}=-8.015716;
$m_pol[25]{'lon'}=-46.647949; $m_pol[25]{'lat'}=-7.928675;
$m_pol[26]{'lon'}=-46.516113; $m_pol[26]{'lat'}=-8.037473;
$m_pol[27]{'lon'}=-46.516113; $m_pol[27]{'lat'}=-8.211490;
$m_pol[28]{'lon'}=-46.713867; $m_pol[28]{'lat'}=-8.363693;
$m_pol[29]{'lon'}=-46.889648; $m_pol[29]{'lat'}=-8.646196;
$m_pol[30]{'lon'}=-47.065430; $m_pol[30]{'lat'}=-8.993600;
$m_pol[31]{'lon'}=-46.845703; $m_pol[31]{'lat'}=-9.253936;
$m_pol[32]{'lon'}=-46.604004; $m_pol[32]{'lat'}=-9.492408;
$m_pol[33]{'lon'}=-46.625977; $m_pol[33]{'lat'}=-9.730714;
$m_pol[34]{'lon'}=-46.428223; $m_pol[34]{'lat'}=-9.882275;
$m_pol[35]{'lon'}=-46.406250; $m_pol[35]{'lat'}=-10.120302;
$m_pol[36]{'lon'}=-46.230469; $m_pol[36]{'lat'}=-10.120302;
$m_pol[37]{'lon'}=-46.054688; $m_pol[37]{'lat'}=-10.271681;
$m_pol[38]{'lon'}=-45.922852; $m_pol[38]{'lat'}=-10.185187;
$m_pol[39]{'lon'}=-45.834961; $m_pol[39]{'lat'}=-9.709057;
$m_pol[40]{'lon'}=-45.812988; $m_pol[40]{'lat'}=-9.449062;
$m_pol[41]{'lon'}=-45.812988; $m_pol[41]{'lat'}=-8.537565;
$m_pol[42]{'lon'}=-45.747070; $m_pol[42]{'lat'}=-8.385431;
$m_pol[43]{'lon'}=-45.615234; $m_pol[43]{'lat'}=-8.080985;
$m_pol[44]{'lon'}=-45.483398; $m_pol[44]{'lat'}=-7.819847;
$m_pol[45]{'lon'}=-45.329590; $m_pol[45]{'lat'}=-7.558547;
$m_pol[46]{'lon'}=-44.890137; $m_pol[46]{'lat'}=-7.449624;
$m_pol[47]{'lon'}=-44.494629; $m_pol[47]{'lat'}=-7.231699;
$m_pol[48]{'lon'}=-44.296875; $m_pol[48]{'lat'}=-7.100893;
$m_pol[49]{'lon'}=-44.099121; $m_pol[49]{'lat'}=-6.795535;
$m_pol[50]{'lon'}=-43.769531; $m_pol[50]{'lat'}=-6.751896;
$m_pol[51]{'lon'}=-43.461914; $m_pol[51]{'lat'}=-6.839170;
$m_pol[52]{'lon'}=-43.176270; $m_pol[52]{'lat'}=-6.751896;
$m_pol[53]{'lon'}=-42.978516; $m_pol[53]{'lat'}=-6.599131;
$m_pol[54]{'lon'}=-42.868652; $m_pol[54]{'lat'}=-6.293459;
$m_pol[55]{'lon'}=-43.088379; $m_pol[55]{'lat'}=-5.725311;
$m_pol[56]{'lon'}=-42.912598; $m_pol[56]{'lat'}=-5.419148;
$m_pol[57]{'lon'}=-42.846680; $m_pol[57]{'lat'}=-5.025283;
$m_pol[58]{'lon'}=-42.912598; $m_pol[58]{'lat'}=-4.718778;
$m_pol[59]{'lon'}=-42.890625; $m_pol[59]{'lat'}=-4.455951;
$m_pol[60]{'lon'}=-42.978516; $m_pol[60]{'lat'}=-4.171115;
$m_pol[61]{'lon'}=-42.846680; $m_pol[61]{'lat'}=-4.017699;
$m_pol[62]{'lon'}=-42.670898; $m_pol[62]{'lat'}=-3.886177;
$m_pol[63]{'lon'}=-42.670898; $m_pol[63]{'lat'}=-3.557283;
$m_pol[64]{'lon'}=-42.473145; $m_pol[64]{'lat'}=-3.425692;
$m_pol[65]{'lon'}=-42.297363; $m_pol[65]{'lat'}=-3.491489;
$m_pol[66]{'lon'}=-42.143555; $m_pol[66]{'lat'}=-3.316018;
$m_pol[67]{'lon'}=-41.791992; $m_pol[67]{'lat'}=-2.899153;
$m_pol[68]{'lon'}=-42.033691; $m_pol[68]{'lat'}=-2.745531;
$m_pol[69]{'lon'}=-42.319336; $m_pol[69]{'lat'}=-2.767478;
$m_pol[70]{'lon'}=-42.539063; $m_pol[70]{'lat'}=-2.767478;
$m_pol[71]{'lon'}=-42.626953; $m_pol[71]{'lat'}=-2.613839;
$m_pol[72]{'lon'}=-42.868652; $m_pol[72]{'lat'}=-2.591889;
$m_pol[73]{'lon'}=-43.176270; $m_pol[73]{'lat'}=-2.460181;
$m_pol[74]{'lon'}=-43.461914; $m_pol[74]{'lat'}=-2.372369;
$m_pol[75]{'lon'}=-43.417969; $m_pol[75]{'lat'}=-2.569939;
$m_pol[76]{'lon'}=-43.571777; $m_pol[76]{'lat'}=-2.526037;
$m_pol[77]{'lon'}=-43.813477; $m_pol[77]{'lat'}=-2.504085;
$m_pol[78]{'lon'}=-43.945313; $m_pol[78]{'lat'}=-2.591889;
$m_pol[79]{'lon'}=-44.055176; $m_pol[79]{'lat'}=-2.723583;
$m_pol[80]{'lon'}=-44.208984; $m_pol[80]{'lat'}=-2.833317;
$m_pol[81]{'lon'}=-44.099121; $m_pol[81]{'lat'}=-2.526037;
$m_pol[82]{'lon'}=-44.099121; $m_pol[82]{'lat'}=-2.438229;
$m_pol[83]{'lon'}=-44.230957; $m_pol[83]{'lat'}=-2.460181;
$m_pol[84]{'lon'}=-44.340820; $m_pol[84]{'lat'}=-2.657738;
$m_pol[85]{'lon'}=-44.406738; $m_pol[85]{'lat'}=-2.943041;
$m_pol[86]{'lon'}=-44.538574; $m_pol[86]{'lat'}=-2.745531;
$m_pol[87]{'lon'}=-44.582520; $m_pol[87]{'lat'}=-2.613839;
$m_pol[88]{'lon'}=-44.428711; $m_pol[88]{'lat'}=-2.394322;
$m_pol[89]{'lon'}=-44.472656; $m_pol[89]{'lat'}=-2.130856;
$m_pol[90]{'lon'}=-44.560547; $m_pol[90]{'lat'}=-1.889306;
$m_pol[91]{'lon'}=-44.758301; $m_pol[91]{'lat'}=-1.669686;
$m_pol[92]{'lon'}=-44.890137; $m_pol[92]{'lat'}=-1.428075;
$m_pol[93]{'lon'}=-45.109863; $m_pol[93]{'lat'}=-1.493971;
$m_pol[94]{'lon'}=-45.263672; $m_pol[94]{'lat'}=-1.559866;
$m_pol[95]{'lon'}=-45.329590; $m_pol[95]{'lat'}=-1.384143;
$m_pol[96]{'lon'}=-45.549316; $m_pol[96]{'lat'}=-1.318243;
$m_pol[97]{'lon'}=-45.966797; $m_pol[97]{'lat'}=-1.164471;
$m_pol[98]{'lon'}=-46.054688; $m_pol[98]{'lat'}=-1.142502;
$m_pol[99]{'lon'}=-41.791992; $m_pol[99]{'lat'}=-2.899153;
