# starter-python

These steps explain how to set up a reproducible environment on any machine, that you can easily commit to a git repository, including the Python version and all the dependencies you add with pip, that can be used withing Visual Studio Code or a Jupyter Notebook.

## Prerequisites

* (Linux) Optional utilities packages
* [Python 3](https://www.python.org/)
* [pip](https://pip.pypa.io/en/stable/installation/)
* [pipx](https://github.com/pypa/pipx)
* [PyEnv](https://github.com/pyenv/pyenv#installation)
* [Poetry](https://python-poetry.org/docs/#installation)

## Installation

If using **Linux** you may need to install some general utilities packages:
```console
# You have to reinstall a Python version with PyEnv if you add any of these to be picked up
sudo apt install libffi-dev # To avoid ctypes error in PyTorch
sudo apt install liblzma-dev # To use lz compression in Python
sudo apt install libbz2-dev # To use bz2 compression in Python
sudo apt install python3-tk # To use TK GUI with Python
sudo apt install patchelf # For nuitka Python compiler to generate Linux binaries
```

To install main prerequisites:
```console
# See pipx installation instructions at: https://github.com/pypa/pipx?tab=readme-ov-file#install-pipx

# Linux
## Pyenv
curl https://pyenv.run | bash
### PyEnv on Fish shell:
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
## Poetry
curl -sSL https://install.python-poetry.org | python3 -

# Macos
brew install pyenv
brew install poetry


# Windows
# We recommend using WSL2 and Linux steps instead, but following are some Windows specifics
# https://www.python.org/downloads/windows/
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | py -
# pyenv-win unnofficial fork
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"
```

## Using pipx

You can use pipx to install Python dependencies the same way you would use pip, but each installation will create its own virtual environment. So when you are required to install a system wide tool like Poetry, you know the version of its dependencies will not clash with another tool that requires different versions for some of the same dependencies.

```
# Example alternative installation of Poerty
pipx install poetry
```

## Unsing PyEnv

You can use PyEnv to install alternative Python versions without overtaking your main Python installation.
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
python3 --version
# Run tests
python3 -m test
# Restore original Python version
pyenv global system
python3 --version
```

To use it on a project, we set a `.python-version` file on the root directory that automatically triggers pyenv to switch to that version when navigation to that directory.

```
# Specify that this directory should execute Python 3.11.1
pyenv local 3.11.1
# When navigating to the directory and back, the version automatically changes
cd ..
python3 -V
# shows main Python version
cd -
python3 -V
# shows 3.11.1
```

You should choose to commit the `.python-version` file to your project insted of ignoring it, contrary to what the default `.gitignore` file created by GitHub does.


## Using Virtual Environments and pip

Virtual Environments is the basic way of isolating Python dependencies you install with `pip` for a specific folder in a project, so you don't have to globally install them for the whole machine, which could cause conflict between projects that require different versions of the same library.

It lacks an importnat features to completely create a **reproducible environment**, because even if you use `pip freeze` to generate a list of your installed packages including their specific version, versions for transitive dependencies are not recorded (those packages that are pedendencies from the ones you installed). So when you later reinstall the packages you may end up with difference source for those transitive dependencies.

That's why we encoure you to use **Poetry** to manage both _virtual environments_ and track _dependencies_.

Anyways here are the basics on how to use _virtual environments_. Make sure you activate the right Python version with `pyenv` before you create the virtual environment, so it's included in it:

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
# Activate it with fish
. ./env/bin/activate.fish
# Activate it on Windows:
# env\Scripts\activate

# Install your custom pip dependencies
...
# Exit the environment
exit
```


## Using Poetry

### Prerequisites

Make sure you specify and activate a specific Python version using `pyenv` as explaining at the beginning of this document.

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

To configure Poetry to run using the PyEnv configured Python version for this project, execute:
```bash
poetry config virtualenvs.prefer-active-python true --local
```

#### Error executing pytest

If executing `poetry run pytest` you get an error, Poetry defiend the wrong version of `pytest`. Open `pyproject.toml` and substitute `pytest = "^5.2"` with, e.g., `pytest = "^6.0"`, and execute:

```bash
poetry add --dev pytest-xdist
```

More info [here](https://zhauniarovich.com/post/2020/2020-09-poetry-pytest/)

### Dependencies

#### Install existing dependencies

If you want to download and install already defined dependencies, for example, if you just cloned this repository, use:
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

## Develop with Visual Studio Code

Add some dependencies for development, [flake8](https://flake8.pycqa.org/en/latest/) for linting, [mypy](https://mypy-lang.org/) for static typing, [black](https://black.readthedocs.io/en/stable/) for formatting.

```bash
poetry add -D flake8 mypy black
```

Run VSCode in Poetry's virtual environment with access to all installed dependencies

```bash
poetry run code .
## or
poetry shell
code .
```

Click on the bottom right corner of VSCode where it says "Python", and select the virtual environment that has your project name in it, including "Poetry" to its right.

More information here:
* https://www.pythoncheatsheet.org/blog/python-projects-with-poetry-and-vscode-part-1
* https://www.pythoncheatsheet.org/blog/python-projects-with-poetry-and-vscode-part-2
* https://py-vscode.readthedocs.io/en/latest/files/linting.html

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
poetry add jupyterlab

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
