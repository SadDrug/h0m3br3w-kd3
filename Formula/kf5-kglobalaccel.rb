require_relative "../lib/cmake"

class Kf5Kglobalaccel < Formula
  desc "Add support for global workspace shortcuts"
  homepage "https://api.kde.org/frameworks/kglobalaccel/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.115/kglobalaccel-5.115.0.tar.xz"
  sha256 "c533d5447d0dded4a349e86dfaf97ca4e4d1def41e2ebed03fb856bfae69acc3"
  head "https://invent.kde.org/frameworks/kglobalaccel.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kconfig"
  depends_on "kde-mac/kde/kf5-kcrash"
  depends_on "kde-mac/kde/kf5-kdbusaddons"

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
    (testpath/"CMakeLists.txt").write("find_package(KF5GlobalAccel REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
