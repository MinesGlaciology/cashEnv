Installation
=============

1. Run `nix-shell` in this directory using the provided default.nix script
2. Run: pip install git+https://github.com/espg/georasters.git@subsetFix

Phase one-- Generating the raster database
==========================================

Downloading the source data from NSIDC:
--------------------------------------

1. First, create an EarthData login if you don't already have one:

https://urs.earthdata.nasa.gov/users/new

2. Save your credentials to a .netrc file in your home directory:

```
echo "machine urs.earthdata.nasa.gov login <uid> password <password>" >> ~/.netrc

chmod 0600 ~/.netrc
```

where <uid> is your Earthdata Login username and <password> is your Earthdata Login password. 
Do not include the brackets <>.

Further directions are available for this step here:

https://nsidc.org/support/faq/what-options-are-available-bulk-downloading-data-https-earthdata-login-enabled

3. Run the provided NSIDC download scripts, and move the xml files:

```
cd create_data/april20
python nsidc-download_IODEM3.2012april20.py
```

...repeat the same for april21:

```
cd ../april21
python nsidc-download_IODEM3.2012april21.py
cd ..
```

Tile the dataset
----------------

After the download has finished, create the output directory and
run the tiling code:

`mkdir output`

`python Tile_April20_21.py`

Do a sanity check
-----------------

1. Run `ls -1 output | wc -l`
2. Verify that the number of tiles is 316,968
3. Run `ls output | head`
4. Verify that the first entries match the expected hashes:

0000219354bc7855415c0c3535b03d48755af162ebef907cbd0916241784984b.tif
00004cdb5ede3b05f3611ce8377aa1b15820827ed045c3b9450fcf2907b9bfba.tif
00004ea57a242c5a82ef77f5d54f815f0cd67428fa6785bc5ed93a324c2a8fd6.tif
00004f4afeda7821095d46500a14ab54564d447ddf21e6baf7dd36ad57d038d3.tif
00007cf6544d5449009cc6c6fe62ce523b2c84547d4a56d2127a942ff2c062ab.tif
000081f03f7f83c48e9dbdf1a9e0da25fafd7ed167d5a2dd8e23e1eb224d4d5c.tif
00009cc5a9e9ebdb1c3a49fd9ef99623b2e24fda79daf4475f836791cc7a9fb3.tif
00009e85fbf07ab215fc90cd3d0bb8c9940f13e821c77e399ed6cc45c8c84bfa.tif
000133ec5fae7562af0ea63d66db261c61b8e1ea7b0ac2fd0165cd0f7fa186cb.tif
00017a1e4b4ae6e6f33a14719a32cfdd7cc1d9999417139744298563b00cef07.tif
...

Congrats! You've downloaded and created the tile dataset. 

Create the 'raw' waveforms
--------------------------

`python April_wfs.py`

This will create an hdf5 database ('./April_wfs.h5') of the tiled raster
data. Move all of the data that we just created to a more central place:

```
mv output ../data/tiles
mv April_wfs.h5 ../data/
```

Phase two: Training the Model
=============================

We'll need to enter a different environment to load tensorflow. First, exit
the existing nix-shell (which will drop you to same directory you initiated
the shell in). Next, move to the next relevant folder for this section, and
build the tensorflow environment; assuming that you're in the top level
folder:

```
cd ../autoencoder
nix-shell tensorflow.nix
```

Option A: Training the Model
----------------------------

Training the tensorflow model is more involved; there is output to monitor for
convergence, which is likely to vary depending on the system used. Since the
process is stochastic, slightly different model weights are expected, so
testing that the model works is recommended. This training and testing is run
in an interactive jupyter notebook; it is also possible to skip training of the
model and simply load the pre-trained model that we used. A separate ipython
notebook (load_ref.ipynb) is included with instructions for that as well.

First, start the jupyter notebook server, then, follow the instructions in the
'autoencoder_denoise.ipynb':

`jupyter notebook`


