require_relative "../lib/cmake"

class Kf5Kemoticons < Formula
  desc "Support for emoticons and emoticons themes"
  homepage "https://api.kde.org/frameworks/kemoticons/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.80/kemoticons-5.80.0.tar.xz"
  sha256 "0b8affb1cd506fcc7a7582b37fac2da68fc45e8f34df32e4f5335fb79af9e549"
  head "https://invent.kde.org/frameworks/kemoticons.git"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "karchive"
  depends_on "kde-mac/kde/kf5-kservice"

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
    (testpath/"CMakeLists.txt").write("find_package(KF5Emoticons REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
