class Kf5Kbookmarks < Formula
  desc "Support for bookmarks and the XBEL format"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.78/kbookmarks-5.78.0.tar.xz"
  sha256 "8301b0857e253bd12ffdbcde2866f91c4dcfe438bccd51b8bbbc61efa703ef2c"
  revision 1
  head "https://invent.kde.org/frameworks/kbookmarks.git"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "KDE-mac/kde/kf5-kxmlgui"

  def install
    args = std_cmake_args
    args << "-G" << "Ninja"
    args << "-B" << "build"
    args << "-S" << "."
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DKDE_INSTALL_QTPLUGINDIR=lib/qt5/plugins"

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Bookmarks REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
