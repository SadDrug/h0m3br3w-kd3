class Libksysguard < Formula
  desc "Libraries for ksysguard"
  homepage "https://www.kde.org/workspaces/plasmadesktop/"
  url "https://download.kde.org/stable/plasma/5.20.4/libksysguard-5.20.4.tar.xz"
  sha256 "a89968476cb8a888550e1a5138ab8e86eeb49788187192cba71f79abd4aad422"

  revision 1
  depends_on "cmake" => [:build, :test]
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "kde-kdoctools" => :build
  depends_on "kde-mac/kde/kf5-plasma-framework" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kio"

  def install
    args = *std_cmake_args
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install build/"install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5SysGuard REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
