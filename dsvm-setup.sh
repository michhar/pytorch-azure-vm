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

/anaconda/envs/py35/bin/conda create --name pytorch1.0

# Install PyTorch 1.0 into environment with cuda 9.2 support as DSVM is on this now
/anaconda/envs/pytorch1.0/conda install pytorch_nightly cuda92 -c pytorch

## now install it as a kernel:
$condapath/pytorch1.0/bin/python -m ipykernel install --name pytorch1.0 --display-name "Python (PyTorch 1.0)"

## update appropriate permissions
chown -R ${adminUser}:${adminUser} ${condapath}

echo "Done!"
