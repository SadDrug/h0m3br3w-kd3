require_relative "../lib/cmake"

class Kdialog < Formula
  desc "Utility for displaying dialog boxes from shell scripts"
  homepage "https://kde.org/applications/utilities/org.kde.kdialog"
  url "https://download.kde.org/stable/release-service/21.04.1/src/kdialog-21.04.1.tar.xz"
  sha256 "a55889bc31b5c20859dd77c27904a47c4017eace6c722b0631681b02f55ae0d6"
  head "https://invent.kde.org/utilities/kdialog.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-kcoreaddons"
  depends_on "kde-mac/kde/kf5-kdbusaddons"
  depends_on "kde-mac/kde/kf5-kguiaddons"
  depends_on "kde-mac/kde/kf5-kiconthemes"
  depends_on "kde-mac/kde/kf5-kio"
  depends_on "kde-mac/kde/kf5-knotifications"
  depends_on "kde-mac/kde/kf5-ktextwidgets"
  depends_on "kde-mac/kde/kf5-kwindowsystem"

  def install
    args = kde_cmake_args

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"
    # # Extract Qt plugin path
    # qtpp = `#{Formula["qt"].bin}/qtpaths --plugin-dir`.chomp
    # system "/usr/libexec/PlistBuddy",
    #   "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{qtpp}\:#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
    #   "#{bin}/dolphin.app/Contents/Info.plist"
  end

  # def post_install
  #   mkdir_p HOMEBREW_PREFIX/"share/dolphin"
  #   ln_sf HOMEBREW_PREFIX/"share/icons/breeze/breeze-icons.rcc", HOMEBREW_PREFIX/"share/dolphin/icontheme.rcc"
  # end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
        "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    assert_match "help", shell_output("#{bin}/kdialog.app/Contents/MacOS/kdialog --help")
  end
end
