class Kf5Solid < Formula
  desc "Hardware integration and detection"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.78/solid-5.78.0.tar.xz"
  sha256 "129710956e0f9940b00a0b6b9dca86709f3b753ab88debbf93d7ebaeb44bfde1"
  revision 1
  head "https://invent.kde.org/frameworks/solid.git"

  depends_on "bison" => :build
  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "flex" => :build
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
    # setTime_t function is deprecated since 5.8.
    args << "-DCMAKE_C_FLAGS_RELEASE=-DNDEBUG -DQT_DISABLE_DEPRECATED_BEFORE=0x050700"
    args << "-DCMAKE_CXX_FLAGS_RELEASE=-DNDEBUG -DQT_DISABLE_DEPRECATED_BEFORE=0x050700"

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Solid REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
