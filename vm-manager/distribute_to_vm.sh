USER="root"
TARGET_FILE=$1
TARGET_HOST=$2
TARGET_PATH=$3

scp -r $TARGET_FILE $USER@$TARGET_HOST:$TARGET_PATH