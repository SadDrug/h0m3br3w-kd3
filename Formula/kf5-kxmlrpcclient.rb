require_relative "../lib/cmake"

class Kf5Kxmlrpcclient < Formula
  desc "XML-RPC client library for KDE"
  homepage "https://api.kde.org/frameworks/kxmlrpcclient/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.115/portingAids/kxmlrpcclient-5.115.0.tar.xz"
  sha256 "8074fd5c167119500d2a83981aeccfb533752c830d718c6160547c619a283208"
  head "https://invent.kde.org/frameworks/kxmlrpcclient.git", branch: "master"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kio"

  def install
    system "cmake", *kde_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5XmlRpcClient REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end
