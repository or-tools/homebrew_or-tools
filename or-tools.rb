
require 'formula'

class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  head 'https://github.com/google/or-tools.git'

  url "https://github.com/google/or-tools.git",
      :tag => "v6.7.1",
      :revision => "2e4c5b3617c433ab5ccdad6f5f5f7ccaa82adda7"

  depends_on 'cmake' => :build
  depends_on 'coin-or-tools/coinor/cbc'
  depends_on 'gflags'
  depends_on 'glog'
  depends_on 'protobuf'
  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :build
  depends_on 'scip' => :optional
#  bottle do
#    cellar :any_skip_relocation
#    sha256 "" => :high_sierra
#    sha256 "" => :sierra
#    sha256 "" => :el_capitan
#    sha256 "" => :yosemite
#    sha256 "" => :mavericks
#  end

  def install
    ENV.deparallelize
    # Make
    system "make", "detect"
    system "make", "cc"
    system "make", "install"
    # CMake
    #mkdir "build" do
    #  system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    #  system "make", "install"
    #end

    # Produce pkg-config file under cmake/make
    (lib/"pkgconfig/libortools.pc").write <<~EOS
      prefix=#{prefix}
      exec_prefix=${prefix}
      libdir=${exec_prefix}/lib
      includedir=${prefix}/include
      Name: libortools
      Description: Google OR-Tools C++ software suite for combinatorial optimization
      Version: #{stable.version}
      Libs: -L${libdir} -lortools
      Cflags: -I${includedir}
    EOS
  end

  test do
    system "false"
  end
end
