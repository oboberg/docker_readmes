# Quick start for using opsimv4 with Docker

### Make the following directories to be mounted in the container
You can change these to whatever works best on your system.
These will be the directories that save the output from opsim:
 - log files
 - opsim databases
 - opsim configurations
~~~
mkdir $HOME/opsimv4_data
mkdir $HOME/opsimv4_data/run_dir
mkdir $HOME/opsimv4_data/run_dir/log
mkdir $HOME/opsimv4_data/run_dir/output
mkdir $HOME/opsimv4_data/config_dir
~~~

### You can add the following lines to your `.bash_profile`, but it is not required.
~~~
 # Export things for opsim docker run
 export run_dir="$HOME/opsimv4_data/run_dir"
 export config_dir="$HOME/opsimv4_data/config_dir"
~~~

### Docker `run` option 1.
Assuming you added the above lines to your `.bash_profile`.
`HOST_IP` will need to be changed to your IP address if you want to use the
configuration GUI. `container_name` can also be whatever you want it to be.
~~~
docker run -it --rm --name container_name \
          -v ${run_dir}:/home/opsim/run_local \
          -v ${config_dir}:/home/opsim/other-configs \
          -v $HOME/.config:/home/opsim/.config \
          -e OPSIM_HOSTNAME=opsim-docker \
          -e DISPLAY=HOST_IP:0 \
          -p 8888:8888 \
          oboberg/opsim4_fbs_py3:180502
~~~

Breakdown of command:
 - `docker run` run a docker container
 - `-it` Give me an an interactive shell in the container
 - `--rm` remove the container after it is stopped
 - `--name` name of the container. Has to be unique.
 - `-v ${run_dir}:/home/opsim/run_local` mounts the local `run_dir` into the container at the path `/home/opsim/run_local`.

 - `-v ${config_dir}:/home/opsim/other-configs` mounts the local `config_dir` into the container at the path `/home/opsim/other-configs`.

 - `-v $HOME/.config:/home/opsim/.config` mounts local `.config` into the container_name at the path `/home/opsim/.config`.

 - `-e OPSIM_HOSTNAME=opsim-docker` sets the `OPSIM_HOSTNAME` environment variable inside the container. This sets the name of the run tracking database and other
 output files. You can change this to whatever name you like.

 - `-e DISPLAY=HOST_IP:0 ` sets the `DISPLAY` environment variable inside the container. Use `ifconfig | grep inet` to get your IP address, and replace `HOST_IP` with that number. You can also remove this line if you dont plan on
 using the `opsim4_config_gui`.

 - `-p 8888:8888` this is read as `port on host:port on container`. Meaning port `8888` in the container will be fed to port `8888` on your local host. This allows you to use things like `jupyter lab`.

 - `oboberg/opsim4_fbs_py3:180502` this is the name of the docker image. If you dont already have it from doing `docker pull oboberg/opsim4_fbs_py3:180502`, it will automatically be pulled.
