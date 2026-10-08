#!/usr/bin/perl
# Saida no formato KML (Google Earth).
#
# kml_escrever($arquivo, %camadas) gera um unico KML com as camadas
# informadas (todas opcionais):
#   estacoes   => [ {lat, lon}, ... ]
#   detectores => [ {lat, lon, idx, min, max}, ... ]   (estacoes em verde)
#   regioes    => [ {min => [pontos], max => [pontos]}, ... ]
#   raio       => {lat, lon}                            (raio real)
#   estimado   => {lat, lon}                            (raio localizado)
#
# O arquivo e gravado num temporario e renomeado, para que o NetworkLink do
# Google Earth (upd.kml) nunca leia um arquivo pela metade.

use strict;
use warnings;

my $ICONE_ESTACAO  = 'https://maps.google.com/mapfiles/kml/shapes/placemark_circle.png';
my $ICONE_RAIO     = 'https://cdn2.iconfinder.com/data/icons/weather-24/256/Storm-64.png';
my $ICONE_ESTIMADO = 'http://icons.iconarchive.com/icons/paomedia/small-n-flat/64/lightning-icon.png';

# Cores KML: aabbggrr
my @CORES_REGIAO = qw(5514b4ff 55ff7814 5514f0ff 55b414ff 5500ff96 55ffc800);

my $KML_CABECALHO = <<"KML";
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
  <name>L-SIM</name>
  <Style id="estacao">
    <IconStyle><color>ff0000ff</color><scale>0.8</scale><Icon><href>$ICONE_ESTACAO</href></Icon></IconStyle>
  </Style>
  <Style id="detector">
    <IconStyle><color>ff00ff00</color><scale>1.1</scale><Icon><href>$ICONE_ESTACAO</href></Icon></IconStyle>
  </Style>
  <Style id="raio">
    <IconStyle><scale>2</scale><Icon><href>$ICONE_RAIO</href></Icon>
      <hotSpot x="0.5" y="0.5" xunits="fraction" yunits="fraction"/></IconStyle>
  </Style>
  <Style id="estimado">
    <IconStyle><scale>1.3</scale><Icon><href>$ICONE_ESTIMADO</href></Icon></IconStyle>
  </Style>
KML

my $KML_RODAPE = "</Document>\n</kml>\n";

sub kml_ponto {
  my ($fh, $nome, $estilo, $p) = @_;
  printf $fh "  <Placemark><name>%s</name><styleUrl>#%s</styleUrl>"
           . "<Point><coordinates>%.6f,%.6f,0</coordinates></Point></Placemark>\n",
         $nome, $estilo, $p->{lon}, $p->{lat};
}

sub kml_anel {
  my ($fh, $pontos) = @_;
  print $fh "<LinearRing><coordinates>\n";
  printf $fh "%.6f,%.6f,0\n", $_->{lon}, $_->{lat} for @$pontos;
  print $fh "</coordinates></LinearRing>";
}

sub kml_escrever {
  my ($arquivo, %c) = @_;
  my $tmp = "$arquivo.tmp";

  open(my $fh, '>', $tmp) or die "Nao foi possivel gravar $tmp: $!\n";
  print $fh $KML_CABECALHO;

  my %detectou = map { $_->{idx} => 1 } @{ $c{detectores} || [] };

  if (my $est = $c{estacoes}) {
    print $fh "  <Folder><name>Estacoes</name>\n";
    for my $i (0 .. $#$est) {
      kml_ponto($fh, "E$i", $detectou{$i} ? 'detector' : 'estacao', $est->[$i]);
    }
    print $fh "  </Folder>\n";
  }

  if (my $reg = $c{regioes}) {
    print $fh "  <Folder><name>Regioes de deteccao</name>\n";
    for my $i (0 .. $#$reg) {
      my $det = $c{detectores}[$i];
      my $cor = $CORES_REGIAO[$i % @CORES_REGIAO];
      printf $fh "  <Placemark><name>E%d: %d-%d km</name>\n", $det->{idx}, $det->{min}, $det->{max};
      print  $fh "  <Style><LineStyle><width>0</width></LineStyle>"
               . "<PolyStyle><color>$cor</color><outline>0</outline></PolyStyle></Style>\n";
      print  $fh "  <Polygon><tessellate>1</tessellate><altitudeMode>clampToGround</altitudeMode>\n";
      print  $fh "  <outerBoundaryIs>"; kml_anel($fh, $reg->[$i]{max}); print $fh "</outerBoundaryIs>\n";
      if ($det->{min} > 0) {
        print $fh "  <innerBoundaryIs>"; kml_anel($fh, $reg->[$i]{min}); print $fh "</innerBoundaryIs>\n";
      }
      print  $fh "  </Polygon></Placemark>\n";
    }
    print $fh "  </Folder>\n";
  }

  kml_ponto($fh, 'Raio real',     'raio',     $c{raio})     if $c{raio};
  kml_ponto($fh, 'Raio estimado', 'estimado', $c{estimado}) if $c{estimado};

  print $fh $KML_RODAPE;
  close($fh) or die "Erro ao gravar $tmp: $!\n";
  rename($tmp, $arquivo) or die "Nao foi possivel renomear $tmp: $!\n";
}

1;
