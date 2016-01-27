ps aux | grep 'wireconf' | awk '{system("kill -9 " $2)}'
rmmod -w ~/qomet_bin/ipfw_mod.ko