{
  current ? import (builtins.fetchTarball {
             url = "https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz";
             sha256 = "0182ys095dfx02vl2a20j1hz92dx3mfgz2a6fhn31bqlp1wa8hlq";
             }) {}
}:

with current;

stdenv.mkDerivation rec {
  name = "env" ;
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln-s $env $out
  '';

  buildInputs = [ python36 git geos proj curl wget
    (python36.buildEnv.override {
      ignoreCollisions = true;
      extraLibs = with python36Packages; [
        numpy
        numba
        tensorflow-tensorboard
        tensorflow
        Keras
        scipy
        scikitimage
        rasterio
        coverage
        matplotlib
        joblib
        tqdm
        pillow
        pyproj
        pip
        notebook
        boto3
        cython
        pandas
        gdal
        click
      ];
     })
    ];

shellHook = ''
    alias pip="PIP_PREFIX='$(pwd)/_build/pip_packages' \pip"
    export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.6/site-packages:$PYTHONPATH"
    unset SOURCE_DATE_EPOCH
'';}
