{
  current ? import (builtins.fetchTarball {
             url = "https://github.com/NixOS/nixpkgs/archive/20.09.tar.gz";
             sha256 = "1wg61h4gndm3vcprdcg7rc4s1v3jkm5xd7lw8r2f67w502y94gcy";
             }) {}
}:

with current;

stdenv.mkDerivation rec {
  name = "env" ;
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln-s $env $out
  '';

  buildInputs = [ python38 git geos proj curl wget
    (python38.buildEnv.override {
      ignoreCollisions = true;
      extraLibs = with python38Packages; [
        numpy
        numba
        ipywidgets
        #tensorflow
        #keras
        scikitlearn
        pytorch
        docopt
        Rtree
        scipy
        fiona
        scikitimage
        affine
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
    export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.8/site-packages:$PYTHONPATH"
    unset SOURCE_DATE_EPOCH
'';}
