# Python Dust

_Make your research reproducible effortless._

This is a simple repo for automatizing the setup of many projects.

## Why?

1. People interested in your research may not be able to code
2. Young users often don't know how to set up the dependencies to
   run your code
3. You want to use specific versions that are not available on the platform you're
   using (e.g. a server, Google Colab, Paperspace Gradient, etc.)
4. You want your specific setupalways ready at each Colab/Gradient startup
5. You want that other researchers can easily use your code

## TLDR

### `pdm` mode
* `./install 3.8.13`: install Python 3.8.13 in a subdirectory of your project
* `./dust add numpy scipy`: install numpy and scipy as dependencies
* `./dust run ipython`: run a command (`ipython`) in the environment (you can import numpy as scipy)
* `./dust shell`: run a shell with the python version set up (cannot import numpy and scipy, but faster)
* `./dust fly nvim`: run a command (`nvim`) with the python version set up (cannot import numpy and scipy, but faster)
* another user `./install`: install Python 3.8.13, numpy and scipy, all in your project directory

### `pip` mode
* `./install 3.8.13`: install Python 3.8.13 in a subdirectory of your project
* `./dust install numpy scipy`: install numpy and scipy as dependencies
* `./dust shell`: run a shell with the python version set up (you can import numpy and scipy)
* `./dust fly nvim`: run a command (`nvim`) with the python version set up (you can import numpy and scipy)
* another user `./install`: install Python 3.8.13, numpy and scipy, all in your project directory

## Tutorial

### Create a new project
It should work on any Unix-like system (Linux, Mac, etc.)

* Option 1 (only Github): select the `use this template` above
* Option 2: download the zip and uncompress it in your working directory:
  * with jar:
  ```shell
  curl https://codeload.github.com/00sapo/python-dust/zip/refs/heads/main | jar xv
  mv python-dust-main/* .
  rm -r python-dust-main
  ```
  * with unzip:
  ```shell
  curl https://codeload.github.com/00sapo/python-dust/zip/refs/heads/main -o python-dust.zip 
  unzip python-dust.zip -d .
  mv python-dust-main/* .
  rm -r python-dust-main python-dust.zip
  ```

### Install python
Now, let us install Python inside the `pyenv` directory. Simply run:
```
./install.sh 3.8.13
```
This will install python 3.8.13. Any version available from pyenv can be used.
 
During the installation, `pdm` will guide you through the setup of the project
metadata, You should always chose a python executable that is inside the
`pyenv` directory of your project, usually the number 0.

After the installation, a check is performed. If it should say "OK!".

### Develop
Now, let's add some dependency:
```
./dust add numpy
```

Finally, execute some python code:
```
./dust run python -c "import numpy as np; print(np.random.rand())"
```

It should print a random number.

### Distribute
Assume that now you distribute your code and want that other researchers use
it. You can just create a readme saying the following:

> ### Set-up to reproduce results
> Simply run: `./install.sh` from the repo root directory
>
> ### Install this repo to use it in your code
>
>     # with pdm
>     pdm add git+https://github.com/<user>/<project>
>     # with pip
>     pip install git+https://github.com/<user>/<project>
>

The `./install.sh` will install all the dependencies needed, including the
correct python version.

The same will work when moving your code to Google Colab or Paperspace
Gradient, that offer you some persistent directory but don't allow you to edit
your home file persistently (they will erase them when your environment is
killed).

## How does this work?

By using `python-dust`, you provides the user and yourself with an easy way to
setup python and its dependencies in the exact way as you work, so that your
code is always easily reproducible.

This approach leverages two wonderful tools:

