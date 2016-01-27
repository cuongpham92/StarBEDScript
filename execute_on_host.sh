USERNAME="evaluser"
TARGET_HOST=$1
COMMAND=$2

ssh -f -o StrictHostKeyChecking=no $USERNAME@$TARGET_HOST "$COMMAND"