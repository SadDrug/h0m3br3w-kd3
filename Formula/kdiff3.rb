require_relative "../lib/cmake"

class Kdiff3 < Formula
  desc "File and folder diff and merge tool which"
  homepage "https://apps.kde.org/kdiff3/"
  url "https://download.kde.org/stable/kdiff3/kdiff3-1.9.0.tar.xz"
  sha256 "a7fd61a23f1e37f25af0efa82265d4723e63889aa3213a58b76ce0c96eab23d0"
  head "https://invent.kde.org/sdk/kdiff3.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "kde-mac/kde/kf5-kcoreaddons" => :build
  depends_on "kde-mac/kde/kf5-kcrash" => :build
  depends_on "kde-mac/kde/kf5-kiconthemes" => :build
  depends_on "kde-mac/kde/kf5-kparts" => :build
  depends_on "kdoctools" => :build
  depends_on "ninja" => :build

  depends_on "kde-mac/kde/kf5-breeze-icons"
  depends_on "qt@5"

  def install
    args = kde_cmake_args

    args << "-DMACOSX_BUNDLE_ICON_FILE=kdiff3.icns"

    system "cmake", *args
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
    output = shell_output("#{bin}/kdiff3 --help")
    assert_match "help", output
  end
end
