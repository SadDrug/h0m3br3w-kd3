require_relative "../lib/cmake"

class Kf5SyntaxHighlighting < Formula
  desc "Syntax highlighting engine for structured text and code"
  homepage "https://api.kde.org/frameworks/syntax-highlighting/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.91/syntax-highlighting-5.91.0.tar.xz"
  sha256 "370a45b274db90e8d2d34d61d3f665a3f1f9f552d4503ce5805a47f445c4f93a"
  head "https://invent.kde.org/frameworks/syntax-highlighting.git", branch: "master"

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

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5SyntaxHighlighting REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
