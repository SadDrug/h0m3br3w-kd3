require_relative "../lib/cmake"

class Kf5Kinit < Formula
  desc "Process launcher to speed up launching KDE applications"
  homepage "https://api.kde.org/frameworks/kinit/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.79/kinit-5.79.0.tar.xz"
  sha256 "3b1727caf611f354ec2d3a2c0d74458cdfcc98325122ee64f35cf1a8de88f95e"
  head "https://invent.kde.org/frameworks/kinit.git"

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kio"

  patch :DATA

  def install
    args = kde_cmake_args

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Init REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end

# Fix the build

__END__
diff --git a/src/kdeinit/CMakeLists.txt b/src/kdeinit/CMakeLists.txt
index f00dd77..6c5f593 100644
--- a/src/kdeinit/CMakeLists.txt
+++ b/src/kdeinit/CMakeLists.txt
@@ -3,6 +3,7 @@ if (WIN32)
   set(kdeinit_LIBS psapi)
 elseif (APPLE)
   set(kdeinit_SRCS kinit.cpp kinit_mac.mm proctitle.cpp ../klauncher_cmds.cpp )
+  set_source_files_properties(kinit_mac.mm PROPERTIES COMPILE_DEFINITIONS QT_NO_EXCEPTIONS)
   set(kdeinit_LIBS "")
 else ()
   set(kdeinit_SRCS kinit.cpp proctitle.cpp ../klauncher_cmds.cpp )
