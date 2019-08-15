#!/usr/bin/perl
# main program;


require 'maranhao.pl';
require 'funcoes.pl';
require 'kml.pl';


# gera as estacoes dentro de um poligono
my ($num,@estacoes) = plot_in_sq_area(400,
				      $m_northlat,
				      $m_eastlon,
				      $m_southlat,
				      $m_westlon,
				      @m_pol);

#------------------------------------------------------------
kml_stations(@estacoes);
sleep 5;
#------------------------------------------------------------

# cria um raio aleatorio
%raio = do_strike($m_northlat,
                  $m_eastlon,
                  $m_southlat,
                  $m_westlon,
		  @m_pol);

#------------------------------------------------------------
kml_strike(\%raio,\@estacoes);
sleep 2;
#------------------------------------------------------------


# lista as estacoes por perto que detectaram a queda aleatória
my (@detec) = find_detectors(\%raio,\@estacoes);

#------------------------------------------------------------
kml_detectors(\%raio,\@estacoes,\@detec);
sleep 2;
#------------------------------------------------------------


# gera regioes de deteccao
my (@regioes) = make_range(@detectores);
#------------------------------------------------------------
kml_regions(\%raio,\@estacoes,\@detec,\@regioes);
sleep 5;
#------------------------------------------------------------

# calcula a triangulacao e ponto de interseção.
my (%raio_found) = guess_strike(\@detectores, \@regioes);
#------------------------------------------------------------
kml_found(\%raio,\@estacoes,\@detec,\@regioes,\%raio_found);
#------------------------------------------------------------

# calcula o erro em km
my $errokm = calc_error(\%raio_found,\%raio);

#print Dumper(%raio_found);
#print Dumper(%raio);

print "$errokm\n";

sleep 10;
