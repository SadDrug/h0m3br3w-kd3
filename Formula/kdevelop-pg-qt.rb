class KdevelopPgQt < Formula
  desc "LL(1) parser generator based on Qt"
  homepage "https://kdevelop.org"
  url "https://download.kde.org/stable/kdevelop-pg-qt/2.2.1/src/kdevelop-pg-qt-2.2.1.tar.xz"
  sha256 "c13931788ac9dc02188cdd9c6e71e164ae81b4568b048748652bbf6fa4a9c62b"
  revision 1
  head "https://invent.kde.org/kdevelop/kdevelop-pg-qt.git"

  depends_on "cmake" => [:build, :test]
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-G" << "Ninja"
    args << "-B" << "build"
    args << "-S" << "."
    args << "-DBUILD_TESTING=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KDevelop-PG-Qt REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
