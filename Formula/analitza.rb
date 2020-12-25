class Analitza < Formula
  desc "Library to add mathematical features to your program"
  homepage "https://edu.kde.org/"
  url "https://download.kde.org/stable/release-service/20.12.0/src/analitza-20.12.0.tar.xz"
  sha256 "dda39c7ffbb8c47e8b6ff4682948e68be2ea382c16f3f4bb4c1484631eb3a4cb"
  revision 1
  head "https://invent.kde.org/education/analitza.git"

  depends_on "cmake" => [:build, :test]
  depends_on "eigen" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "kde-kdoctools" => :build
  depends_on "ninja" => :build

  def install
    args = std_cmake_args
    args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    args << "-DCMAKE_INSTALL_LIBDIR=#{lib}"
    args << "-DBUILD_TESTING=OFF"
    args << "-DCMAKE_PREFIX_PATH=" + Formula["qt"].opt_prefix + "/lib/cmake"

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Analitza5 REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
