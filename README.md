# starter-python


## Prerequisites

* Python 3
* [Poetry](https://python-poetry.org/docs/#installation)

```bash
# Linux
curl -sSL https://install.python-poetry.org | python3 -

# Macos
brew install poetry

# Windows
(Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | py -
```


## Using Poetry


### Create a new project

In the project directory, run:
```bash
poetry init
```

Among other things, it will ask you for the Python version to use.


### Add a dependency

To add jupyterlab as a dependency
```bash
poetry add jupyterlab
```

Poetry will create a new virtual environment, include there the Python version of the project and other dependencies in it, as well as the `jupyterlab` package.


### Install existing dependencies

If you want to download and install already defined dependencies, for example if you just cloned this repository, use:
```bash
poetry install
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
