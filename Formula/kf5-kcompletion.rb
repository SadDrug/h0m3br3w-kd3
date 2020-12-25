class Kf5Kcompletion < Formula
  desc "Text completion helpers and widgets"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.77/kcompletion-5.77.0.tar.xz"
  sha256 "2ed7c90a575de468fd025688e7aa566b30003f4e43b1d7ed0c5dacafa0abf3d4"
  head "https://invent.kde.org/frameworks/kcompletion.git"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kconfig"
  depends_on "kde-mac/kde/kf5-kwidgetsaddons"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DKDE_INSTALL_QTPLUGINDIR=lib/qt5/plugins"

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install build/"install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Completion REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
