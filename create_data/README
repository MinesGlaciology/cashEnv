Installation
------------

1. Run `nix-shell` in this directory using the provided default.nix script
2. Run: pip install git+https://github.com/espg/georasters.git@subsetFix

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
cd april20
python nsidc-download_IODEM3.2012april20.py
mkdir xml
mv *tif.xml xml
```

...repeat the same for april21:

```
cd april21
python nsidc-download_IODEM3.2012april21.py
mkdir xml
mv *tif.xml xml
```

Tile the dataset
----------------

After the download has finished, create the output directory and
run the tiling code:

`mkdir output`

`python Tile_April20i_21.py`

Do a sanity check
-----------------

1. Run `ls -1 output | wc -l`
2. Verify that the number of tiles is 265,453
3. Run `ls output | head`
4. Verify that the first entries match the expected hashes:

...

Congrats! You've downloaded and created the tile dataset.

Notes
-----

There is a second nix file, 'prov.nix', that is pinned to the specific
version of packages used at the time of this README creation. It should
work without errors in the future regardless of library updates. It can
be accessed by running nix-shell with it as the argument:

`nix-shell prov.nix`

Cut instructions that aren't needed (I think)
---------------------------------------------

Clean up
--------

Combine the datasets:

```
mkdir all_tiles_april
mv april20/output/* all_tiles_april
mv april21/output/* all_tiles_april
```

