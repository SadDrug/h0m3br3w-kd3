class Kf5Kauth < Formula
  desc "Abstraction to system policy and authentication features"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.78/kauth-5.78.0.tar.xz"
  sha256 "efb3b050492f466c4c531217c39aed67524976884a00f395eaeca147caf61db0"
  revision 1
  head "https://invent.kde.org/frameworks/kauth.git"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "gpgme"
  depends_on "KDE-mac/kde/kf5-kcoreaddons"

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

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Auth REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
