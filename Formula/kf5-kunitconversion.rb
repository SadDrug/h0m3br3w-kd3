class Kf5Kunitconversion < Formula
  desc "Support for unit conversion"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.78/kunitconversion-5.78.0.tar.xz"
  sha256 "8c790c9870362032556e3c7d6b37c01bfb571eef32d33a4ac3c96260d8a5439d"
  revision 1
  head "https://invent.kde.org/frameworks/kunitconversion.git"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "kde-ki18n"

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
    (testpath/"CMakeLists.txt").write("find_package(KF5UnitConversion REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
