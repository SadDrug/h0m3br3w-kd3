class Grantlee < Formula
  desc "String template engine based on the Django template system"
  homepage "http://grantlee.org"
  revision 1
  head "https://github.com/steveire/grantlee.git"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "lcov" => :build
  depends_on "ninja" => :build

  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTS=OFF"

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install build/"install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Grantlee5 REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
