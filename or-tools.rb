
require 'formula'

class OrTools < Formula
  desc "Google's Operations Research tools"
  homepage "https://developers.google.com/optimization/"
  head 'https://github.com/google/or-tools.git'

  url "https://github.com/google/or-tools/archive/v6.7.1.tar.gz"
  sha256 "c82c63a6c2b0913fe06b8d7ec2a4b42c54c1810d42c6350cf08a022915963793"

  depends_on 'cmake' => :build
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
    #system "cmake", ".", *std_cmake_args
    system "make", "detect"
    system "make", "cc"
    system "make", "install"
  end

  test do
    system "false"
  end
end
