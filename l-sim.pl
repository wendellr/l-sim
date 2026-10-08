#!/usr/bin/perl
# L-Sim - Simulador de Descargas Atmosfericas (programa principal)
#
# Uso:
#   perl l-sim.pl                    # demonstracao passo a passo no Google Earth
#   perl l-sim.pl --rodadas 1000     # estatisticas de erro (sem KML/pausas)
#   perl l-sim.pl --help

use strict;
use warnings;
use FindBin qw($Bin);
use Getopt::Long;
use List::Util qw(sum);

require "$Bin/funcoes.pl";
require "$Bin/kml.pl";

my %opt = (
  estacoes => 400,
  rodadas  => 1,
  kml      => "$Bin/a.kml",
  area     => "$Bin/maranhao.pl",
  pausa    => 1,
);

GetOptions(
  'estacoes|n=i' => \$opt{estacoes},
  'rodadas|r=i'  => \$opt{rodadas},
  'kml|o=s'      => \$opt{kml},
  'area|a=s'     => \$opt{area},
  'semente|s=i'  => \$opt{semente},
  'pausa!'       => \$opt{pausa},
  'help|h'       => \$opt{help},
) or uso(1);
uso(0) if $opt{help};
die "--estacoes e --rodadas devem ser positivos\n" if $opt{estacoes} < 1 or $opt{rodadas} < 1;

srand($opt{semente}) if defined $opt{semente};

# "do" so procura no diretorio atual se o caminho for explicito
my $arq_area = $opt{area} =~ m{^\.{0,2}/} ? $opt{area} : "./$opt{area}";
my $area = do $arq_area or die "Nao foi possivel carregar a area $opt{area}: ", ($@ || $!), "\n";

# gera as estacoes dentro do poligono da area
my @estacoes = gerar_estacoes($opt{estacoes}, $area);
die "Nenhuma estacao dentro da area\n" unless @estacoes;

if ($opt{rodadas} == 1) {
  demonstracao();
} else {
  estatisticas();
}

#------------------------------------------------------------
# Uma rodada, gravando o KML a cada etapa (acompanhe com upd.kml).
sub demonstracao {
  my $kml   = $opt{kml};
  my $pausa = sub { sleep $_[0] if $opt{pausa} };
  my %c     = (estacoes => \@estacoes);

  kml_escrever($kml, %c);
  $pausa->(5);

  # cria um raio aleatorio
  $c{raio} = gerar_raio($area);
  kml_escrever($kml, %c);
  $pausa->(2);

  # estacoes que detectaram o raio
  $c{detectores} = [ encontrar_detectores($c{raio}, \@estacoes) ];
  kml_escrever($kml, %c);
  $pausa->(2);

  # regioes de deteccao
  $c{regioes} = [ gerar_regioes(@{ $c{detectores} }) ];
  kml_escrever($kml, %c);
  $pausa->(5);

  # triangulacao
  my $estimado = estimar_raio(@{ $c{detectores} });
  $c{estimado} = $estimado if $estimado;
  kml_escrever($kml, %c);

  printf STDERR "Area: %s | estacoes: %d | detectores: %d\n",
    $area->{nome}, scalar @estacoes, scalar @{ $c{detectores} };

  if ($estimado) {
    printf "%.2f\n", calc_erro($estimado, $c{raio});
  } else {
    print "NA\n";
    print STDERR "Raio nao localizado (menos de 2 estacoes detectaram).\n";
  }
}

#------------------------------------------------------------
# Varias rodadas: imprime o erro de cada uma e um resumo.
sub estatisticas {
  my (@erros, %det_por_raio);
  my $nao_localizados = 0;

  for my $r (1 .. $opt{rodadas}) {
    my $raio  = gerar_raio($area);
    my @det   = encontrar_detectores($raio, \@estacoes);
    my $est   = estimar_raio(@det);
    $det_por_raio{ scalar @det }++;

    if ($est) {
      my $erro = calc_erro($est, $raio);
      push @erros, $erro;
      printf "%d\t%d\t%.2f\n", $r, scalar @det, $erro;
    } else {
      $nao_localizados++;
      printf "%d\t%d\tNA\n", $r, scalar @det;
    }
  }

  my @ord = sort { $a <=> $b } @erros;
  my $pct = sub { $ord[ int($_[0] * $#ord + 0.5) ] };

  printf STDERR "\nArea: %s | estacoes: %d | rodadas: %d\n",
    $area->{nome}, scalar @estacoes, $opt{rodadas};
  printf STDERR "Detectores por raio: %s\n",
    join(', ', map { "$_: $det_por_raio{$_}" } sort { $a <=> $b } keys %det_por_raio);
  printf STDERR "Localizados: %d (%.1f%%) | nao localizados: %d\n",
    scalar @erros, 100 * @erros / $opt{rodadas}, $nao_localizados;
  if (@ord) {
    printf STDERR "Erro (km): media %.2f | mediana %.2f | p90 %.2f | max %.2f\n",
      sum(@ord) / @ord, $pct->(0.5), $pct->(0.9), $ord[-1];
  }
}

sub uso {
  print <<"USO";
Uso: perl l-sim.pl [opcoes]

  -n, --estacoes N   numero aproximado de estacoes na grade (padrao: 400)
  -r, --rodadas N    numero de raios simulados (padrao: 1)
                     com N > 1 nao gera KML e imprime estatisticas de erro
  -o, --kml ARQ      arquivo KML de saida (padrao: a.kml no diretorio do programa)
  -a, --area ARQ     arquivo da area de simulacao (padrao: maranhao.pl)
  -s, --semente N    semente do gerador aleatorio (resultados reprodutiveis)
      --no-pausa     nao espera entre as etapas da demonstracao
  -h, --help         mostra esta ajuda
USO
  exit $_[0];
}
