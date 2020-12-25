class KdevPhp < Formula
  desc "PHP Language Plugin for KDevelop"
  homepage "https://kde.org/applications/development/org.kde.kdev-php"
  url "https://download.kde.org/stable/kdevelop/5.6.0/src/kdev-php-5.6.0.tar.xz"
  sha256 "39ec342aeb43bf1482c327575e0f810339d309bffbfaa8260ec912a8e3fc4a2b"
  revision 1
  head "https://invent.kde.org/kdevelop/kdev-php.git"

  depends_on "cmake" => [:build, :test]
  depends_on "ninja" => :build
  depends_on "kde-mac/kde/kdevelop"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install build/"install_manifest.txt"
  end
end
