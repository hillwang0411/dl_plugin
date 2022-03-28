#ifndef TENSORFLOW_PLUGIN_SRC_UTILS_PLATFORM_PREFETCH_H_
#define TENSORFLOW_PLUGIN_SRC_UTILS_PLATFORM_PREFETCH_H_

#include "tensorflow_plugin/src/utils/platform.h"

namespace demo_plugin {
namespace port {

// Prefetching support
//
// Defined behavior on some of the uarchs:
// PREFETCH_HINT_T0:
//   prefetch to all levels of the hierarchy (except on p4: prefetch to L2)
// PREFETCH_HINT_NTA:
//   p4: fetch to L2, but limit to 1 way (out of the 8 ways)
//   core: skip L2, go directly to L1
//   k8 rev E and later: skip L2, can go to either of the 2-ways in L1
enum PrefetchHint {
  PREFETCH_HINT_T0 = 3, // More temporal locality
  PREFETCH_HINT_T1 = 2,
  PREFETCH_HINT_T2 = 1, // Less temporal locality
  PREFETCH_HINT_NTA = 0 // No temporal locality
};
template <PrefetchHint hint> void prefetch(const void *x);

// ---------------------------------------------------------------------------
// Inline implementation
// ---------------------------------------------------------------------------
template <PrefetchHint hint> inline void prefetch(const void *x) {
// Check of COMPILER_GCC macro below is kept only for backward-compatibility
// reasons. COMPILER_GCC3 is the macro that actually enables prefetch.
#if defined(__llvm__) || defined(COMPILER_GCC) || defined(COMPILER_GCC3)
  __builtin_prefetch(x, 0, hint);
#else
// You get no effect.  Feel free to add more sections above.
#endif
}

} // namespace port
} // namespace demo_plugin

#endif // TENSORFLOW_PLUGIN_SRC_UTILS_PLATFORM_PREFETCH_H_
