cmake_minimum_required(VERSION 3.8)

project("tls-proxy" C)

# Additional CMake modules.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
include(ExternalProject)

include_directories("uthash/include")


# base64
ExternalProject_Add(project_base64
                    SOURCE_DIR "${PROJECT_SOURCE_DIR}/base64"
                    PREFIX "${CMAKE_CURRENT_BINARY_DIR}/base64"
                    BUILD_COMMAND make
                    BUILD_IN_SOURCE 1
                    INSTALL_COMMAND make install
                    PREFIX="${CMAKE_CURRENT_BINARY_DIR}/base64")

ExternalProject_Get_Property(project_base64 install_dir)
add_library(base64 STATIC IMPORTED)
set_property(TARGET base64 PROPERTY IMPORTED_LOCATION "${install_dir}/lib/libbase64.a")

include_directories("base64/include")
list(APPEND LIBS base64)


# OpenSSL
find_package(OpenSSL REQUIRED)
include_directories(${OPENSSL_INCLUDE_DIR})
link_directories(${OPENSSL_LIBRARIES})


# libevent
find_package(Event REQUIRED)
include_directories(${Event_INCLUDE_DIRS})
link_directories(${Event_LIBRARIES})
list(APPEND LIBS ${Event_LIBRARIES})


add_executable(tls-server tls-server.c)
add_executable(tls-client tls-client.c)

add_dependencies(tls-server project_base64)
add_dependencies(tls-client project_base64)

target_link_libraries(tls-server ${LIBS} ${OPENSSL_LIBRARIES})
target_link_libraries(tls-client ${LIBS})