require_relative "../lib/cmake"

class Kf5Kcmutils < Formula
  desc "Utilities for KDE System Settings modules"
  homepage "https://api.kde.org/frameworks/kcmutils/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.98/kcmutils-5.98.0.tar.xz"
  sha256 "1d1740f3a115111802fcd58c3f7c3e52ca77f65e2c449859ccdd4a132279134b"
  head "https://invent.kde.org/frameworks/kcmutils.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kdeclarative"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5KCMUtils REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
