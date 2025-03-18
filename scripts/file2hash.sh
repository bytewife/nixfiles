#!/bin/bash

set -eu

if [ ! -e "$1" ]; then
	echo "Error: Argument 1 is not a valid path!"
	exit
fi
if [ ! -d "$2" ]; then
	echo "Error: Argument 2 is not a valid directory (for the hash symlink)!"
	exit
fi
set -x
originalPath=$(realpath "$1")
filename=$(basename "$1" | sed 's| |_|g')
extension=$(echo "$filename" | awk -F. '{print $NF}')
filename=$(basename "${filename}" ".${extension}")
# Note: Set this prefix in nix config
hashDir="$2"
contentHash=$(sha256sum "$originalPath" | awk '{print $1}')
# Move this to an environment variable to sync with the caddy template html.
delimiter='---'
contentHash="${filename}${delimiter}${contentHash}"
hashedPath="${hashDir%/}/${contentHash}.${extension}"

# Add to table
psql -U ivy -d file2hash -c "INSERT INTO main (originalPath, contentHash, hashedPath) VALUES ('$originalPath', '$contentHash', '$hashedPath');"
# psql -U ivy -d file2hash -c "INSERT INTO main (originalPath, contentHash, hashedPath) VALUES (a, b, c);"

ln -s "${originalPath}" "${hashedPath}"
set +x
echo "https://wife.rip/f/${contentHash}"

# Next, create a script that periodically checks if deletionTime has passed.
# TODO: move this to an automated script and delete them.
to_delete=$(psql -U ivy -d file2hash -c  "SELECT * FROM main WHERE deletiontime < NOW();")

