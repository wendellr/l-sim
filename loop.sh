#!/bin/sh
# Executa N simulacoes (padrao: 100) e imprime as estatisticas de erro.
# Uso: ./loop.sh [N] [outras opcoes do l-sim.pl]

N=${1:-100}
[ $# -gt 0 ] && shift
exec perl "$(dirname "$0")/l-sim.pl" --rodadas "$N" "$@"
