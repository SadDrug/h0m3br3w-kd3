require_relative "../lib/cmake"

class Kf5Ktextwidgets < Formula
  desc "Advanced text editing widgets"
  homepage "https://api.kde.org/frameworks/ktextwidgets/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.91/ktextwidgets-5.91.0.tar.xz"
  sha256 "c41a6ae85345c33188c251e011a43672641fe489243c3436a1e1f15aa6cabf76"
  head "https://invent.kde.org/frameworks/ktextwidgets.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kcompletion"
  depends_on "kde-mac/kde/kf5-kiconthemes"
  depends_on "kde-mac/kde/kf5-kservice"
  depends_on "kde-mac/kde/kf5-sonnet"
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
    (testpath/"CMakeLists.txt").write("find_package(KF5TextWidgets REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
