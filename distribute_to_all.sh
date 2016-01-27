FILENAME=$1

cat all-nodes.conf | awk '{system("./distribute.sh '${FILENAME}' " $1)}'