
#ifndef YOLOV8_H
#define YOLOV8_H

#include <opencv2/core/core.hpp>

#include <net.h>

struct KeyPoint
{
    cv::Point2f p;
    float prob;
};

struct Object
{
    cv::Rect_<float> rect;
    cv::RotatedRect rrect;
    int label;
    float prob;
    int gindex;
    cv::Mat mask;
    std::vector<KeyPoint> keypoints;
};

class YOLOv8
{
public:
    virtual ~YOLOv8();

    int load(const char *parampath, const char *modelpath, bool use_gpu = false);
    int load(AAssetManager *mgr, const char *parampath, const char *modelpath, bool use_gpu = false);

    void set_det_target_size(int target_size);

    virtual int detect(const cv::Mat &rgb, std::vector<Object> &objects) = 0;
    virtual int draw(cv::Mat &rgb, const std::vector<Object> &objects) = 0;

protected:
    ncnn::Net yolov8;
    int det_target_size;
};

class YOLOv8_det : public YOLOv8
{
public:
    virtual int detect(const cv::Mat &rgb, std::vector<Object> &objects);
};

class YOLOv8_det_coco : public YOLOv8_det
{
public:
    virtual int draw(cv::Mat &rgb, const std::vector<Object> &objects);
};

class YOLOv8_det_oiv7 : public YOLOv8_det
{
public:
    virtual int draw(cv::Mat &rgb, const std::vector<Object> &objects);
};

#endif // YOLOV8_H