cmake_minimum_required(VERSION 3.8)

project("tls-proxy" C)

# Additional CMake modules.
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
include(ExternalProject)

# uthash
include_directories("uthash/include")

# pthread
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package (Threads REQUIRED)


# base64
add_custom_target(libbase64
                  COMMAND make
                  WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}/base64")

add_library(base64 STATIC IMPORTED)
add_dependencies(base64 libbase64)
set_target_properties(base64 PROPERTIES IMPORTED_LOCATION "${PROJECT_SOURCE_DIR}/base64/lib/libbase64.o")
include_directories("base64/include")
list(APPEND LIBS base64)

# LibDL
find_package(LIBDL REQUIRED)
include_directories(${LIBDL_INCLUDE_DIRS})
link_directories(${LIBDL_LIBRARIES})
list(APPEND LIBS ${LIBDL_LIBRARIES})


# OpenSSL
find_package(OpenSSL REQUIRED)
set(OPENSSL_USE_STATIC_LIBS TRUE)
include_directories(${OPENSSL_INCLUDE_DIRS})
link_directories(${OPENSSL_LIBRARIES})


# libevent
find_package(Event2 REQUIRED)
include_directories(${Event2_INCLUDE_DIR})
link_directories(${Event2_LIBRARIES})
list(APPEND LIBS ${Event2_LIBRARIES})


add_executable(tls-server tls-server.c)
add_executable(tls-client tls-client.c)

target_link_libraries(tls-server ${LIBS} Threads::Threads)
target_link_libraries(tls-client ${LIBS} ${OPENSSL_LIBRARIES} Threads::Threads)