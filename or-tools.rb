class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  license "Apache-2.0"

  url "https://github.com/google/or-tools.git",
      :tag => "v8.0",
      :revision => "8d19323faf51f2f004e4de6c1b32a74001fbc7c1"

  head "https://github.com/google/or-tools/archive/master.zip"
  #head "https://github.com/google/or-tools.git",
  #     :branch => "master"

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
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "osi"
  depends_on "coinutils"

  def install
    # CMake based build
    system "cmake", "-S.", "-Bbuild", "-DUSE_SCIP=OFF", "-DBUILD_SAMPLES=OFF", "-DBUILD_EXAMPLES=OFF", *std_cmake_args
    system "cmake", "--build", "build", "-v"
    system "cmake", "--build", "build", "--target", "install"

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
      using operations_research::RoutingIndexManager;
      int main(int argc, char* argv[]) {
        const RoutingIndexManager::NodeIndex kDepot(0);
        RoutingIndexManager manager(42, 8, kDepot);
        RoutingModel routing(manager);
        std::cout << "done" << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp",
                    "-I#{include}", "-L#{lib}", "-lortools",
                    "-o", "test"
    system "./test"
  end
end
