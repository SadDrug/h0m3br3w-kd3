class Kf5SyntaxHighlighting < Formula
  desc "Syntax highlighting engine for structured text and code"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.78/syntax-highlighting-5.78.0.tar.xz"
  sha256 "8b5eb71ce548bb2267235db42d026d8655285396cfc2766e0277c8688d7bd6d4"
  revision 1
  head "https://invent.kde.org/frameworks/syntax-highlighting.git"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "qt"

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
    (testpath/"CMakeLists.txt").write("find_package(KF5SyntaxHighlighting REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
