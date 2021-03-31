using BinaryBuilder

name = "OpenMPI"
version = v"4.0.2"
sources = [
    ArchiveSource("https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-$(version).tar.gz",
                  "662805870e86a1471e59739b0c34c6f9004e0c7a22db068562d5388ec4421904"),
     DirectorySource("./bundled"),
]

script = raw"""
# Enter the funzone
cd ${WORKSPACE}/srcdir/openmpi-*

# atomic_patch -u -p1 ${WORKSPACE}/srcdir/patches/debug_configure.patch

export ompi_cv_fortran_alignment_CHARACTER=1
export ompi_cv_fortran_alignment_COMPLEX=4
export ompi_cv_fortran_alignment_COMPLEXp16=8
export ompi_cv_fortran_alignment_COMPLEXp32=16
export ompi_cv_fortran_alignment_COMPLEXp8=4
export ompi_cv_fortran_alignment_DOUBLE_COMPLEX=8
export ompi_cv_fortran_alignment_DOUBLE_PRECISION=8
export ompi_cv_fortran_alignment_INTEGER=4
export ompi_cv_fortran_alignment_INTEGERp1=1
export ompi_cv_fortran_alignment_INTEGERp2=2
export ompi_cv_fortran_alignment_INTEGERp4=4
export ompi_cv_fortran_alignment_INTEGERp8=8
export ompi_cv_fortran_alignment_LOGICAL=4
export ompi_cv_fortran_alignment_LOGICALp1=1
export ompi_cv_fortran_alignment_LOGICALp2=2
export ompi_cv_fortran_alignment_LOGICALp4=4
export ompi_cv_fortran_alignment_LOGICALp8=8
export ompi_cv_fortran_alignment_REAL=4
export ompi_cv_fortran_alignment_REALp16=16
export ompi_cv_fortran_alignment_REALp4=4
export ompi_cv_fortran_alignment_REALp8=8
export ompi_cv_fortran_alignment_type_test_mpi_handle_=4
export ompi_cv_fortran_kind_value_0=0
export ompi_cv_fortran_kind_value_C_DOUBLE=8
export ompi_cv_fortran_kind_value_C_DOUBLE_COMPLEX=8
export ompi_cv_fortran_kind_value_C_FLOAT=4
export ompi_cv_fortran_kind_value_C_FLOAT_COMPLEX=4
export ompi_cv_fortran_kind_value_C_INT16_T=2
export ompi_cv_fortran_kind_value_C_INT32_T=4
export ompi_cv_fortran_kind_value_C_INT64_T=8
export ompi_cv_fortran_kind_value_C_INT=4
export ompi_cv_fortran_kind_value_C_LONG_DOUBLE=10
export ompi_cv_fortran_kind_value_C_LONG_DOUBLE_COMPLEX=10
export ompi_cv_fortran_kind_value_C_LONG_LONG=8
export ompi_cv_fortran_kind_value_C_SHORT=2
export ompi_cv_fortran_kind_value_C_SIGNED_CHAR=1
export ompi_cv_fortran_sizeof_CHARACTER=1
export ompi_cv_fortran_sizeof_COMPLEX=8
export ompi_cv_fortran_sizeof_COMPLEXp16=16
export ompi_cv_fortran_sizeof_COMPLEXp32=32
export ompi_cv_fortran_sizeof_COMPLEXp8=8
export ompi_cv_fortran_sizeof_DOUBLE_COMPLEX=16
export ompi_cv_fortran_sizeof_DOUBLE_PRECISION=8
export ompi_cv_fortran_sizeof_INTEGER=4
export ompi_cv_fortran_sizeof_INTEGERp16=16
export ompi_cv_fortran_sizeof_INTEGERp1=1
export ompi_cv_fortran_sizeof_INTEGERp2=2
export ompi_cv_fortran_sizeof_INTEGERp4=4
export ompi_cv_fortran_sizeof_INTEGERp8=8
export ompi_cv_fortran_sizeof_LOGICAL=4
export ompi_cv_fortran_sizeof_LOGICALp1=1
export ompi_cv_fortran_sizeof_LOGICALp2=2
export ompi_cv_fortran_sizeof_LOGICALp4=4
export ompi_cv_fortran_sizeof_LOGICALp8=8
export ompi_cv_fortran_sizeof_REAL=4
export ompi_cv_fortran_sizeof_REALp16=16
export ompi_cv_fortran_sizeof_REALp4=4
export ompi_cv_fortran_sizeof_REALp8=8
export ompi_cv_fortran_sizeof_type_test_mpi_handle_=4
export ompi_cv_real16_c_equiv=yes
export ompi_cv_fortran_true_value=1
./configure  --prefix=$prefix --host=$target --enable-shared=yes --enable-static=no --without-cs-fs

# Build the library
make "${flags[@]}" -j${nproc}

# Test the library
make "${flags[@]}" check

# Install the library
make "${flags[@]}" install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line.
#platforms = supported_platforms()
platforms = filter(!Sys.iswindows, supported_platforms())

products = [
    LibraryProduct("libmpi", :libmpi)
    LibraryProduct("libmpi_mpifh", :libmpi_mpifh)
    ExecutableProduct("mpiexec", :mpiexec)
]

dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
