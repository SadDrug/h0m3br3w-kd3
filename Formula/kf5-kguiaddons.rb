require_relative "../lib/cmake"

class Kf5Kguiaddons < Formula
  desc "Addons to QtGui"
  homepage "https://api.kde.org/frameworks/kguiaddons/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.82/kguiaddons-5.82.0.tar.xz"
  sha256 "9bb7611bf10250de952e59f2ef682eec28695c7782a7b81970003f3982d5e339"
  head "https://invent.kde.org/frameworks/kguiaddons.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "qt@5"

  def install
    args = kde_cmake_args

    args << "-DWITH_WAYLAND=OFF"

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5GuiAddons REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
