class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools.git",
      :tag => "v7.8",
      :revision => "1"

  head "https://github.com/google/or-tools.git",
       :branch => "master"

  bottle do
    cellar :any
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "gflags"
  depends_on "glog"
  depends_on "protobuf"
  depends_on "coin-or-tools/coinor/cbc"
  #depends_on "cbc"
  #depends_on "cgl"
  #depends_on "clp"
  #depends_on "osi"
  #depends_on "coinutils"

  def install
    ENV.deparallelize
    ENV["UNIX_ABSL_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_GFLAGS_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_GLOG_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_PROTOBUF_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_CBC_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_CGL_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_CLP_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_OSI_DIR"] = HOMEBREW_PREFIX
    ENV["UNIX_COINUTILS_DIR"] = HOMEBREW_PREFIX
    ENV["USE_SCIP"] = OFF
    # Make Based build
    system "make", "detect"
    system "make", "cc"
    system "make", "prefix=#{prefix}", "install_cc"
    # CMake based build
    # mkdir "build" do
    #system "cmake", "-S.", "-Bbuild", "-DUSE_SCIP=OFF",*std_cmake_args
    #system "cmake", "--build build", "-v"
    #system "cmake", "--build build", "--target install"
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
