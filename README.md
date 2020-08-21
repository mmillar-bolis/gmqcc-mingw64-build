# gmqcc MINGW64 Builds
A small project to compile and prepare the gmqcc compiler for Windows.

[Download Gmqcc Builds Here!](https://github.com/mmillar-bolis/gmqcc-mingw64-build/releases) Or build it yourself by following the below instructions.

## Compile Instructions
Use [MSys2](https://www.msys2.org/) (Or [go here](http://repo.msys2.org/distrib/x86_64/) for just the base package), run through setup and then invoke a MinGW64 shell. Install the following packages:

```
autoconf
automake
gcc
gmp-devel
libtool
make
mingw-w64-x86_64-gcc
mingw-w64-x86_64-gmp
```

For those new to Msys2 and pacman, instead try the following commands:

```
pacman --sync --refresh
pacman --sync --sysupgrade --needed
pacman --sync --needed autoconf automake gcc gmp-devel libtool make mingw-w64-x86_64-{gcc,gmp}
```

From there, just cd into this directory and run `make all`. Additionally, run `make bundle` to produce a bin directory with the freshly compiled exes and their library dependencies.

## TODO
- Convert man docs from man to ps and then to either chm or pdf
