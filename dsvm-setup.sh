#!/usr/bin/env bash

# This script is intended as an initialization script used in azuredeploy.json
# See documentation here: https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux#template-deployment

# see abbreviated notes in README.md
# comments below:

adminUser=$1

WD=/home/$adminUser/notebooks

echo WD is $WD

if [ ! -d $WD ]; then
    echo $WD does not exist - aborting!!
    exit
else
    cd $WD
    echo "Working in $(pwd)"
fi

## now create the env...
condapath=/home/$adminUser/.conda/envs

if [ ! -d $condapath ]; then
    mkdir -p $condapath
fi

#### PYTORCH 1.0 ####

/anaconda/envs/py35/bin/conda create --name pytorch10 ipykernel conda

## update appropriate permissions
chown -R ${adminUser}:${adminUser} ${condapath}

# Install PyTorch 1.0 into environment with cuda 9.2 support as DSVM is on this now
/anaconda/envs/pytorch10/bin/python -m conda install torchvision pytorch-nightly cuda92 -c pytorch -y

# A custom CUDA build of PyTorch 1.0 from commit 8619230 to include usage of an old cmake
# This was built on a NC6 DSVM (Ubuntu VM with NVIDIA GPU/CUDA 9.2)
wget https://generalstore123.blob.core.windows.net/pytorchwheels/torch-1.0.0a0+8619230-cp35-cp35m-linux_x86_64.whl

sudo /anaconda/envs/pytorch10/bin/python -m pip install *.whl

## now install it as a kernel:
/anaconda/envs/pytorch10/bin/python -m ipykernel install --name pytorch_preview --display-name "Python 3.5 - PyTorch 1.0"

#### PYTORCH 0.3.1 ####

/anaconda/envs/py35/bin/conda create --name pytorch031 ipykernel conda

## update appropriate permissions
chown -R ${adminUser}:${adminUser} ${condapath}

# Install PyTorch 0.3.1 into environment with cuda 9.2 support as DSVM is on this now
wget https://generalstore123.blob.core.windows.net/pytorchwheels/torch-1.0.0a0+8619230-cp35-cp35m-linux_x86_64.whl

sudo /anaconda/envs/py35/bin/python -m pip install *.whl

# now install it as a kernel:
/anaconda/envs/pytorch031/bin/python -m ipykernel install --name pytorch_031 --display-name "Python 3.5 - PyTorch 0.3.1"

## update appropriate permissions
chown -R ${adminUser}:${adminUser} ${condapath}

echo "Done!"
