#!/bin/perl
# Funcoes auxiliares

use Geo::Distance;
use Data::Dumper;

#
#---------------------------------------------------------------------------
#

# Funcoes Geo
my $geo = new Geo::Distance;
$geo->formula('gcd');

# Ranges de deteccao em km (0-5,5-13,13-32,32-64) ou ml (0-3,3-8,8-20,20-40)
$range[0]{'min'} = 0; 
$range[0]{'max'} = 5;
$range[1]{'min'} = 6;
$range[1]{'max'} = 13;
$range[2]{'min'} = 14;
$range[2]{'max'} = 32;
$range[3]{'min'} = 33;
$range[3]{'max'} = 64;

#
#---------------------------------------------------------------------------
#

sub region_in_a_distance {
# distancia
# angulo
# lat0
# lat1
$ct1 = 111320; #constantes da Terra
$ct2 = 110540;
   my ($D,$theta,$lat0,$lon0) = @_;
   $dx = $D*cos($theta);
   $dy = $D*sin($theta);

   $d_lon = $dx/($ct1*cos($lat0*0.0174533));
   $d_lat = $dy/$ct2;

   $pfinal{'lon'} = $lon0 + $d_lon;
   $pfinal{'lat'} = $lat0 + $d_lat;

   return %pfinal;
}


#
#---------------------------------------------------------------------------
#

sub is_in_area
{
    my($y,$x,@polygon) = @_;

    if($polygon[0] != $polygon[$#polygon-1]){
        $polygon[$#polygon] = $polygon[0];
    }

    my $i,$j;
    $j = 0;
    $oddNodes = false;
    $n = $#polygon;

    for ($i = 0; $i < $n; $i++)
    {
        $j++;
        if ($j == $n)
        {
            $j = 0;
        }
        if ((($polygon[$i]{'lat'} < $y) && ($polygon[$j]{'lat'} >= $y)) || (($polygon[$j]{'lat'} < $y) && ($polygon[$i]{'lat'} >=
            $y)))
        {
            if ($polygon[$i]{'lon'} + ($y - $polygon[$i]{'lat'}) / ($polygon[$j]{'lat'} - $polygon[$i]{'lat'}) * ($polygon[$j]{'lon'} -
                $polygon[$i]{'lon'}) < $x)
            {
                $oddNodes = !$oddNodes;
            }
        }
    }
    return !$oddNodes;
}


sub plot_in_sq_area {

  my @estacao;
  my @est_in;
  my $i,$j;
  my ($numestacoes,$northlat,$eastlon,$southlat,$westlon,@pol) = @_;

  my $latdif = $northlat - $southlat;
  my $londif = $eastlon - $westlon;

  for ($i=0;$i<sqrt($numestacoes);$i++) {
    for ($j=0;$j<sqrt($numestacoes);$j++) {
     $estacao[$i*sqrt($numestacoes)+$j]{'lat'} = $i*$latdif/sqrt($numestacoes) + $southlat;
     $estacao[$i*sqrt($numestacoes)+$j]{'lon'} = $j*$londif/sqrt($numestacoes) + $westlon;
    }
  }


  $c=0; # contador de estacoes dentro da area quadrada

  for ($k=0;$k<$numestacoes;$k++) {
   if (is_in_area($estacao[$k]{'lat'},$estacao[$k]{'lon'},@pol)) {
     $est_in[$c]{'lat'}=$estacao[$k]{'lat'};
     $est_in[$c]{'lon'}=$estacao[$k]{'lon'};
     $c++;
   }
  }

  return ($c,@est_in);
}

sub do_strike {

  my ($northlat,$eastlon,$southlat,$westlon,@pol) = @_;

  my $latdif = $northlat - $southlat;
  my $londif = $eastlon - $westlon;
  my %raio;
  do {
   $raio{'lat'} = rand($latdif) + $southlat;
   $raio{'lon'} = rand($londif) + $westlon;
  }while (!is_in_area($raio{'lat'},$raio{'lon'},@pol));

  return %raio;
}

sub find_detectors {

  my (%raio) = %{$_[0]};
  my (@estacao) = @{$_[1]};

  my $cd=0;
  my $distance=0;

  for ($i=0;$i<=$#estacao;$i++) {
   $distance = int($geo->distance( 'kilometer', 
		    $estacao[$i]{'lon'},
		    $estacao[$i]{'lat'} =>
		    $raio{'lon'},
		    $raio{'lat'}));

   #print "$i $distance\n";

   for ($z=0;$z<4;$z++) {
     if ($distance <= $range[$z]{'max'} and $distance >= $range[$z]{'min'}) {
       $detectores[$cd]{'lat'} = $estacao[$i]{'lat'};
       $detectores[$cd]{'lon'} = $estacao[$i]{'lon'};
       $detectores[$cd]{'min'} = $range[$z]{'min'};
       $detectores[$cd]{'max'} = $range[$z]{'max'};
       $cd++;
     } # fim do if
    } # fim do for 4 ranges

  } # for estacoes
  
  return @detectores;
}


sub make_range {

  my (@detectores) = @_;
  for ($z=0;$z<=$#detectores;$z++) {
   $pnt=0;
   for ($angle=0;$angle<360;$angle++) {
	%result = region_in_a_distance($detectores[$z]{'min'}*1000, $angle*0.0174533, $detectores[$z]{'lat'},$detectores[$z]{'lon'});
	$poli[$z][$pnt]{'lat'} = $result{'lat'};
	$poli[$z][$pnt]{'lon'} = $result{'lon'};
        $pnt++;
   } 
   for ($angle=0;$angle<360;$angle++) {
	%result = region_in_a_distance($detectores[$z]{'max'}*1000, $angle*0.0174533, $detectores[$z]{'lat'},$detectores[$z]{'lon'});
	$poli[$z][$pnt]{'lat'} = $result{'lat'};
	$poli[$z][$pnt]{'lon'} = $result{'lon'};
        $pnt++;
   } 
  } # fim for geral

  return @poli; # retorna o poligono todo
}


sub guess_strike{
# Localiza ponto de interesecao

  my (@detectores) = @{$_[0]};
  my (@poli) = @{$_[1]};

   my $ref1=$detectores[0]{'lat'};
   my $ref2=$detectores[0]{'lon'};
   my $min =$detectores[0]{'min'}*1000;
   my $max =$detectores[0]{'max'}*1000;

   if ($#detectores>=1) {  #minimo suficiente
   OUTER:
   for ($angle=0;$angle<360;$angle++) {
      $step=1000; #1km
      for ($dist=$min;$dist<=$max;$dist+=$step) {
	%result = region_in_a_distance($dist, $angle*0.0174533, $ref1,$ref2);

	# cada outro compara!
	$lat1=$result{'lat'};
	$lon1=$result{'lon'};
	$todos=1;
	for ($z=1;$z<=$#detectores;$z++) {

	  for ($p=0;$p<720;$p++) {   #le o poligono
		$polig[$p]=$poli[$z][$p];
	  }

	  if (!is_in_area($lat1,$lon1,@polig)) { #procura o que esta em tudo
		$todos=0;
	  }
	}

	if ($todos==1) { 
		$pfound{'lat'}=$lat1;
		$pfound{'lon'}=$lon1;
		last OUTER;
	}

       } #fim for 1
      } #fim for 2
     }#fim if

    return %pfound;
}


sub calc_error {
   my (%pfound) = %{$_[0]};
   my (%raio) = %{$_[1]};

   my $distance = int($geo->distance( 'kilometer', $pfound{'lon'},$pfound{'lat'} =>$raio{'lon'},$raio{'lat'}));

   return $distance;
}
