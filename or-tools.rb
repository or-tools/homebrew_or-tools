# Copyright 2018 Google LLC All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
    system "make", "cc"
    system "make", "install"
  end

  test do
    system "false"
  end
end
