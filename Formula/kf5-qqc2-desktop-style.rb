require_relative "../lib/cmake"

class Kf5Qqc2DesktopStyle < Formula
  desc "Style for Qt QC2 to follow your desktop theme"
  homepage "https://api.kde.org/frameworks/qqc2-desktop-style/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.82/qqc2-desktop-style-5.82.0.tar.xz"
  sha256 "3426b476ed3a9de868f31311309b98b2c6535250ea071abc85df7170a42f50ea"
  head "https://invent.kde.org/frameworks/qqc2-desktop-style.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kiconthemes"
  depends_on "kde-mac/kde/kf5-kirigami2"

  def install
    args = kde_cmake_args

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5QQC2DeskopStyle REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
