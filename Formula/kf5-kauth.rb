require_relative "../lib/cmake"

class Kf5Kauth < Formula
  desc "Execute actions as privileged user"
  homepage "https://api.kde.org/frameworks/kauth/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.91/kauth-5.91.0.tar.xz"
  sha256 "f865cb134cf4013496940d48f397eae6cf6bc5013dadf911340c23bd7ddb3a00"
  head "https://invent.kde.org/frameworks/kauth.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "gpgme"
  depends_on "kde-mac/kde/kf5-kcoreaddons"

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
    (testpath/"CMakeLists.txt").write("find_package(KF5Auth REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
