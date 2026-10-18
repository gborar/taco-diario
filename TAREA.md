# Tarea diaria: hoja nueva de Taco Diario

Cada mañana se prepara la hoja del día con 19 piezas **que no hayan salido nunca**, más 2 alternativas por categoría para el botón «Otra» (57 piezas en total). Este archivo es la referencia que sigue la tarea programada.

## Para quién es

Una persona curiosa con intereses amplios: inteligencia artificial, derecho, medicina, idiomas, física cuántica, nutrición y bienestar. Sus temas favoritos son **literatura, productividad, meditación, altas capacidades, ASMR, la estética «aesthetic» y aprender a aprender**. Haz que al menos 6 de las 19 piezas toquen esos temas favoritos.

Restricciones:
- **Nada de películas ni series violentas, thrillers ni policiacas.** Las bélicas y las históricas sí le gustan.
- Tiene la **rotación interna del hombro limitada**. Ningún micro-hábito puede implicar llevar la mano a la espalda, estiramientos de tríceps por detrás ni cargas por encima de la cabeza.
- Todo en español, salvo los títulos originales.

## Rigor

- Solo obras, personas, canales y datos **reales y verificables**. Si dudas de un título, un año o una cifra, compruébalo con WebSearch o elige otra pieza.
- Los datos curiosos, conceptos, frases célebres y orígenes de expresiones tienen que ser correctos. Si una cita es de atribución dudosa, dilo en el contexto.
- No inventes enlaces: la app construye las búsquedas a partir del título.

## Sin repeticiones

`historial.json` guarda el título (el primer campo) de todo lo que ya ha salido, por categoría. Antes de elegir una pieza, comprueba con Grep que su título no está en ese archivo. Compara sin distinguir mayúsculas. Tampoco vale el mismo título traducido: «Hábitos atómicos» y «Atomic Habits» son la misma pieza.

## Formato de la hoja

Archivo `hojas/AAAA-MM-DD.json`:

```json
{
  "date": "AAAA-MM-DD",
  "items":  { "video": [...], "articulo": [...], ... },
  "extras": { "video": [[...], [...]], "articulo": [[...], [...]], ... }
}
```

- `items`: la pieza principal de cada categoría.
- `extras`: exactamente 2 alternativas por categoría, con el mismo formato. Son las que salen al pulsar «Otra». Tampoco pueden repetir nada del historial, ni entre sí, ni con `items`.

Cada pieza es un array con estos campos, en este orden. Todos son textos salvo los años, que son números.

| Clave | Campos |
|---|---|
| `video` | título del vídeo, canal o autor, tema, por qué verlo |
| `articulo` | título, autor y publicación separados por « · », tema, por qué leerlo |
| `reel` | creador o cuenta, plataformas, consulta de búsqueda, qué verás, URL de búsqueda en TikTok (`https://www.tiktok.com/search?q=` + consulta codificada) o de perfil de Instagram si estás seguro de la cuenta |
| `libro` | título, autor, año, tema, por qué leerlo |
| `pelicula` | título, director, año, género, por qué verla |
| `programa` | título, cadena o creador, año, tipo, por qué verlo |
| `cancion` | título, artista, año, qué escuchar |
| `dato` | el dato en una o dos frases, tema |
| `concepto` | nombre, disciplina, explicación con un ejemplo o una analogía concreta (3-4 frases) |
| `cita` | frase, autor, contexto u obra |
| `reto` | enunciado, solución explicada |
| `pregunta` | la pregunta (un texto, no un array) |
| `personaje` | nombre, años de vida («1851–1921» o «n. 1976»), ocupación, por qué es interesante |
| `planta` | nombre común, nombre científico, curiosidad |
| `refran` | refrán, significado, equivalente en inglés |
| `frase` | frase hecha, significado, origen |
| `palabra` | palabra, código de idioma (`es`, `en`, `ja`, `pt`, `de`, `da`, `cy`), definición, ejemplo o curiosidad |
| `habito` | título corto, explicación de por qué funciona |
| `pausa` | título, tipo (`Meditación`, `ASMR`, `Aesthetic`, `Concentración`, `Escritura` o `Pausa`), descripción o instrucciones, consulta de YouTube o `null` si es una práctica sin vídeo |

Ejemplo: `hojas/2026-10-18.json`.

Antes de guardarla, comprueba que el JSON es válido, que `items` tiene las 19 claves y que `extras` tiene 2 piezas en cada una.

## Pasos

1. Escribe `hojas/<fecha>.json`.
2. Añade a `historial.json` el primer campo de cada pieza nueva, tanto de `items` como de `extras`, en su categoría. Para `pregunta`, la pregunta entera.
3. Guarda la misma hoja en la base de datos de la app de claude.ai con ArtifactData: action `set`, url `https://claude.ai/artifact/CZjewHcYAhL4BCUHejg6Xp`, collection `hojas`, doc_id = la fecha, data = `{"date": fecha, "json": <el contenido del archivo como texto>}`. Si ya existe, léelo con `get` y pasa su `version` como `if_version`.
4. Haz commit de `hojas/<fecha>.json`, `historial.json` y, si toca, `noticias.json`, con el mensaje `Hoja del <fecha>`, y súbelo a `main`.
