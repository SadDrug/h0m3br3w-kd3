require_relative "../lib/cmake"

class Kf5Kdbusaddons < Formula
  desc "Addons to QtDBus"
  homepage "https://api.kde.org/frameworks/kdbusaddons/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.98/kdbusaddons-5.98.0.tar.xz"
  sha256 "0a24e2c3fc8c1e8af70bfd76439f81fa0f35fb50f1711fe22db68bc82cad8d3b"
  head "https://invent.kde.org/frameworks/kdbusaddons.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "dbus"
  depends_on "qt@5"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5DBusAddons REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
