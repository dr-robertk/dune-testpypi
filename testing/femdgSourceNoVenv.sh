#!/bin/bash

# install missing python packages in users local environment
# Note: wheel and setuptools may not be required
# dune-common dependencies
pip install -U jinja2 wheel setuptools mpi4py numpy
# dune-fem dependencies
pip install -U scipy fenics-ufl matplotlib

cd ../repos

FLAGS="-O3 -DNDEBUG"

echo "\
DUNEPATH=`pwd`
BUILDDIR=build-cmake
CMAKE_FLAGS=\"-DCMAKE_CXX_FLAGS=\\\"$FLAGS\\\"  \\
 -DALLOW_CXXFLAGS_OVERWRITE=ON \\
 -DDUNE_PYTHON_USE_VENV=OFF \\
 -DDISABLE_DOCUMENTATION=TRUE \\
 -DCMAKE_DISABLE_FIND_PACKAGE_Vc=TRUE \\
 -DCMAKE_DISABLE_FIND_PACKAGE_LATEX=TRUE\" " > femdg-config.opts

#-DCMAKE_LD_FLAGS=\\\"$PY_LDFLAGS\\\" \\

dune-common/bin/dunecontrol --opts=femdg-config.opts --module=dune-fem-dg all
echo "Done with dune-controlling!"

# source config opts for this to work with python
echo "Sourcing config.opts"
source femdg-config.opts

echo "Setting PYTHONPATH"
DUNE_PATH=${PWD}
# set python path variable
MODULES=$(./dune-common/bin/dunecontrol --print)
for MOD in $MODULES; do
  if test -f "$DUNE_PATH/${MOD}/build-cmake/set-dune-pythonpath"; then
    . $DUNE_PATH/${MOD}/build-cmake/set-dune-pythonpath
  else
    export PYTHONPATH=$PYTHONPATH:$DUNE_PATH/${MOD}/build-cmake/python
  fi
done
echo "PYTHONPATH = $PYTHONPATH"

echo "Running euler script"
cd dune-fem-dg/pydemo/euler
python testdg.py

cd $DUNE_PATH

echo "Running advection script"
cd dune-fem-dg/pydemo/camc-paper
mpirun -np 2 --oversubscribe python advection.py 2

cd $DUNE_PATH
echo "Running fem-tutorial script"
python -m dune.fem
cd fem_tutorial

mpirun -np 2 --oversubscribe python laplace-adaptive.py
