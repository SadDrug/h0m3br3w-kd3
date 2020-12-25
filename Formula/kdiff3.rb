class Kdiff3 < Formula
  desc "Utility for comparing and merging files and directories"
  homepage "https://kde.org/applications/en/development/org.kde.kdiff3"
  url "https://download.kde.org/stable/kdiff3/kdiff3-1.8.4.tar.xz"
  sha256 "76e18e097a078c1a440a32562734391d71d12446fcd3b2afeece87c136f43bb8"
  revision 1
  head "https://invent.kde.org/sdk/kdiff3.git"

  depends_on "cmake" => :build
  depends_on "kde-extra-cmake-modules" => :build
  depends_on "kde-kdoctools" => :build
  depends_on "kde-mac/kde/kf5-kcoreaddons" => :build
  depends_on "kde-mac/kde/kf5-kcrash" => :build
  depends_on "kde-mac/kde/kf5-kiconthemes" => :build
  depends_on "kde-mac/kde/kf5-kparts" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-breeze-icons"
  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DCMAKE_INSTALL_BUNDLEDIR=#{prefix}"
    args << "-DCMAKE_INSTALL_MANDIR=#{man}"
    args << "-DMACOSX_BUNDLE_ICON_FILE=kdiff3.icns"

    args = *std_cmake_args
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    prefix.install "build/install_manifest.txt"

    bin.write_exec_script "#{prefix}/kdiff3.app/Contents/MacOS/kdiff3"
    # Create icns file from svg
    mkdir "#{prefix}/kdiff3.app/Contents/Resources" do
      system "ksvg2icns", "#{share}/icons/hicolor/scalable/apps/kdiff3.svgz"
    end
  end

  test do
    assert_match "help", shell_output("#{bin}/kdiff3 --help")
  end
end
