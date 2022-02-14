require_relative "../lib/cmake"

class Kf5Kiconthemes < Formula
  desc "Support for icon themes"
  homepage "https://api.kde.org/frameworks/kiconthemes/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.91/kiconthemes-5.91.0.tar.xz"
  sha256 "820d592beab1547265fcc2a61f6262535b85d444a05fd67b4eb2f11d9f2510ce"
  head "https://invent.kde.org/frameworks/kiconthemes.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "gettext" => :build
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "karchive"
  depends_on "kde-mac/kde/kf5-kconfigwidgets"
  depends_on "kde-mac/kde/kf5-kitemviews"

  def install
    args = kde_cmake_args

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5IconThemes REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
