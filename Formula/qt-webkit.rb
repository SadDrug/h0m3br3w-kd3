class QtWebkit < Formula
  desc "Port of WebKit on top of Qt"
  homepage "https://github.com/qtwebkit/qtwebkit"
  revision 2
  head "https://code.qt.io/qt/qtwebkit.git",
   branch: "5.212"
  patch :DATA # Apple Silicon fixes, https://github.com/qtwebkit/qtwebkit/pull/1047

  depends_on "cmake" => [:build, :test]
  depends_on "fontconfig" => :build
  depends_on "freetype" => :build
  depends_on "gperf" => :build
  depends_on "ninja" => :build
  depends_on "sqlite" => :build

  depends_on "libxslt"
  depends_on "qt"
  depends_on "webp"
  depends_on "zlib"

  def cmake_args
    %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_FIND_FRAMEWORK=LAST
      -DCMAKE_VERBOSE_MAKEFILE=ON
      -Wno-dev
    ]
  end

  def install
    args = cmake_args
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DKDE_INSTALL_QTPLUGINDIR=lib/qt5/plugins"
    args << "-DPORT=Qt"
    args << "-DENABLE_TOOLS=OFF"
    args << "-DCMAKE_MACOSX_RPATH=OFF"
    args << "-DEGPF_SET_RPATH=OFF"
    args << "-DCMAKE_SKIP_RPATH=ON"
    args << "-DCMAKE_SKIP_INSTALL_RPATH=ON"

    # Fuck off rpath
    inreplace "Source/cmake/OptionsQt.cmake",
              "set(CMAKE_MACOSX_RPATH\ ON)",
              ""

    mkdir "build" do
      system "cmake", "-G", "Ninja", "..", *args
      system "ninja"
      system "ninja", "install"
      prefix.install "install_manifest.txt"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Qt5 CONFIG COMPONENTS WebKit WebKitWidgets REQUIRED)")
    system "cmake", ".", "-Wno-dev"
  end
end

__END__
From 219aaeee642bce47773df3e797fe8083207b29e2 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Dawid=20Wro=CC=81bel?= <me@dawidwrobel.com>
Date: Fri, 5 Feb 2021 20:24:50 -0500
Subject: [PATCH] Fix compilation errors on Apple Silicon.

This is based on 309131edbf99fbd8bbdcc721263258395be372ce upstream commit
by Sam Weinig (<weinig@apple.com>), which does not apply cleanly due to
QtWebKit's codebase being too far behind the upstream.
---
 Source/JavaScriptCore/assembler/ARM64Assembler.h       | 6 +++---
 Source/JavaScriptCore/assembler/ARMv7Assembler.h       | 2 +-
 Source/JavaScriptCore/assembler/AssemblerCommon.h      | 9 +++++++++
 Source/JavaScriptCore/b3/air/AirCCallingConvention.cpp | 2 +-
 Source/JavaScriptCore/jit/ExecutableAllocator.h        | 4 ++--
 Source/WTF/wtf/InlineASM.h                             | 2 +-
 Source/WTF/wtf/Platform.h                              | 2 +-
 7 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/Source/JavaScriptCore/assembler/ARM64Assembler.h b/Source/JavaScriptCore/assembler/ARM64Assembler.h
