class Kf5Kbookmarks < Formula
  desc "Support for bookmarks and the XBEL format"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.77/kbookmarks-5.77.0.tar.xz"
  sha256 "20d1afd298227f4d45685a17816d7a41ef97e97a99ef816a7939226f92327923"
  head "https://invent.kde.org/frameworks/kbookmarks.git"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "KDE-mac/kde/kf5-kxmlgui"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DKDE_INSTALL_QTPLUGINDIR=lib/qt5/plugins"

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Bookmarks REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
