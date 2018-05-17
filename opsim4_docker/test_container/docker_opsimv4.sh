#!/bin/bash
# Run directory
run_dir=$HOME/test_container/opsimv4_data/run_dir
# Configuration directory
config_dir=$HOME/test_container/opsimv4_data/config_dir

docker run -it --rm --name "$1" \
          -v ${run_dir}:/home/opsim/run_local \
          -v ${config_dir}:/home/opsim/other-configs \
          -v $HOME/.config:/home/opsim/.config \
          -e OPSIM_HOSTNAME=opsim-docker \
          -p 8888:8888 \
          oboberg/opsim4_fbs_py3:180502
