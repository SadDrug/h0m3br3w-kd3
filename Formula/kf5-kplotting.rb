require_relative "../lib/cmake"

class Kf5Kplotting < Formula
  desc "Lightweight plotting framework"
  homepage "https://api.kde.org/frameworks/kplotting/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.101/kplotting-5.101.0.tar.xz"
  sha256 "f1d04d1f51aedf162e2acdb1721ab7780aa1d5f89c50d050600291ac8fc15018"
  head "https://invent.kde.org/frameworks/kplotting.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "qt@5"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Plotting REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
