require_relative "../lib/cmake"

class Kf5Kinit < Formula
  desc "Process launcher to speed up launching KDE applications"
  homepage "https://api.kde.org/frameworks/kinit/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.114/kinit-5.114.0.tar.xz"
  sha256 "f032bcf699dcb713f76c08fda146e5fd0d8c971e51255f2a04e2ef02f04bdf2c"
  head "https://invent.kde.org/frameworks/kinit.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kio"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Init REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
