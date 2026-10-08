#!/usr/bin/perl
# Funcoes de geracao e deteccao de raios (sem dependencias externas).

use strict;
use warnings;
use List::Util qw(min max sum);

use constant {
  PI           => 4 * atan2(1, 1),
  RAIO_TERRA_M => 6_371_008.8,   # raio medio da Terra (m)
};

# Faixas de deteccao em km (0-5, 5-13, 13-32, 32-64) ~ ml (0-3, 3-8, 8-20, 20-40).
# Faixas continuas: a estacao informa em qual faixa [min, max) o raio caiu.
our @FAIXAS = (
  { min => 0,  max => 5  },
  { min => 5,  max => 13 },
  { min => 13, max => 32 },
  { min => 32, max => 64 },
);

sub rad { $_[0] * PI / 180 }
sub deg { $_[0] * 180 / PI }

#
#---------------------------------------------------------------------------
# Geometria
#

# Distancia ortodromica (haversine) em km entre (lat1,lon1) e (lat2,lon2).
sub distancia_km {
  my ($lat1, $lon1, $lat2, $lon2) = @_;
  my $dlat = rad($lat2 - $lat1);
  my $dlon = rad($lon2 - $lon1);
  my $a = sin($dlat / 2)**2
        + cos(rad($lat1)) * cos(rad($lat2)) * sin($dlon / 2)**2;
  return 2 * RAIO_TERRA_M * atan2(sqrt($a), sqrt(1 - $a)) / 1000;
}

# Ponto a uma distancia (m) e azimute (rad, a partir do norte) de (lat0,lon0).
sub ponto_a_distancia {
  my ($dist_m, $azimute, $lat0, $lon0) = @_;
  my $d    = $dist_m / RAIO_TERRA_M;
  my $phi1 = rad($lat0);
  my $lam1 = rad($lon0);

  my $phi2 = asin_( sin($phi1) * cos($d) + cos($phi1) * sin($d) * cos($azimute) );
  my $lam2 = $lam1 + atan2( sin($azimute) * sin($d) * cos($phi1),
                            cos($d) - sin($phi1) * sin($phi2) );

  return { lat => deg($phi2), lon => deg($lam2) };
}

sub asin_ { my $x = shift; return atan2($x, sqrt(1 - $x * $x)) }

# Ponto dentro do poligono? (ray casting; poligono = lista de [lat, lon])
sub dentro_poligono {
  my ($lat, $lon, $pol) = @_;
  my $dentro = 0;
  my $n = @$pol;

  for (my $i = 0, my $j = $n - 1; $i < $n; $j = $i++) {
    my ($lati, $loni) = @{ $pol->[$i] };
    my ($latj, $lonj) = @{ $pol->[$j] };
    if ( ($lati > $lat) != ($latj > $lat)
         and $lon < ($lonj - $loni) * ($lat - $lati) / ($latj - $lati) + $loni ) {
      $dentro = !$dentro;
    }
  }
  return $dentro;
}

#
#---------------------------------------------------------------------------
# Simulacao
#

# Distribui ~$num estacoes numa grade regular sobre o retangulo da area e
# mantem apenas as que caem dentro do poligono.
sub gerar_estacoes {
  my ($num, $area) = @_;

  my $lado   = int(sqrt($num) + 0.5);
  my $dlat   = ($area->{north} - $area->{south}) / $lado;
  my $dlon   = ($area->{east}  - $area->{west})  / $lado;
  my @estacoes;

  for my $i (0 .. $lado - 1) {
    for my $j (0 .. $lado - 1) {
      my $lat = $area->{south} + ($i + 0.5) * $dlat;
      my $lon = $area->{west}  + ($j + 0.5) * $dlon;
      push @estacoes, { lat => $lat, lon => $lon }
        if dentro_poligono($lat, $lon, $area->{poligono});
    }
  }
  return @estacoes;
}

# Raio em posicao aleatoria (uniforme) dentro do poligono da area.
sub gerar_raio {
  my ($area) = @_;
  my ($lat, $lon);
  do {
    $lat = $area->{south} + rand($area->{north} - $area->{south});
    $lon = $area->{west}  + rand($area->{east}  - $area->{west});
  } while (!dentro_poligono($lat, $lon, $area->{poligono}));

  return { lat => $lat, lon => $lon };
}

# Estacoes que detectaram o raio, com a faixa de distancia correspondente.
sub encontrar_detectores {
  my ($raio, $estacoes) = @_;
  my @detectores;

  for my $idx (0 .. $#$estacoes) {
    my $e = $estacoes->[$idx];
    my $d = distancia_km($e->{lat}, $e->{lon}, $raio->{lat}, $raio->{lon});

    for my $f (@FAIXAS) {
      if ($d >= $f->{min} and ($d < $f->{max} or ($f == $FAIXAS[-1] and $d == $f->{max}))) {
        push @detectores, { %$e, idx => $idx, min => $f->{min}, max => $f->{max} };
        last;
      }
    }
  }
  return @detectores;
}

# Circulos (interno e externo) de cada faixa de deteccao, para o KML.
sub gerar_regioes {
  my (@detectores) = @_;
  my @regioes;

  for my $det (@detectores) {
    my %anel;
    for my $borda (qw(min max)) {
      my @circ = map {
        ponto_a_distancia($det->{$borda} * 1000, rad($_), $det->{lat}, $det->{lon})
      } 0 .. 360;    # 361 pontos: anel fechado
      $anel{$borda} = \@circ;
    }
    push @regioes, \%anel;
  }
  return @regioes;
}

# Estima a posicao do raio: varre, numa grade uniforme (km), o anel do
# detector de menor area e retorna o centroide dos pontos compativeis com
# todas as faixas. Se nenhum ponto satisfaz tudo, usa os de menor violacao.
# Precisa de >= 2 detectores.
sub estimar_raio {
  my (@detectores) = @_;
  return undef if @detectores < 2;

  my ($ref) = sort { ($a->{max}**2 - $a->{min}**2) <=> ($b->{max}**2 - $b->{min}**2) } @detectores;
  my $passo_km = 0.5;
  my $n = int($ref->{max} / $passo_km);
  my ($melhor, @pontos) = (9**9**9);

  for my $ix (-$n .. $n) {
    for my $iy (-$n .. $n) {
      my ($x, $y) = ($ix * $passo_km, $iy * $passo_km);
      my $dist = sqrt($x * $x + $y * $y);
      next if $dist < $ref->{min} or $dist > $ref->{max};
      my $p = ponto_a_distancia($dist * 1000, atan2($x, $y), $ref->{lat}, $ref->{lon});

      my $violacao = 0;
      for my $det (@detectores) {
        next if $det == $ref;
        my $d = distancia_km($det->{lat}, $det->{lon}, $p->{lat}, $p->{lon});
        $violacao += max(0, $det->{min} - $d, $d - $det->{max});
        last if $violacao > $melhor;
      }

      if ($violacao < $melhor) { ($melhor, @pontos) = ($violacao, $p) }
      elsif ($violacao == $melhor) { push @pontos, $p }
    }
  }

  return {
    lat      => sum(map { $_->{lat} } @pontos) / @pontos,
    lon      => sum(map { $_->{lon} } @pontos) / @pontos,
    violacao => $melhor,
    pontos   => scalar @pontos,
  };
}

# Erro de localizacao (km) entre o raio estimado e o real.
sub calc_erro {
  my ($estimado, $raio) = @_;
  return distancia_km($estimado->{lat}, $estimado->{lon}, $raio->{lat}, $raio->{lon});
}

1;
