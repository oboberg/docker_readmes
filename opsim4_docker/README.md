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

### Docker `run` option 2.
Same as above but mounting local repo directory in container for development.
 ~~~
 docker run -it --rm --name container_name \
           -v ${run_dir}:/home/opsim/run_local \
           -v ${config_dir}:/home/opsim/other-configs \
           -v /Users/my_name/lsst/opsimv4_data/fbs_repos:/home/opsim/dev_repos \
           -v $HOME/.config:/home/opsim/.config \
           -e OPSIM_HOSTNAME=opsim-docker \
           -e DISPLAY=HOST_IP:0 \
           -p 8888:8888 \
           oboberg/opsim4_fbs_py3:180502
 ~~~

Doing this will allow you to locally edit code in `/Users/my_name/lsst/opsimv4_data/fbs_repos` and have it be accessible to the container. You will have to `eups` declare, setup, and scons the packages as you normally would.

### Docker `run` option 3.
The docker image comes with about 40 nights of sky brightness data. If you have a complete set that you would like to mount in the container just add the following.

~~~
docker run --name "$1" \
        -v ${run_dir}:/home/opsim/run_local \
        -v ${config_dir}:/home/opsim/other-configs \
        -v ${sky_brightness_data_dir}:/home/opsim/repos/sims_skybrightness_pre/data \
        -v $HOME/.config:/home/opsim/.config \
        -e OPSIM_HOSTNAME=opsim-docker \
        -e DISPLAY=HOST_IP:0 \
        -p 8888:8888 \
        oboberg/opsim4_fbs_py3:180502
~~~
You will need to have `${sky_brightness_data_dir}` set in your `.bash_profile`.

### Docker `run` option 4.
If you dont want to add various paths and variables to your `.bash_profile`, you can
also just define everything in a script. Let's say it is called `docker_opsimv4.sh`

~~~
#!/bin/bash
# Run directory
run_dir=$HOME/opsimv4_data/run_dir
# Configuration directory
config_dir=$HOME/opsimv4_data/config_dir
# Sky Brightness data directory
#sky_brightness_data_dir=$HOME/sims_skybrightness_pre/data
# IP address for machine
host_ip=127.0.0.1

docker run -it --rm --name "$1" \
          -v ${run_dir}:/home/opsim/run_local \
          -v ${config_dir}:/home/opsim/other-configs \
          -v ${sky_brightness_data_dir}:/home/opsim/repos/sims_skybrightness_pre/data \
          -v $HOME/.config:/home/opsim/.config \
          -e OPSIM_HOSTNAME=${host_name} \
          -e DISPLAY=${host_ip}:0 \
          -p 8899:8888 \
          oboberg/opsim4_fbs_py3:180502
~~~

Now just start the container with `./docker_opsimv4.sh my_container_name`.


# Real working example (bash script method)

I made a fresh directory in `$HOME` called `test_container`. Here are the contents assuming it is my present working directory.
~~~
$ ls
$ docker_opsimv4.sh  opsimv4_data/
$ ls opsimv4_data/
config_dir/ run_dir/
$ ls opsimv4_data/run_dir/
log/    output/
~~~
~~~
$ more docker_opsimv4.sh

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
~~~

Run command:
~~~
$ /docker_opsimv4.sh my_opsim_test
~~~
After running this command you will see output setting up the container environment.
Really just running scons and setup. If a scons test fails it is ok, we are fixing that.

When it is done your command promt should now look something like this:
~~~
opsim@10e581808be4 ~]$
~~~
Let's do an `ls` just to see what is there
~~~
[opsim@10e581808be4 ~]$ ls
dds  default_configs  other-configs  pull_and_config.sh  pull_repos.sh  repos  run_local  sky_brightness_data  stack  startup_fbs.sh
~~~
Go ahead an run the `pull_repos.sh` script. This will get all of the container repos up to date.
~~~
[opsim@10e581808be4 ~]$ ./pull_repos.sh
~~~
Again you will see pull commands and scons ouput.

The next step is to setup the tracking database for the opsim runs. This is done simply with this command.
~~~
[opsim@10e581808be4 ~]$ manage_db --save-dir=/home/opsim/run_local/output
[opsim@10e581808be4 ~]$ ls run_local/output/
opsim-docker_sessions.db
~~~
You can see that the root name of the sessions db is the `OPSIM_HOSTNAME` set in
the bash script.