* [`pdm`](https://github.com/pdm-project/pdm) which is able to efficiently
  solve python dependencies and can store them in a directory named
  `__pypackages__`, according to PEP 582, without even using virtualenvs. It's
  like `poetry`, but better.

* [`pyenv`](https://github.com/pyenv/pyenv) which can manage any python version
  on the earth (or almost)

`python-dust` simply allows to automatically download and install `pyenv` and
`pdm` inside your project. Nothing is installed outside of it. Moving the
project directory won't break anything. Removing the directory removes
everything.

This repo turns to be useful even for projects that must be run on remote
servers or platforms such as Google Colab and Paperspace Gradient, because it
allows you to install any python version on those servers in a persistent way
(you won't need to re-install everything every times the environment is
killed).

Finally, you are not obliged to use `pdm` if you do not want to.`python-dust`
correctly handles `pip` basic package manager. You won't need virtualenvs at
all, because all the python installation is relative to your project directory!


## Usage

Your interface to the Python installation is `./dust`. Internally, `dust`
setups `pyenv` and runs `pdm $@` or `pip $@`. In POSIX-like shells, `$@` means
_"all the received arguments"_. So, you can give any command to `pdm` or `pip`.
Some useful commands for `pdm` mode:

* `./dust init`
* `./dust add <package>`
* `./dust remove <package>`
* `./dust lock`
* `./dust sync --clean`

### `pdm` and `pip`

There are two modes of operating: one using `pdm` and one using `pip`.

While `pdm` is the default and recommended mode for now, you can optionally
turn it off by creating a file named `.dust-mode` and containing the string
`pip`, right before the installation. Then, all the command will be executed as
by putting them as argument to `pip`, e.g.: `./dust install numpy` will install
numpy in your project's python installation.

`dust` will keep a `requirements.txt` file always updated, both in `pdm` and
`pip` modes, so that other researchers can easily interact with your code.

Once you have run `./install.sh <your-python-version>`, you can switch from
`pdm` to `pip` or from `pip` to `pdm`: 

1. `pdm` to `pip`: `echo pip > .dust-mode; ./install.sh`
2. `pip` to `pdm`: `echo pdm > .dust-mode; ./install.sh`

Of course, when using `pip`, you can redistribute your code exactly in the same
way as in `pdm` mode, with the only exception that to make your code easily
usable by other programmers via `pip install git+https://<your repo>` you
should also create a `setup.py` file.

In future, if `pip` will use `pyproject.toml` file by default and will use a
continuously updated lock file, it should become the default.

### pyenv management and shells

You can also run any command in the `pyenv` by using the special command `fly`.
Using it, the arguments will be executed exactly like they are but inside a
shell where the project's `pyenv` is correctly set-up. For instance, at a
certain point of the development, you may want to have two python versions
installed and switch from one to the other:

```shell
# install a new python version
./dust fly pyenv install 3.9.1
# switch to the new python version
./dust fly pyenv local 3.9.1
# install dependencies for this new verions (in pdm mode)
./dust sync
# switch back to the previous one
./dust fly pyenv local 3.8.3
```

A similar effect is achieved by using `./dust run` in `pdm` mode, but `./dust
run` is slower, because it runs through `pdm` before of setting up `pyenv`. For
instance, the following commands all achieve the same effect:

```shell
./dust run bash # in pdm mode, slower
./dust fly bash # in pdm/pip mode, faster
```

As in the example above, you could spawn a shell which uses your project's
python installation. However, if your shell has some init file that conflicts
with `pyenv` (e.g. if you have `pyenv` installed in your system like me), the
above method doesn't work to spawn a shell. Instead you should use the provided
command: `./dust shell`, which spawns a new instance of your current shell.
Only fish and bash supported for now.

Note that when you want to run a python interpreter in `pdm` mode you should
still use `./dust run`, otherwise `__pypackages__` is not discovered.

### virtualenv vs `__pypackages__`

If you don't want to use PEP 582 (`__pypackages__` directory) and you still
prefer using virtualenvs, just create a directory named `.venv` before of
running `./install.sh`. `pdm` will use it to put the virtualenv and run code.
Note that if you switch to `pip` mode via `requirements.txt`, you
don't need virtualenvs at all, because all the python installation is relative
to this directory.

## Uninstall

To uninstall all the directories related to your project's Python installation,
run:

`sh uninstall.sh`

This script is not tested and is not ensured that it really deletes all the
directories created by `./install.sh`.

## Editors

In `pdm` mode, you should inform your editor that you're using the
`__pypackages__` directory to store the libraries. You can find some [helpful
info
here](https://pdm.fming.dev/latest/usage/pep582/#configure-ide-to-support-pep-582).

I have not tested `pip` mode enough to give advice about editor configurations.

## Why `pdm` and not `put your favorite tool here`?

1. While `pip` is improving and is now able to do backtracking, it doesn't
   ensure a lock file (requirements.txt) always up-to-date, nor the ability to
   convert your code to a standalone pypi module uploadable to pypi.org 
   effortless.
2. Conda is slow, not standard and covers only a few packages
3. poetry and Pipenv are slow
4. pip-tools reinvent the standard

## Develop

To test this project for development purpose, use the branch `develop` and test
using the command `./test-dust ./install.sh 3.8.13`

## Why `pdm` and not X?

1. While `pip` is improving and is now able to do backtracking, it doesn't
   ensure a lock file (requirements.txt) always up-to-date, nor the ability to
   convert your code to a standalone pypi module uploadable to pypi.org 
   effortless. Moreover, version constraints are hard to setup with `pip`
2. Conda is slow and covers only a few packages, poetry and Pipenv are
   slow, pip-tools reinvent the standard

## Possible improvements

* Switch of `pip`/`pdm` mode should be done based on some file
* Python version to be installed can be taken from `.python-version`
* In `pip` mode, provide an install and uninstall command which install packages
  and updates requirements.txt or explore the support for project.toml
* In `pdm` mode, keep requirements.txt updated
* add a guide to import the project's `requirements.txt` in another project
* Add automatic check of the installation in `install.sh`

# Credits

Federico Simonetta

https://federicosimonetta.eu.org
