USER="root"
HOST=$1
COMMAND=$2
ASYNC=$3

ssh $ASYNC -o StrictHostKeyChecking=no $USER@$HOST $COMMAND