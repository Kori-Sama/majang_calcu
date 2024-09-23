cmake_minimum_required(VERSION 3.10.2)
set(OpenCV_STATIC ON)
set(OpenCV_DIR "./OpenCV-android-sdk/sdk/native/jni")
find_package(OpenCV REQUIRED)
add_library(native_cv
            SHARED
            ../src/native.cpp )
find_library(
        log-lib
        log)
target_link_libraries( 
        native_cv
        ${OpenCV_LIBS}
        ${log-lib})