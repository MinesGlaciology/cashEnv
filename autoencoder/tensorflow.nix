{
  current ? import (builtins.fetchTarball {
             url = "https://github.com/NixOS/nixpkgs/archive/19.09.tar.gz";
             sha256 = "0mhqhq21y5vrr1f30qd2bvydv4bbbslvyzclhw0kdxmkgg3z4c92";
             }) {}
}:

with current;

stdenv.mkDerivation rec {
  name = "env" ;
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln-s $env $out
  '';

  buildInputs = [ python37 git geos proj curl wget
    (python37.buildEnv.override {
      ignoreCollisions = true;
      extraLibs = with python37Packages; [
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
    export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.7/site-packages:$PYTHONPATH"
    unset SOURCE_DATE_EPOCH
'';}
