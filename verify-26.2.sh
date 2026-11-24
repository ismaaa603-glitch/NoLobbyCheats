#!/usr/bin/env bash
# Tras ./gradlew genSources: imprime los nombres reales en el código decompilado de 26.2.
D=$(mktemp -d)
echo "== sources jars/dirs =="; find / \( -name '*sources*.jar' -o -name '*Sources*' \) \( -path '*loom*' -o -path '*minecraft*' -o -path '*.gradle*' \) 2>/dev/null | grep -iv 'fabric-api\|loader' | head -20
for j in $(find / -name '*sources*.jar' \( -path '*loom*' -o -path '*minecraft*' \) 2>/dev/null | grep -iv 'fabric-api\|loader'); do unzip -qo "$j" -d "$D" 2>/dev/null; done
FILES=$(find "$D" \( -name 'ShareToLanScreen.java' -o -name 'WorldOptionsScreen.java' -o -name 'MultiplayerOptionsScreen.java' \))
echo "== Pantallas =="; echo "$FILES"
for f in $FILES; do echo; echo "===== $f ====="; cat "$f"; done
for f in $(find "$D" -name 'IntegratedServer.java'); do echo; echo "===== $f ====="; grep -nE 'AllowCommands|commandsAllowed|isHardcore|OtherPlayers|isPublished|updatePermission' -B1 -A8 "$f"; done
echo; echo "== selectWorld.allowCommands =="; grep -rn 'selectWorld.allowCommands' "$D" | head
