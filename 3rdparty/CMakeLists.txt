#This file is for 3rdparty

include(ExternalProject)

set(absllist "a;b;c")
# passing a list to external project is best done via CMAKE_CACHE_ARGS
# CMAKE_ARGS doesn't work correctly for lists

set_directory_properties(PROPERTIES EP_UPDATE_DISCONNECTED true)
# don't repeatedly build ExternalProjects.
# dir prop scope: CMake_current_source_dir and subdirectories

set(ABSL_PROPAGATE_CXX_STD ON)
set(ABSL_ENABLE_INSTALL ON)
set(ABSL_COMMIT "6f9d96a1f41439ac172ee2ef7ccd8edf0e5d068c")

set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/install)

ExternalProject_Add(absl
GIT_REPOSITORY https://github.com/abseil/abseil-cpp.git
GIT_TAG ${ABSL_COMMIT}  # it's much better to use a specific Git revision or Git tag for reproducability
CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
#CMAKE_CACHE_ARGS -Dmyvar:STRING=${mylist}   # need variable type e.g. STRING for this
CONFIGURE_HANDLED_BY_BUILD ON
BUILD_BYPRODUCTS ${CMAKE_INSTALL_PREFIX}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}absl${CMAKE_STATIC_LIBRARY_SUFFIX}
)

#add_library(absl STATIC IMPORTED GLOBAL)
#set_target_properties(timestwo PROPERTIES
#IMPORTED_LOCATION ${CMAKE_INSTALL_PREFIX}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}absl${CMAKE_STATIC_LIBRARY_SUFFIX}
#INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_INSTALL_PREFIX}/include)
#
#add_executable(test_timestwo test_timestwo.f90)  # your program
#add_dependencies(test_timestwo CHILD)  # externalproject won't download without this
#target_link_libraries(test_timestwo PRIVATE timestwo)

