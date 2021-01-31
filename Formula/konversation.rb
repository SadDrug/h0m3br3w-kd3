class Konversation < Formula
  desc "User-friendly and fully-featured IRC client"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/release-service/20.12.1/src/konversation-20.12.1.tar.xz"
  sha256 "441e8924763893e5933309dd90525ed8fc37e6e7dc2eda2b1e6cab7176f4d7f4"
  revision 2
  head "https://invent.kde.org/network/konversation.git"

  depends_on "cmake" => [:build, :test]
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "kde-kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "hicolor-icon-theme"
  depends_on "KDE-mac/kde/kf5-breeze-icons"
  depends_on "KDE-mac/kde/kf5-kemoticons"
  depends_on "KDE-mac/kde/kf5-kidletime"
  depends_on "KDE-mac/kde/kf5-kio"
  depends_on "KDE-mac/kde/kf5-knotifyconfig"
  depends_on "KDE-mac/kde/kf5-kparts"
  depends_on "qca"

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
      "#{bin}/konversation.app/Contents/Info.plist"
  end

  def post_install
    mkdir_p HOMEBREW_PREFIX/"share/konversation"
    ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/konversation/icontheme.rcc"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/konversation.app/Contents/MacOS/konversation --help")
  end
end
