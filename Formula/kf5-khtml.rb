require_relative "../lib/cmake"

class Kf5Khtml < Formula
  desc "KHTML APIs"
  homepage "https://api.kde.org/frameworks/khtml/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.91/portingAids/khtml-5.91.0.tar.xz"
  sha256 "a40056d988fd77bc4bd3749465ed5452701b7e4948e10dc67fb592925c98b3d1"
  head "https://invent.kde.org/frameworks/khtml.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "gperf" => :build
  depends_on "ninja" => :build

  depends_on "giflib"
  depends_on "jpeg"
  depends_on "kde-mac/kde/kf5-kjs"
  depends_on "kde-mac/kde/kf5-kparts"
  depends_on "kde-mac/kde/phonon"
  depends_on "libpng"
  depends_on "openssl"
  depends_on "zlib"

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
    (testpath/"CMakeLists.txt").write("find_package(KF5KHtml REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
