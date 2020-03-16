class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools.git",
      :tag => "v7.5",
      :revision => "1"

  head "https://github.com/google/or-tools.git",
       :branch => "master"

  bottle do
    cellar :any
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "coin-or-tools/coinor/cbc"
  depends_on "abseil"
  depends_on "gflags"
  depends_on "glog"
  depends_on "protobuf"

  def install
    ENV.deparallelize
    ENV["UNIX_GFLAGS_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_GLOG_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_PROTOBUF_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_CBC_DIR"] = HOMEBREW_PREFIX
    # Make
    #system "make", "detect"
    #system "make", "cc"
    #system "make", "prefix=#{prefix}", "install_cc"
    # CMake
    # mkdir "build" do
    system "cmake", "-S.", "-Bbuild", *std_cmake_args
    system "cmake", "--build build"
    system "cmake", "--build build", "--target install"
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