index e573620c46aa..29e3029d2ef6 100644
--- a/Source/JavaScriptCore/assembler/ARM64Assembler.h
+++ b/Source/JavaScriptCore/assembler/ARM64Assembler.h
@@ -2664,7 +2664,7 @@ class ARM64Assembler {
 
     static void cacheFlush(void* code, size_t size)
     {
-#if OS(IOS)
+#if OS(DARWIN)
         sys_cache_control(kCacheFunctionPrepareForExecution, code, size);
 #elif OS(LINUX)
         size_t page = pageSize();
@@ -3059,13 +3059,13 @@ class ARM64Assembler {
     static int xOrSp(RegisterID reg)
     {
         ASSERT(!isZr(reg));
-        ASSERT(!isIOS() || reg != ARM64Registers::x18);
+        ASSERT(!isDarwin() || reg != ARM64Registers::x18);
         return reg;
     }
     static int xOrZr(RegisterID reg)
     {
         ASSERT(!isSp(reg));
-        ASSERT(!isIOS() || reg != ARM64Registers::x18);
+        ASSERT(!isDarwin() || reg != ARM64Registers::x18);
         return reg & 31;
     }
     static FPRegisterID xOrZrAsFPR(RegisterID reg) { return static_cast<FPRegisterID>(xOrZr(reg)); }
diff --git a/Source/JavaScriptCore/assembler/ARMv7Assembler.h b/Source/JavaScriptCore/assembler/ARMv7Assembler.h
index 6b9f305e9274..3384f65b80dd 100644
--- a/Source/JavaScriptCore/assembler/ARMv7Assembler.h
+++ b/Source/JavaScriptCore/assembler/ARMv7Assembler.h
@@ -2354,7 +2354,7 @@ class ARMv7Assembler {
 
     static void cacheFlush(void* code, size_t size)
     {
-#if OS(IOS)
+#if OS(DARWIN)
         sys_cache_control(kCacheFunctionPrepareForExecution, code, size);
 #elif OS(LINUX)
         size_t page = pageSize();
diff --git a/Source/JavaScriptCore/assembler/AssemblerCommon.h b/Source/JavaScriptCore/assembler/AssemblerCommon.h
index 21ca7a20ddce..82e0a9f3d6cb 100644
--- a/Source/JavaScriptCore/assembler/AssemblerCommon.h
+++ b/Source/JavaScriptCore/assembler/AssemblerCommon.h
@@ -28,6 +28,15 @@
 
 namespace JSC {
 
+ALWAYS_INLINE bool isDarwin()
+{
+ #if OS(DARWIN)
+     return true;
+ #else
+     return false;
+ #endif
+}
+
 ALWAYS_INLINE bool isIOS()
 {
 #if PLATFORM(IOS)
diff --git a/Source/JavaScriptCore/b3/air/AirCCallingConvention.cpp b/Source/JavaScriptCore/b3/air/AirCCallingConvention.cpp
index 63128a7c989c..edab230f51d9 100644
--- a/Source/JavaScriptCore/b3/air/AirCCallingConvention.cpp
+++ b/Source/JavaScriptCore/b3/air/AirCCallingConvention.cpp
@@ -45,7 +45,7 @@ Arg marshallCCallArgumentImpl(unsigned& argumentCount, unsigned& stackOffset, Va
         return Tmp(BankInfo::toArgumentRegister(argumentIndex));
 
     unsigned slotSize;
-    if (isARM64() && isIOS()) {
+    if (isARM64() && isDarwin()) {
         // Arguments are packed.
         slotSize = sizeofType(child->type());
     } else {
diff --git a/Source/JavaScriptCore/jit/ExecutableAllocator.h b/Source/JavaScriptCore/jit/ExecutableAllocator.h
index 015ac8968a7b..efb49044b192 100644
--- a/Source/JavaScriptCore/jit/ExecutableAllocator.h
+++ b/Source/JavaScriptCore/jit/ExecutableAllocator.h
@@ -36,11 +36,11 @@
 #include <wtf/RefCounted.h>
 #include <wtf/Vector.h>
 
-#if OS(IOS)
+#if OS(DARWIN)
 #include <libkern/OSCacheControl.h>
 #endif
 
-#if OS(IOS)
+#if OS(DARWIN)
 #include <sys/mman.h>
 #endif
 
diff --git a/Source/WTF/wtf/InlineASM.h b/Source/WTF/wtf/InlineASM.h
index 965e28176e70..2b3e371cb918 100644
--- a/Source/WTF/wtf/InlineASM.h
+++ b/Source/WTF/wtf/InlineASM.h
@@ -34,7 +34,7 @@
 #define SYMBOL_STRING(name) #name
 #endif
 
-#if OS(IOS)
+#if OS(DARWIN)
 #define THUMB_FUNC_PARAM(name) SYMBOL_STRING(name)
 #else
 #define THUMB_FUNC_PARAM(name)
diff --git a/Source/WTF/wtf/Platform.h b/Source/WTF/wtf/Platform.h
index 7aefa1bab50d..8fc6ab68183c 100644
--- a/Source/WTF/wtf/Platform.h
+++ b/Source/WTF/wtf/Platform.h
@@ -462,7 +462,7 @@
 #define WTF_PLATFORM_GTK 1
 #elif OS(MAC_OS_X)
 #define WTF_PLATFORM_MAC 1
-#elif OS(IOS)
+#elif OS(DARWIN)
 #define WTF_PLATFORM_IOS 1
 #if defined(TARGET_IPHONE_SIMULATOR) && TARGET_IPHONE_SIMULATOR
 #define WTF_PLATFORM_IOS_SIMULATOR 1
