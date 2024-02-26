#!/bin/bash
set -e

if [[ $(uname) == "Linux" ]]; then
    if [  -n "$(uname -a | grep Ubuntu)" ]; then
        sudo apt update
        sudo apt install -y git autoconf gperf libgmp3-dev curl cmake
        sudo apt install -y build-essential bison flex libreadline-dev gawk tcl-dev libffi-dev git graphviz xdot pkg-config python3 libboost-system-dev libboost-python-dev libboost-filesystem-dev zlib1g-dev
    else
        sudo yum install -y git autoconf gperf gmp-devel curl cmake glibc-static
        sudo yum install -y bison flex readline-devel gawk tcl-devel libffi-devel graphviz python3 boost-devel boost-python-devel zlib-devel
    fi
else
    echo "Currently, installing on Linux (Ubuntu/Centos/AL2) is only supported."
    exit 1
fi


# Build and install dependencies
pushd .
cd deps
./build_deps.sh
cd ..
popd

# Build AVR source
pushd .
cd src
make -j$(nproc) all
cd ..
popd

# Test AVR

python avr.py -n test_vmt examples/vmt/counter.smt2
python avr.py -n test_vmt2 examples/vmt/simple.c.vmt
python avr.py -n test_btor2 examples/btor2/counter.btor2
#python avr.py -n test_verilog examples/verilog/counter.v        # requires yosys
#python avr.py -n test_verilog_aig examples/verilog/counter.v --aig  # requires yosys

RETURN="$?"
if [ "${RETURN}" != "0" ]; then
  echo "Installing dependencies failed."
  exit 1
fi
