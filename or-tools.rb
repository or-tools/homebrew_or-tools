class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v8.0.tar.gz"
  sha256 "ac01d7ebde157daaeb0e21ce54923a48e4f1d21faebd0b08a54979f150f909ee"
  license "Apache-2.0"
  head "https://github.com/google/or-tools/archive/master.zip"

  bottle do
    cellar :any
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "gflags"
  depends_on "glog"
  depends_on "osi"
  depends_on "protobuf"

  # This is a CMake based build

  def install
    # CMake based build
    system "cmake", "-S.", "-Bbuild", *std_cmake_args, "-DUSE_SCIP=OFF", "-DBUILD_SAMPLES=OFF", "-DBUILD_EXAMPLES=OFF"
    system "cmake", "--build", "build", "-v"
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    # Linear Solver & Glop Solver
    cp pkgshare/"ortools/linear_solver/samples/simple_lp_program.cc", testpath
    system ENV.cxx, "-std=c++17", "simple_lp_program.cpp",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-o", "simple_lp_program"
    system "./simple_lp_program"
    # Routing Solver
    cp pkgshare/"ortools/constraint_solver/samples/simple_routing_program.cc", testpath
    system ENV.cxx, "-std=c++17", "simple_routing_program.cpp",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-o", "simple_routing_program"
    system "./simple_routing_program"
    # Sat Solver
    cp pkgshare/"ortools/constraint_solver/samples/simple_sat_program.cc", testpath
    system ENV.cxx, "-std=c++17", "simple_sat_program.cpp",
           "-I#{include}", "-L#{lib}", "-lortools",
           "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
