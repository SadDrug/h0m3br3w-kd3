require_relative "../lib/cmake"

class Kf5Kross < Formula
  desc "Embedding of scripting into applications"
  homepage "https://api.kde.org/frameworks/kross/html"
  url "https://download.kde.org/stable/frameworks/5.82/portingAids/kross-5.82.0.tar.xz"
  sha256 "2575200e6bcc0289f82579b12473c31d7027c46d114256b02485a6596565a600"
  head "https://invent.kde.org/frameworks/kross.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "gettext" => :build
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kparts"

  patch :DATA

  def install
    args = kde_cmake_args

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
  end

  test do
    assert_match "help", shell_output("#{bin}/kf5kross --help")
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(KF5Kross REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end

# Mark executable as nongui type

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index c729c33..aaeb1df 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -20,6 +20,8 @@ include(ECMGenerateHeaders)

 include(ECMQtDeclareLoggingCategory)

+include(ECMMarkNonGuiExecutable)
+
 include(KDEInstallDirs)
 include(KDEFrameworkCompilerSettings NO_POLICY_SCOPE)
 include(KDECMakeSettings)
diff --git a/src/console/CMakeLists.txt b/src/console/CMakeLists.txt
index 8e15a1a..6808f52 100644
--- a/src/console/CMakeLists.txt
+++ b/src/console/CMakeLists.txt
@@ -7,4 +7,5 @@ target_link_libraries(kf5kross
    Qt5::Widgets
 )

+ecm_mark_nongui_executable(kf5kross)
 install(TARGETS kf5kross ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})
