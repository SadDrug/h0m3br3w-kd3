class Libalkimia < Formula
  desc "Library used by KDE Finance applications"
  homepage "https://kmymoney.org"
  url "https://download.kde.org/stable/alkimia/8.0.4/alkimia-8.0.4.tar.xz"
  head "https://invent.kde.org/office/alkimia.git"
  sha256 "0004a7068dff0aa2cb6f47f70d21c129073be11f2edb21f14512bc4470487d1f"
  revision 1

  stable do
    depends_on "kde-mac/kde/kf5-kdelibs4support"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "gettext"
  depends_on "gmp"
  depends_on "KDE-mac/kde/kf5-kcoreaddons"
  depends_on "kde-mac/kde/kf5-knewstuff"
  depends_on "kde-mac/kde/kf5-plasma-framework"
  depends_on "KDE-mac/kde/qt-webkit"

  def install
    args = std_cmake_args
    args << "-G" << "Ninja"
    args << "-B" << "build"
    args << "-S" << "."
    args << "-DBUILD_TESTING=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DQt5WebKitWidgets_DIR=" + Formula["qt-webkit"].opt_prefix + "/lib/cmake/Qt5WebKitWidgets"
    args << "-DCMAKE_INSTALL_BUNDLEDIR=#{bin}"
    args << "-DSHARE_INSTALL_DIR=#{pkgshare}"

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(LibAlkimia5 REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
