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
    (testpath/"test.cpp").write <<~EOS
      #include <ortools/routing.h>
      #include <iostream>
      #include <memory>
      int main(int argc, char* argv[]) {
        RoutingModel routing;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lortools", "-o", "test"
    system "./test"
  end
end
