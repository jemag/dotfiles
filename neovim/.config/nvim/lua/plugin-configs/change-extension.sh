#!/bin/bash
for f in *.vim; do
    mv -- "$f" "${f%.vim}.lua"
done
