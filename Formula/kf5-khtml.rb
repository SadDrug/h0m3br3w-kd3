require_relative "../lib/cmake"

class Kf5Khtml < Formula
  desc "KHTML APIs"
  homepage "https://api.kde.org/frameworks/khtml/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.114/portingAids/khtml-5.114.0.tar.xz"
  sha256 "3e6f1038d823488657b08d9899dc49054b3c5dfef865e4c889754b98f427c8d5"
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
    (testpath/"CMakeLists.txt").write("find_package(KF5KHtml REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
