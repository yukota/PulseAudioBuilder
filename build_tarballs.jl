# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "PulseAudio"
version = v"13.0.0-dev"

# Collection of sources required to build PulseAudio
sources = [
    "http://anongit.freedesktop.org/git/pulseaudio/pulseaudio.git" =>
    "a5f25af0434bd703c502c230f5a5ff0238b6b8a3",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd pulseaudio/
./autogen.sh LDFLAGS=-L$prefix/lib CFLAGS=-I$prefix/include --prefix=$prefix --host=$target --without-caps --disable-manpages                                                                                
make
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libpulse", :libpulse),
    ExecutableProduct(prefix, "pasuspender", :pasuspender),
    ExecutableProduct(prefix, "pacmd", :pacmd),
    ExecutableProduct(prefix, "pactl", :pactl),
    ExecutableProduct(prefix, "pulseaudio", :pulseaudio),
    LibraryProduct(prefix, "libpulse-simple", Symbol("libpulse-simple")),
    ExecutableProduct(prefix, "pacat", :pacat)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/yukota/libsndfileBuilder/releases/download/v1.0.28-0/build_libsndfile.v1.0.28.jl",
    "https://github.com/yukota/libatomic_opsBuilder/releases/download/v7.6.8-0/build_libatomic_ops.v7.6.8.jl",
    "https://github.com/yukota/SpeexDSPBuilder/releases/download/v1.2.0-rc3-0/build_SpeexDSP.v1.2.0-rc3.jl",
    "https://github.com/yukota/LibtoolBuilder/releases/download/v2.4.6-1/build_Libtool.v2.4.6.jl",
    "https://github.com/yukota/json-cBuilder/releases/download/v0.13.1-0/build_json-c.v0.13.1.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Gettext-v0.19.8-0/build_Gettext.v0.19.8.jl",
    "https://github.com/JuliaPackaging/Yggdrasil/releases/download/Libiconv-v1.15-0/build_Libiconv.v1.15.0.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

