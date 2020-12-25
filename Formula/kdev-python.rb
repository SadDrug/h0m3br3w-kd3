class KdevPython < Formula
  desc "KDevelop Python language support"
  homepage "https://kde.org/applications/development/org.kde.kdev-python"
  url "https://download.kde.org/stable/kdevelop/5.6.0/src/kdev-python-5.6.0.tar.xz"
  sha256 "cb7163c1b72390c647bb9c0892abc84007699d447f303b4652cdd9cdb0036d52"
  revision 1
  head "https://invent.kde.org/kdevelop/kdev-python.git"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "kde-mac/kde/kdevelop"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end
end
