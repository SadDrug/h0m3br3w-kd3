require_relative "../lib/cmake"

class Kf5Kwidgetsaddons < Formula
  desc "Addons to QtWidgets"
  homepage "https://api.kde.org/frameworks/kwidgetsaddons/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.91/kwidgetsaddons-5.91.0.tar.xz"
  sha256 "e3b4dc3db4d608b2a725e9087ca3add1105e4027e7e47d10f96c2eff344af20e"
  head "https://invent.kde.org/frameworks/kwidgetsaddons.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "qt@5"

  def install
    args = kde_cmake_args

    system "cmake", *args
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
    (testpath/"CMakeLists.txt").write("find_package(KF5WidgetsAddons REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
