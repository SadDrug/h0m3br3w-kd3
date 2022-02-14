require_relative "../lib/cmake"

class Kf5Tier3Frameworks < Formula
  desc "Metapackage for Tier 3 KF5 frameworks"
  homepage "https://api.kde.org/frameworks"
  system "touch", "/tmp/empty"
  url "file:///tmp/empty"
  version "5.91.0"
  sha256 "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"

  livecheck do
    skip "Meta package"
  end

  depends_on "kde-mac/kde/kf5-kbookmarks" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kcmutils" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kconfigwidgets" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kdeclarative" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kded" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kdesu" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kemoticons" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kglobalaccel" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kiconthemes" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kinit" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kio" => [:build, :test]
  depends_on "kde-mac/kde/kf5-knewstuff" => [:build, :test]
  depends_on "kde-mac/kde/kf5-knotifyconfig" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kparts" => [:build, :test]
  depends_on "kde-mac/kde/kf5-krunner" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kservice" => [:build, :test]
  depends_on "kde-mac/kde/kf5-ktexteditor" => [:build, :test]
  depends_on "kde-mac/kde/kf5-ktextwidgets" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kwallet" => [:build, :test]
  depends_on "kde-mac/kde/kf5-kxmlgui" => [:build, :test]
  depends_on "kde-mac/kde/kf5-plasma-framework" => [:build, :test]
  depends_on "kde-mac/kde/kf5-tier2-frameworks" => :build

  def install
    touch "empty"
    prefix.install "empty"
  end

  def caveats
    <<~EOS
      You need to take some manual steps in order to make this formula work:
      "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      find_package(ECM REQUIRED)
      set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})
      find_package(KF5Bookmarks REQUIRED)
      find_package(KF5KCMUtils REQUIRED)
      find_package(KF5ConfigWidgets REQUIRED)
      find_package(KF5Declarative REQUIRED)
      find_package(KDED REQUIRED)
      find_package(KF5DesignerPlugin REQUIRED)
      find_package(KF5Su REQUIRED)
      find_package(KF5WebKit REQUIRED)
      find_package(KF5Emoticons REQUIRED)
      find_package(KF5GlobalAccel REQUIRED)
      find_package(KF5IconThemes REQUIRED)
      find_package(KF5Init REQUIRED)
      find_package(KF5KIO REQUIRED)
      find_package(KF5NewStuff REQUIRED)
      find_package(KF5NewStuffCore REQUIRED)
      find_package(KF5NewStuffQuick REQUIRED)
      find_package(KF5NotifyConfig REQUIRED)
      find_package(KF5Parts REQUIRED)
      find_package(KF5People REQUIRED)
      find_package(KF5Runner REQUIRED)
      find_package(KF5Service REQUIRED)
      find_package(KF5TextEditor REQUIRED)
      find_package(KF5TextWidgets REQUIRED)
      find_package(KF5Wallet REQUIRED)
      find_package(KF5XmlGui REQUIRED)
      find_package(KF5XmlRpcClient REQUIRED)
      find_package(KF5Plasma REQUIRED)
      find_package(KF5PlasmaQuick REQUIRED)
    EOS
    system "cmake", ".", "-Wno-dev"
  end
end
