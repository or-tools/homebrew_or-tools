class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools.git",
      :tag => "v6.7.1",
      :revision => "2e4c5b3617c433ab5ccdad6f5f5f7ccaa82adda7"
  head "https://github.com/google/or-tools.git",
      :branch => "mizux/shared"

  bottle do
    cellar :any
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "coin-or-tools/coinor/cbc"
  depends_on "gflags"
  depends_on "glog"
  depends_on "protobuf"

  needs :cxx11

  def install
    ENV.deparallelize
    ENV["UNIX_GFLAGS_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_GLOG_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_PROTOBUF_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_CBC_DIR"] = HOMEBREW_PREFIX
    # Make
    system "make", "detect"
    system "make", "cc"
    system "make", "prefix=#{prefix}", "install_cc"
    # CMake
    # mkdir "build" do
    #   system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    #   system "make", "PREFIX=#{prefix}", "install"
    # end

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
      #include <ortools/constraint_solver/routing.h>
      #include <iostream>
      #include <memory>
      using operations_research::RoutingModel;
      int main(int argc, char* argv[]) {
        const RoutingModel::NodeIndex kDepot(0);
        RoutingModel routing(42, 8, kDepot);
        std::cout << "done" << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lortools", "-o", "test"
    system "./test"
  end
end
