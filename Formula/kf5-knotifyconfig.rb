require_relative "../lib/cmake"

class Kf5Knotifyconfig < Formula
  desc "Configuration system for KNotify"
  homepage "https://api.kde.org/frameworks/knotifyconfig/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.115/knotifyconfig-5.115.0.tar.xz"
  sha256 "0547982279856f716782a1218c597aa2bddeaaeb82b469000cb1b51e1dbc08d6"
  head "https://invent.kde.org/frameworks/knotifyconfig.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kio"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5NotifiConfig REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
