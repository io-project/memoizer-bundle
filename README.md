memoizer-bundle
===============

Jedno repozytorium z całym kodem

Jak zbudować/uruchomić
----------------------
```bash
# Ściągnąć kod
git clone git@github.com:io-project/memoizer-bundle.git
cd memoizer-bundle/
git submodule update --init .
cd ..
# Zbudować
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../install ../memoizer-bundle/
make
make install
# Uruchomić
cd ../install
bin/memoizer-gui 
```

Wymagania
---------
* Java 1.7
* Maven
* CMake>=2.8.11
* Qt 5.2
