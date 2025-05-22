cmake_minimum_required(VERSION 3.10.2)

set(OpenCV_STATIC ON)

set(OpenCV_DIR "./OpenCV-android-sdk/sdk/native/jni")
find_package(OpenCV REQUIRED)

set(ncnn_DIR "./ncnn/lib/cmake/ncnn")
find_package(ncnn REQUIRED)

add_library(native_cv
            SHARED
            ../src/native.cpp
            ../src/yolo.cpp 
            ../src/yolo.h
            ../src/yolo_det.cpp)

find_library(
        log-lib
        log)
target_link_libraries( 
        native_cv
        ncnn
        ${OpenCV_LIBS}
        ${log-lib})