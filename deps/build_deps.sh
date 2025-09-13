#!/bin/bash -x
set -e

MATHSATVERSION="5.6.11"

echo "Installing dependencies..."

# Build and install yices2
pushd .
if [[ ! -d yices2 ]]; then
  echo "  Installing Yices 2 from https://github.com/SRI-CSL/yices2 ..."
  git clone https://github.com/SRI-CSL/yices2.git
  git -C yices2 checkout c0a2609283b62592e6abc7be03c81957351b81b4
fi
cd yices2
autoconf
./configure
make -j$(nproc)
cd ..
echo "  Done!"
popd

### Build and install boolector
pushd .
if [[ ! -d boolector ]]; then
  echo "  Installing Boolector from https://github.com/Boolector/boolector ..."
  git clone https://github.com/Boolector/boolector.git
  git -C boolector checkout 43dae91c1070e5e2633e036ebd75ffb13fe261e1
fi
cd boolector
./contrib/setup-btor2tools.sh
./contrib/setup-cadical.sh
./configure.sh --only-cadical
cd build
make -j$(nproc)
cd ..
echo "  Done!"
popd

### Build and install mathsat5
pushd .
if [[ ! -d mathsat ]]; then
  echo "  Installing MathSAT v${MATHSATVERSION} from https://mathsat.fbk.eu/release/ ..."
  wget https://mathsat.fbk.eu/release/mathsat-${MATHSATVERSION}-linux-x86_64.tar.gz
  tar -xf mathsat-${MATHSATVERSION}-linux-x86_64.tar.gz
  rm -f mathsat-${MATHSATVERSION}-linux-x86_64.tar.gz
  mv mathsat-${MATHSATVERSION}-linux-x86_64 mathsat
  echo "  Done!"
fi
popd

### Build and install btor2tools
pushd .
if [[ ! -d btor2tools ]]; then
  echo "  Installing Btor2Tools from https://github.com/hwmcc/btor2tools ..."
  git clone https://github.com/hwmcc/btor2tools.git
  git -C btor2tools checkout a8c7178d550b5e47195905c03174c354edb3b057
fi
cd btor2tools
./configure.sh --static
cd build
make -j$(nproc)
cd ../..
echo "  Done!"
popd

echo "  Skipping installing Z3 (install manually if needed)"
### By default, z3 installation is disabled
# ### Build and install z3
# pushd .
# git clone https://github.com/Z3Prover/z3.git
# cd z3
# python scripts/mk_make.py --prefix . --staticlib
# cd build
# make -j$(nproc)
# cd ../..
# popd

## Build and install Yosys
### Build and install abc first (needed by yosys)
# pushd .
# echo "  Installing ABC from https://github.com/berkeley-abc/abc (needed by yosys) ..."
# git clone https://github.com/berkeley-abc/abc.git
# cd abc
# make -j$(nproc)
# export ABCEXTERNAL="$PWD/abc"
# echo "  Done!"
# popd
### Build and install yosys
# pushd .
# echo "  Installing Yosys (custom version) from https://github.com/aman-goel/yosys ..."
# git clone https://github.com/aman-goel/yosys.git
# cd yosys
# make config-gcc
# make -j$(nproc) PREFIX="$PWD"
# echo "  Done!"
# popd

RETURN="$?"
if [ "${RETURN}" != "0" ]; then
  echo "Installing dependencies failed."
  exit 1
fi
