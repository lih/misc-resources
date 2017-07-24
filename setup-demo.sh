#!/bin/bash
cd "$(dirname "$0")" >/dev/null

if [ "$1" != in ]; then
    tty=".setup-demo.tty"
    ttyrec -e "./setup-demo.sh in" "$tty" \
	&& ttygif "$tty" \
	&& mv tty.gif setup-demo.gif
    exit
else
    cd setup-demo >/dev/null
fi

delays=( 0.05 0.05 0.05 0.05 0.1 0.2 )
function +() {
    sleep "${SLEEP:-1}"
    local i=0 cmd="$*"
    for((i=0;i<${#cmd};i++)); do
	printf "%s" "${cmd:i:1}"
	sleep "${delays[RANDOM%${#delays[@]}]}"
    done
    printf "\n"
    eval "$cmd"
    printf "> "
}

printf "> "

+ ls
+ cat main.c
SLEEP=2 + cat Setup
SLEEP=7 + setup
+ ./main
+ edit main.c
+ setup
SLEEP=2 + edit main.c
+ setup
SLEEP=2 + ./main
+ 'setup --watch 2>&1 | sed s/^/[watch]:\ / & pid=$!'
SLEEP=0.5 +
+ touch main.c
SLEEP=0.5 +
+ touch hello.h
+
SLEEP=2 + ./main
+ sed \''s/"world"/"you"/'\' -i main.c
+
+ ./main
SLEEP=2 + kill '$pid'

printf "\r"

rm -f *includes *.o main
cat > main.c <<EOF
#include <stdio.h>

int main() {
  printf("Hello, world !\n");
}
EOF
