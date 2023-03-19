# starter-python

These steps explain how to set up a reproducible environment on any machine, that you can easily commit to a git repository, including the Python version and all the dependencies you add with pip, that can be used withing Visual Studio Code or a Jupyter Notebook.

## Prerequisites

* [Python 3](https://www.python.org/)
* [PyEnv](https://github.com/pyenv/pyenv#installation)
* [pip](https://pip.pypa.io/en/stable/installation/)
* [Poetry](https://python-poetry.org/docs/#installation)

## Installation

```bash
# Linux
curl -sSL https://install.python-poetry.org | python3 -
curl https://pyenv.run | bash
# PyEnv on Fish shell needs special steps, see https://github.com/pyenv/pyenv/issues/32#issuecomment-21019171


# Macos
brew install poetry
brew install pyenv

# Windows
# We recommend using WSL2 and Linux steps instead
# https://www.python.org/downloads/windows/
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | py -
# pyenv-win unnofficial fork
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"
```


## Unsing PyEnv

You can use PyEnv to install alternative Python versions without overtaking dyour main Python installation.
Using Poetry wouldn't help you with that.

```console
# List all available main Python3 versions
pyenv install --list | grep " 3\."
# Install a specific Python version, this can take a lot of time
pyenv install -v 3.11.1
# List installed versions on directory (you can delete from there directly)
ls ~ /.pyenv/versions
# Uninstall a version
pyenv uninstall -v X.X.X
# See installed, system, and active version
pyenv versions
# Activate a specific version
pyenv global 3.11.1
python --version
# Run tests
python -m test
# Restore original Python version
pyenv global system
python --version
```


## Using Virtual Environments

Virtual Environments is the basic way of isolating Python dependencies you install with `pip` for a specific folder in a project, so you don't have to globally install them for the whole machine, which could cause conflict between projects that require different versions of the same library.

It lacks several features to completely create a **reproducible environment**, so we encoure you to use **Poetry** and the other tools referenced here. These are the basic steps to use it anyway.

If you are using a specific Python version installed with `pyenv`, remember to activate that before creating or activating the virtual environment.

```bash
# Update pip
pip install --upgrade pip
# On Windows:
# python -m pip install --upgrade pip
# Install virtualenv in your machine
pip install --upgrade virtualenv
# Change to your desired project directory
cd project
# Create an environment directory "env"
python3 -m venv env
# Activate it with bash
source env/bin/activate
# Install your custom pip dependencies
...
# Exit the environment
exit
# Activate it with fish
. ./env/bin/activate.fish
# Do your things
...
# Exit
exit
```


## Using Poetry


### Create a new project

In the parent directory where you want your project, execute:
```bash
poetry new --name mypackage --src mydirectory
```

This will create this structure:
* mydirectory
  * src
    * mypackage

See more information [here](https://dev.to/bowmanjd/getting-started-with-python-poetry-3ica) and [here](https://dev.to/bowmanjd/build-command-line-tools-with-python-poetry-4mnc).

Edit `mydirectory/pyproject.toml` and among other things, change `python = "^3.9"` to specify the version of Python you want to use (at the moment of writting this, many Debian installations tops at Python 3.9 and not 3.10+).

#### Error executing pytest

If executing `poetry run pytest` you get an error, Poetry defiend the wrong version of `pytest`. Open `pyproject.toml` and substitute `pytest = "^5.2"` with, e.g., `pytest = "^6.0"`, and execute:

```bash
poetry add --dev pytest-xdist
```

More info [here](https://zhauniarovich.com/post/2020/2020-09-poetry-pytest/)

### Dependencies

#### Install existing dependencies

If you want to download and install already defined dependencies, for example if you just cloned this repository, use:
```bash
poetry install
```

#### Add a dependency

To add jupyterlab as a dependency
```bash
poetry add jupyterlab
```

Poetry will create a new virtual environment, include there the Python version of the project and other dependencies in it, as well as the `jupyterlab` package.

### Update version of pinned dependencies

```bash
poetry update
```

### Launch a shell in the virtual environment

```bash
poetry shell
```

Afterwards you can launch from it Visual Studio Code and use it to debug the same Python version your code is executing as.


### Run the program

```bash
poetry run python3 
```

## Organize your project for setuptools

Read this: https://click.palletsprojects.com/en/7.x/setuptools/#setuptools-integration
https://www.youtube.com/watch?v=kNke39OZ2k0

Set up the project for pip on `setup.py` file.

Load the virtual environment and load the project in pip as editable, it will sync code changes:

```bash
cd starter
. venv/bin/activate
pip --editable .

# Test execution
hola
```

You can now modify files under `./starter` and each execution of `hola` will use latest code.



## CLI commands and parameters using Click

Read this:  
* https://click.palletsprojects.com/en/7.x/quickstart/#basic-concepts-creating-a-command

```bash
poetry add click
```

## Tests with Mamba

Read this:
* https://mamba-framework.readthedocs.io/en/latest/what_mamba_is.html
* http://nestorsalceda.com/mamba/


```bash
poetry add mamba
```

## Jupyter Notebooks


```bash
# Add all dependencies the first time
poetry add jupiterlab

# Or download them if you cloned this repo
poetry install

# Launch Jupyter Lab locally
poetry run jupyter-lab
```

Your browser will launch the url [http://localhost:8888/lab](http://localhost:8888/lab)

Save the `.ipynb` file and add it to a GitHub repository. When browsing the repo, it will expose it with its web interface.
The last run of the calculation will be shown in it, even if the source data is not available.

### Additional dependencies

You can add additional dependencies, like:
```bash
poetry add numpy
poetry add matplotlib
poetry add tabulate
```

### VSCode + Jupyter + Poetry

You can use VSCode to edit the Jupyter Notebook directly without having to
start the server, and using the same Python environment and dependencies
managed using Poetry.

First, start Poetry virtual environment, and launch VSCode from there.
```bash
poetry shell
code .
```

Open the `.pyjnb` file on VSCode. Then on the top right of the VSCode window, you will see a mention of the Python version running. Click on it, and on the dropdown select the virtual environment with the Python version created using Poetry. Any dependencies that you install with Poetry will be available from within VSCode.
