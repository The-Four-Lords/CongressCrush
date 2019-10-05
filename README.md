# Congress Crush

Juego de estilo puzzle en el que deberás combinar fichas para conseguir 350 escaños en 99 segundos.

## Reglas

Combina 3 fichas o más del mismo partido para conseguir escaños, cada ficha tiene un valor de 2 escaños.

![orange](./art/Pieces/Cs_logotipo_compacto.svg.png)
![yellow](./art/Pieces/ERC_logotipo_compacto.svg.png)
![purple](./art/Pieces/PODEMOS_logotipo_compacto.svg.png)
![blue](./art/Pieces/PP.svg.png)
![red](./art/Pieces/PSOE_logotipo_compacto.svg.png)
![green](./art/Pieces/Vox.svg.png)

Con combinaciones de 4 se obtiene un eliminador de fila o columna si el combo se ha hecho en fila o columna.

### Combinación de columna

![orange](./art/Pieces/CS_Column.png)
![yellow](./art/Pieces/ERC_column.png)
![purple](./art/Pieces/PODEMOS_Column.png)
![blue](./art/Pieces/PP_column.png)
![red](./art/Pieces/PSOE_Column.png)
![green](./art/Pieces/Vox_Column.png)

_Al utilizar estas piezas en una combinación, eliminaran las piezas de toda la columna dando escaños a sus respectivos partidos._

### Combinación de fila

![orange](./art/Pieces/CS_Row.png)
![yellow](./art/Pieces/ERC_Row.png)
![purple](./art/Pieces/PODEMOS_Row.png)
![blue](./art/Pieces/PP_Row.png)
![red](./art/Pieces/PSOE_Row.png)
![green](./art/Pieces/Vox_Row.png)

_Al utilizar estas piezas en una combinación, eliminaran las piezas de toda la fila dando escaños a sus respectivos partidos._

### Combinación en L

Al hacer una combinación en L de 3 piezas en columna y fila se obtiene una urna.

![orange](./art/Pieces/CS_Adjacent.png)
![yellow](./art/Pieces/ERC_Adjacent.png)
![purple](./art/Pieces/PODEMOS_Adjacent.png)
![blue](./art/Pieces/PP_Adjacent.png)
![red](./art/Pieces/PSOE_Adjacent.png)
![green](./art/Pieces/Vox_Adjacent.png)

_Combinando la urna con al menos otras 2 fichas de su partido, todas las fichas alrededor de esta se combinarán dando escaños a sus respectivos partidos._

### Combinaciones de 5

Combinando 5 fichas del mismo partido se obtiene una ficha de color, la cual eliminara todas las fichas del tablero de un color determinado al hacer _swap_ con esta.

![color](./art/Pieces/Color_bomb.png)

_Hacer swap entre dos fichas de color, elimina todo el tablero, dando escaños a los respectivos partidos._

## Créditos

Juego diseñado y programado por _The Four Lords_. **Este producto está hecho por un grupo de personas cuyas tendencias políticas e ideológicas son distintas ente si y nada tienen que ver con el producto propiamente.**

Este juego ha sido posible gracias a:

- [Godot Engine](https://godotengine.org/).
- Los tutoriales de [Mister Taft Creates](https://www.youtube.com/channel/UCZczqDvepgNqy80gTMGnUXw).
- Los políticos de nuestro país, los cuales al no ponerse de acuerdo nos han brindado 4 oportunidades en 4 años de sacar este juego.
