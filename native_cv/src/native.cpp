#include <stdint.h>
#include <opencv2/core.hpp>

extern "C"
{
    __attribute__((visibility("default"))) __attribute__((used))
    const char *
    get_opencv_version()
    {
        return CV_VERSION;
    }
}