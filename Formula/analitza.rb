class Analitza < Formula
  desc "Library to add mathematical features to your program"
  homepage "https://edu.kde.org/"
  url "https://download.kde.org/stable/release-service/20.12.1/src/analitza-20.12.1.tar.xz"
  sha256 "6d7e7744fae960e44d6fe88938a223e0f7de2b769e622e9d5bcdfe2bf3c2d8e2"
  revision 1
  head "https://invent.kde.org/education/analitza.git"

  depends_on "cmake" => [:build, :test]
  depends_on "eigen" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "kf5-kdoctools" => :build
  depends_on "ninja" => :build

  def install
    args = std_cmake_args
    args << "-G" << "Ninja"
    args << "-B" << "build"
    args << "-S" << "."
    args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    args << "-DCMAKE_INSTALL_LIBDIR=#{lib}"
    args << "-DBUILD_TESTING=OFF"
    args << "-DCMAKE_PREFIX_PATH=" + Formula["qt"].opt_prefix + "/lib/cmake"

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Analitza5 REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
