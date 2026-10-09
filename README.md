# L-Sim — Simulador de Descargas Atmosféricas

O L-Sim simula uma rede de sensores de raios e mede o quanto ela consegue
localizar uma descarga atmosférica. O cenário padrão é o estado do Maranhão.

Cada rodada da simulação faz o seguinte:

1. **Estações**: distribui sensores numa grade regular sobre a área (por padrão,
   ~400 pontos no retângulo envolvente; ficam apenas os que estão dentro do polígono).
2. **Raio**: sorteia uma descarga em posição aleatória dentro da área.
3. **Detecção**: cada estação a até 64 km informa só a *faixa* de distância
   em que o raio caiu, e não a distância exata:

   | Faixa | Distância (km) | ~ milhas |
   |-------|----------------|----------|
   | 1     | 0 – 5          | 0 – 3    |
   | 2     | 5 – 13         | 3 – 8    |
   | 3     | 13 – 32        | 8 – 20   |
   | 4     | 32 – 64        | 20 – 40  |

4. **Regiões**: cada detecção vira um anel (coroa circular) em torno da estação.
5. **Localização**: a posição estimada é o centroide da interseção de todos os
   anéis (são necessárias pelo menos 2 estações).
6. **Erro**: a distância, em km, entre o raio estimado e o raio real.

## Versão web interativa

Abra o [`index.html`](index.html) no navegador (duplo clique). Não precisa de instalação nem de servidor.

- A simulação é animada em 6 etapas, com uma explicação em cada uma: rede de estações → queda do raio →
  onda chegando às estações → anéis de cada faixa → interseção → estimativa e erro.
- **Clique no mapa** para escolher onde o raio cai.
- Use os controles para reproduzir, pausar, avançar etapa, mudar a velocidade (0,5×, 1×, 2×) e
  ajustar a densidade da rede.
- O **modo estatístico** simula 200, 1.000 ou 5.000 raios. Ele mostra o histograma do erro e um mapa
  com cada raio colorido pelo erro, revelando onde a rede localiza pior.
- **Links diretos:** `index.html#etapa1` a `#etapa6` abrem uma etapa já concluída, e `#estatisticas`
  roda o modo estatístico. São úteis em aula.

A página usa o mesmo algoritmo do `funcoes.pl`, reescrito em JavaScript.

## Requisitos

- Perl 5.10 ou superior. Só são usados módulos do core (`Getopt::Long`, `List::Util`, `FindBin`);
  não é preciso instalar nada do CPAN.
- [Google Earth](https://www.google.com/earth/versions/) (opcional), para visualizar a simulação.

## Uso

### Demonstração no Google Earth

```sh
perl l-sim.pl
```

1. Abra o `upd.kml` no Google Earth. Ele recarrega o `a.kml` a cada 1 segundo.
2. Rode o comando acima. O `a.kml` é regravado a cada etapa, com pausas entre elas:
   estações (vermelho) → raio → estações que detectaram (verde) → regiões de detecção →
   raio estimado.
3. O erro de localização (km) aparece na saída padrão (`NA` quando o raio não foi localizado).

### Estatísticas de erro

```sh
perl l-sim.pl --rodadas 1000
# ou
./loop.sh 1000
```

Cada rodada imprime uma linha `rodada<TAB>detectores<TAB>erro_km`. Ao final, um
resumo vai para a saída de erro:

```
Area: Maranhao | estacoes: 165 | rodadas: 200
Detectores por raio: 1: 1, 2: 6, 3: 10, 4: 26, 5: 29, 6: 79, 7: 39, 8: 10
Localizados: 199 (99.5%) | nao localizados: 1
Erro (km): media 7.28 | mediana 6.17 | p90 13.29 | max 47.31
```

### Opções

| Opção | Descrição | Padrão |
|-------|-----------|--------|
| `-n`, `--estacoes N` | número aproximado de estações na grade | 400 |
| `-r`, `--rodadas N` | número de raios simulados (com N > 1, não gera KML) | 1 |
| `-o`, `--kml ARQ` | arquivo KML de saída | `a.kml` |
| `-a`, `--area ARQ` | arquivo com a área de simulação | `maranhao.pl` |
| `-s`, `--semente N` | semente aleatória (resultados reproduzíveis) | — |
| `--no-pausa` | não espera entre as etapas da demonstração | — |
| `-h`, `--help` | ajuda | — |

Exemplo: comparar a densidade da rede.

```sh
for n in 100 400 900; do perl l-sim.pl -n $n -r 500 -s 1 > /dev/null; done
```

## Arquivos

| Arquivo | Conteúdo |
|---------|----------|
| `index.html` | Versão web interativa e animada (abre direto no navegador) |
| `l-sim.pl` | Programa principal (demonstração passo a passo e modo estatístico) |
| `funcoes.pl` | Geometria (haversine, ponto em polígono) e algoritmos de geração, detecção e localização |
| `kml.pl` | Geração da saída KML (Google Earth) |
| `maranhao.pl` | Área de simulação: polígono do Maranhão (lat/lon) e retângulo envolvente |
| `upd.kml` | *NetworkLink* que recarrega o `a.kml` a cada 1 s no Google Earth |
| `loop.sh` | Atalho para `l-sim.pl --rodadas N` |

### Usando outra área

Crie um arquivo no formato do `maranhao.pl`, que deve retornar um hash com `nome`,
`north`, `south`, `east`, `west` e `poligono` (uma lista de `[lat, lon]`), e rode:

```sh
perl l-sim.pl --area minha_area.pl
```

## Autor

Wendell Rodrigues

## Licença

[GNU GPL v3](LICENSE)
