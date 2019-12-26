```
    _/      _/                                _/  _/
   _/_/  _/_/    _/_/_/  _/_/_/    _/_/_/        _/  _/
  _/  _/  _/  _/    _/  _/    _/  _/    _/  _/  _/_/
 _/      _/  _/    _/  _/    _/  _/    _/  _/  _/  _/
_/      _/    _/_/_/  _/_/_/    _/    _/  _/  _/    _/
                     _/
                    _/
```

[![Build Status](https://travis-ci.org/am2222/mapnik-windows.svg?branch=master)](https://travis-ci.org/am2222/mapnik-windows)

[![codecov](https://codecov.io/gh/mapnik/mapnik/branch/master/graph/badge.svg)](https://codecov.io/gh/mapnik/mapnik)

Mapnik is an open source toolkit for developing mapping applications. At the core is a C++ shared library providing algorithms and patterns for spatial data access and visualization.

Mapnik is basically a collection of geographic objects like maps, layers, datasources, features, and geometries. The library doesn't rely on any OS specific "windowing systems" and it can be deployed to any server environment. It is intended to play fair in a multi-threaded environment and is aimed primarily, but not exclusively, at web-based development.

For further information see [http://mapnik.org](http://mapnik.org) and also our [wiki documentation](https://github.com/mapnik/mapnik/wiki).

# Installation on windows

We use vcpkg to install demendenices. some dependencies must be built using `icu` as follows:
```
vcpkg install boost-locale[icu] boost-regex[icu] boost --triplet x64-windows --recurse
```
Currently there is a bug in `boost:Spirit` for boost version 1.71 which is fixed in version 1.72 and when it is updated to in vcpkge it works fine with this fork.
I'll try to keep this fork uptodate. 

# Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](https://github.com/mapnik/mapnik/blob/master/CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

# License

Mapnik software is free and is released under the LGPL v2.1 ([GNU Lesser General Public License, version 2.1](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html)). Please see [COPYING](https://github.com/mapnik/mapnik/blob/master/COPYING) for more information.
Based on work originally done by [roelandschoukens](https://github.com/roelandschoukens/mapnik/tree/mapnik-win)