#!/usr/bin/env bash
# Ejecuta tras ./gradlew genSources. Imprime los nombres reales en el código decompilado de 26.2.
set -e
SRC=$(find ~/.gradle -name 'minecraft-*-sources.jar' 2>/dev/null | head -1)
[ -z "$SRC" ] && { echo "No encuentro el sources.jar; ejecuta ./gradlew genSources"; exit 1; }
D=$(mktemp -d); (cd "$D" && unzip -q "$SRC")
echo "== Pantallas candidatas =="; find "$D" \( -name 'ShareToLanScreen.java' -o -name 'WorldOptionsScreen.java' -o -name 'MultiplayerOptionsScreen.java' \)
for f in $(find "$D" \( -name 'ShareToLanScreen.java' -o -name 'WorldOptionsScreen.java' -o -name 'MultiplayerOptionsScreen.java' \)); do
  echo; echo "== $f =="; grep -nE 'class |void init|allowCommands|commands|Commands|isHardcore|CycleButton|private .*;' "$f"
done
echo; echo "== Clave de traducción =="; grep -rn 'selectWorld.allowCommands' "$D" | head
