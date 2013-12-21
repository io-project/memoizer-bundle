cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)
project(memoizer CXX)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

# TODO: Wykrywać modyfikacje w kodzie źródłowym na potrzeby Mavena
find_package(Maven REQUIRED)

add_maven(memoizer package memoizer-0.0.2-SNAPSHOT.jar RESULT_DEPENDENCIES lib DEPENDS memoizer-plugins)
add_maven(memoizer-plugins install memoizer-plugins-0.0.1-SNAPSHOT.jar)

install_maven(memoizer bin)
install_maven(memoizer-plugins bin/lib)

file(GLOB plugins RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} "memoizer-plugins-*")
foreach(plugin IN LISTS plugins)
    string(SUBSTRING ${plugin} 17 -1 plugin_name)
    set(output_file "memoizer-plugin-${plugin_name}-0.0.1.jar")
    add_maven(${plugin} package ${output_file} DEPENDS memoizer-plugins)
    install_maven(${plugin} bin/plugins)
endforeach()

add_subdirectory(memoizer-gui)
