with import <nixpkgs> {};

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
        geopandas
        pillow
        pyproj
        pip
        jupyter
        boto3
        cython
        geopandas
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
