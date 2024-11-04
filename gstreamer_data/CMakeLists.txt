cmake_minimum_required(VERSION 2.8.8)
include(FindPkgConfig)

project(demo)

pkg_check_modules(GSTREAMER REQUIRED gstreamer-1.0)
include_directories(${GSTREAMER_INCLUDE_DIRS})
link_directories(${GSTREAMER_LIBRARY_DIRS})

file(GLOB proj_srcs *.c *.cpp)
add_library(${CMAKE_PROJECT_NAME} SHARED ${proj_srcs})
install(TARGETS ${CMAKE_PROJECT_NAME} DESTINATION /usr/lib/x86_64-linux-gnu/gstreamer-1.0)

