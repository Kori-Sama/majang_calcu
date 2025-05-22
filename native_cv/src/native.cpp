#include <stdint.h>
#include <opencv2/core.hpp>
#include "yolo.h"
#include <vector>
#include <string>
#include <cstdlib> // For malloc, free
#include <cstring> // For strdup

// Define C-style structs for FFI
struct Detection
{
    char *label_prob; // e.g., "0: 0.95"
};

struct DetectionResult
{
    Detection *detections;
    int count;
};

extern "C"
{
    __attribute__((visibility("default"))) __attribute__((used))
    const char *
    get_opencv_version()
    {
        return CV_VERSION;
    }

    // Renamed and modified for FFI compatibility
    __attribute__((visibility("default"))) __attribute__((used))
    DetectionResult *
    yolo_detect_ffi(
        const char *parampath,
        const char *modelpath,
        const char *imgpath,
        int target_size,
        int use_gpu,
        const char *outpath)
    {
        YOLOv8_det yolov8;
        yolov8.set_det_target_size(target_size);
        yolov8.load(parampath, modelpath, use_gpu);

        cv::Mat rgb = cv::imread(imgpath);
        std::vector<Object> objects; // Assuming Object is defined in yolo.h
                                     // and has members like 'label' (int) and 'prob' (float/double)
        yolov8.detect(rgb, objects);

        yolov8.draw(rgb, objects);
        cv::imwrite(outpath, rgb);

        DetectionResult *result_ffi = (DetectionResult *)malloc(sizeof(DetectionResult));
        if (!result_ffi)
        {
            return nullptr; // Allocation failed
        }

        result_ffi->count = static_cast<int>(objects.size());
        if (result_ffi->count == 0)
        {
            result_ffi->detections = nullptr;
            return result_ffi;
        }

        result_ffi->detections = (Detection *)malloc(result_ffi->count * sizeof(Detection));
        if (!result_ffi->detections)
        {
            free(result_ffi);
            return nullptr; // Allocation failed
        }
        // Initialize all detection label_prob pointers to null in case of early exit
        for (int i = 0; i < result_ffi->count; ++i)
        {
            result_ffi->detections[i].label_prob = nullptr;
        }

        for (int i = 0; i < result_ffi->count; ++i)
        {
            std::string temp_str = std::to_string(objects[i].label) + ": " + std::to_string(objects[i].prob);
            result_ffi->detections[i].label_prob = strdup(temp_str.c_str());
            if (!result_ffi->detections[i].label_prob)
            {
                // strdup failed, cleanup previously allocated strings and structs
                for (int j = 0; j < i; ++j)
                {
                    free(result_ffi->detections[j].label_prob);
                }
                free(result_ffi->detections);
                free(result_ffi);
                return nullptr; // Allocation failed
            }
        }
        return result_ffi;
    }

    __attribute__((visibility("default"))) __attribute__((used)) void free_detection_result(DetectionResult *result)
    {
        if (result)
        {
            if (result->detections)
            {
                for (int i = 0; i < result->count; ++i)
                {
                    if (result->detections[i].label_prob)
                    {
                        free(result->detections[i].label_prob);
                    }
                }
                free(result->detections);
            }
            free(result);
        }
    }
}