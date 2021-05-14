require_relative "../lib/cmake"

class Kf5Kactivities < Formula
  desc "Core components for the KDE Activity concept"
  homepage "https://api.kde.org/frameworks/kactivities/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.82/kactivities-5.82.0.tar.xz"
  sha256 "94d762bf19c2e70299a41e065b8b950be0d6c4507db69269586b35f522183275"
  head "https://invent.kde.org/frameworks/kactivities.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "boost" => :build
  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kconfig"
  depends_on "kde-mac/kde/kf5-kcoreaddons"
  depends_on "kde-mac/kde/kf5-kwindowsystem"

  patch :DATA

  def install
    args = kde_cmake_args

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Activities REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end

# Mark executables as nongui type

__END__
diff --git a/src/cli/CMakeLists.txt b/src/cli/CMakeLists.txt
index d0e13be..479031b 100644
--- a/src/cli/CMakeLists.txt
+++ b/src/cli/CMakeLists.txt
@@ -30,6 +30,8 @@ target_link_libraries (
    KF5::Activities
    )
 
+ecm_mark_nongui_executable(kactivities-cli)
+
 install (TARGETS
    kactivities-cli
    ${KF5_INSTALL_TARGETS_DEFAULT_ARGS}
