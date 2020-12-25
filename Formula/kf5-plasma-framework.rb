class Kf5PlasmaFramework < Formula
  desc "Plasma library and runtime components based upon KF5 & Qt5"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.77/plasma-framework-5.77.0.tar.xz"
  sha256 "11678e5274d10a4ca3730a2441c8b555eb527d2a66606bd35fa1f15f667ae985"
  head "https://invent.kde.org/frameworks/plasma-framework.git"

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "gettext" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "kde-kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kactivities"
  depends_on "kde-mac/kde/kf5-kdeclarative"
  depends_on "kde-mac/kde/kf5-kirigami2"

  patch :DATA

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DKDE_INSTALL_QTPLUGINDIR=lib/qt5/plugins"
    args << "-DCMAKE_INSTALL_BUNDLEDIR=#{bin}"

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install build/"install_manifest.txt"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      find_package(KF5Plasma REQUIRED)
      find_package(KF5PlasmaQuick REQUIRED)
    EOS
    system "cmake", ".", "-Wno-dev"
  end
end

# Mark executables as nongui type

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index fb7b76b..71ee8a4 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -25,6 +25,7 @@ include(ECMAddQch)
 include(KDEPackageAppTemplates)
 include(ECMGenerateQmlTypes)
 include(ECMSetupQtPluginMacroNames)
+include(ECMMarkNonGuiExecutable)

 option(BUILD_QCH "Build API documentation in QCH format (for e.g. Qt Assistant, Qt Creator & KDevelop)" OFF)
 add_feature_info(QCH ${BUILD_QCH} "API documentation in QCH format (for e.g. Qt Assistant, Qt Creator & KDevelop)")
diff --git a/src/plasmapkg/CMakeLists.txt b/src/plasmapkg/CMakeLists.txt
index 6247f92..20186d7 100644
--- a/src/plasmapkg/CMakeLists.txt
+++ b/src/plasmapkg/CMakeLists.txt
@@ -2,5 +2,6 @@ add_executable(plasmapkg2 main.cpp)

 target_link_libraries(plasmapkg2 Qt5::Core)

+ecm_mark_nongui_executable(plasmapkg2)
 install(TARGETS plasmapkg2 ${KF5_INSTALL_TARGETS_DEFAULT_ARGS})


