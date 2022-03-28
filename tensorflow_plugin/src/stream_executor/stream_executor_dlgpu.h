/* Copyright 2021 The TensorFlow Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/
#ifndef STREAM_EXECUTOR_STREAM_EXECUTOR_DLGPU_H_
#define STREAM_EXECUTOR_STREAM_EXECUTOR_DLGPU_H_

#include "tensorflow_plugin/src/stream_executor/cuda/cuda_platform.h"

#include "tensorflow/c/experimental/stream_executor/stream_executor.h"

struct SP_Stream_st {
  explicit SP_Stream_st(int id) : stream_id(id) {}
  int stream_id;
};

struct SP_Event_st {
  explicit SP_Event_st(int id) : event_id(id) {}
  int event_id;
};

struct SP_Timer_st {
  explicit SP_Timer_st(int id) : timer_id(id) {}
  int timer_id;
};

namespace stream_executor {
namespace dlgpu {

constexpr int kDeviceCount = 2;
constexpr char kDeviceName[] = "DLGPU";
constexpr char kDeviceType[] = "GPU";

void PopulateDLStreamExecutor(SP_StreamExecutor* se);
void PopulateDLDeviceFns(SP_DeviceFns* device_fns);
void PopulateDLTimerFns(SP_TimerFns* timer_fns);
void PopulateDLPlatform(SP_Platform* platform,
                             SP_PlatformFns* platform_fns);
void PopulateDLPlatformRegistrationParams(
    SE_PlatformRegistrationParams* const params);

void DestroyPlatform(SP_Platform* platform);
void DestroyPlatformFns(SP_PlatformFns* platform_fns);

class DLGpuPlugin {
  public:
   static DLGpuPlugin& getInstance() {
     static DLGpuPlugin instance;
     return instance;
   }

   CudaPlatform* getPlatform() { return platform_.get(); }
  private:
   explicit DLGpuPlugin();
   ~DLGpuPlugin() = default;
   DLGpuPlugin(const DLGpuPlugin&) = delete;
   DLGpuPlugin& operator=(const DLGpuPlugin&) = delete;
   std::unique_ptr<CudaPlatform> platform_;
};

}  // namespace dlgpu
}  // namespace stream_executor

#endif  // STREAM_EXECUTOR_STREAM_EXECUTOR_DLGPU_H_
