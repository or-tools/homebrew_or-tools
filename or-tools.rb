class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  url "https://github.com/google/or-tools/archive/v8.2.tar.gz"
  sha256 "beb9fe379977033151045d0815d26c628ad99d74d68b9f3b707578492723731e"
  license "Apache-2.0"
  head "https://github.com/google/or-tools.git"

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
  depends_on "osi"
  depends_on "protobuf"

  # This is a CMake based build

  def install
    # CMake based build
    system "cmake", "-S.", "-Bbuild", *std_cmake_args,
           "-DUSE_SCIP=OFF", "-DBUILD_SAMPLES=OFF", "-DBUILD_EXAMPLES=OFF"
    system "cmake", "--build", "build", "-v"
    system "cmake", "--build", "build", "--target", "install"
    pkgshare.install "ortools/linear_solver/samples/simple_lp_program.cc"
    pkgshare.install "ortools/constraint_solver/samples/simple_routing_program.cc"
    pkgshare.install "ortools/sat/samples/simple_sat_program.cc"
  end

  test do
    # Linear Solver & Glop Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           pkgshare/"simple_lp_program.cc", "-o", "simple_lp_program"
    system "./simple_lp_program"
    # Routing Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           pkgshare/"simple_routing_program.cc", "-o", "simple_routing_program"
    system "./simple_routing_program"
    # Sat Solver
    system ENV.cxx, "-std=c++17",
           "-I#{include}", "-L#{lib}", "-lortools",
           pkgshare/"simple_sat_program.cc", "-o", "simple_sat_program"
    system "./simple_sat_program"
  end
end
