class Dolphin < Formula
  desc "KDE File Manager"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/release-service/20.12.1/src/dolphin-20.12.1.tar.xz"
  sha256 "b71652f40f28d92e790a0cdffbd0124c09a7a2264a7a798297b9238171454f58"
  revision 2
  head "https://invent.kde.org/system/dolphin.git"

  depends_on "cmake" => [:build, :test]
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "kde-kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "KDE-mac/kde/kf5-breeze-icons"
  depends_on "KDE-mac/kde/kf5-kcmutils"
  depends_on "KDE-mac/kde/kf5-kdelibs4support"
  depends_on "KDE-mac/kde/kf5-kfilemetadata"
  depends_on "KDE-mac/kde/kf5-kinit"
  depends_on "KDE-mac/kde/kf5-knewstuff"
  depends_on "KDE-mac/kde/kf5-kparts"
  depends_on "KDE-mac/kde/kio-extras"

  depends_on "KDE-mac/kde/konsole" => :optional
  depends_on "ruby" => :optional

  def install
    args = std_cmake_args
    args << "-G" << "Ninja"
    args << "-B" << "build"
    args << "-S" << "."
    args << "-DBUILD_TESTING=OFF"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DCMAKE_INSTALL_BUNDLEDIR=#{bin}"

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "install_manifest.txt"
    # Extract Qt plugin path
    qtpp = `#{Formula["qt"].bin}/qtpaths --plugin-dir`.chomp
    system "/usr/libexec/PlistBuddy",
      "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
      "#{bin}/dolphin.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/dolphin"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/dolphin/icontheme.rcc"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert `"#{bin}/dolphin.app/Contents/MacOS/dolphin" --help | grep -- --help`.include?("--help")
  end
end
