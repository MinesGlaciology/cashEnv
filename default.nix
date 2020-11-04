{
  stable ? import (builtins.fetchTarball {
             url = "https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz";
             # Hash obtained using `nix-prefetch-url --unpack <url>`
             sha256 = "0182ys095dfx02vl2a20j1hz92dx3mfgz2a6fhn31bqlp1wa8hlq";
           }) {}
}:

with stable;

stdenv.mkDerivation rec {
  name = "env" ;
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup; ln-s $env $out
  '';

  buildInputs = [ python36 git geos proj mkl hdf5
    (python36.buildEnv.override {
      ignoreCollisions = true;
      extraLibs = with python36Packages; [
        (numpy.override {blas = mkl ;})
	    h5py
        mkl-service
	    rasterio
        scipy
        matplotlib
        #basemap
        joblib
        tqdm
        pillow
        pyproj
    	tables
        pip
        notebook
        #jupyter
        #boto3
        cython
        pandas
        seaborn
        gdal
        click
      ];
     })
    ];


shellHook = ''
    alias pip="PIP_PREFIX='$(pwd)/_build/pip_packages' \pip"
    export PYTHONPATH="$(pwd)/_build/pip_packages/lib/python3.6/site-packages:$PYTHONPATH"
    export GEOS_DIR="/nix/store/7fq3pykybqcfzki9bqzhgypl1fhpf2xb-geos-3.6.3"
    unset SOURCE_DATE_EPOCH
'';}

