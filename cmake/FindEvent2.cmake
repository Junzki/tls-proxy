# Find LibEvent2
#
# Once done, this will define:
#
#  Event2_FOUND - system has Event2
#  Event2_INCLUDE_DIR - the Event2 include directories
#  Event2_LIBRARIES - link these to use Event2
#

if (Event2_INCLUDE_DIR AND Event2_LIBRARY)
  # Already in cache, be silent
  set(Event2_FIND_QUIETLY TRUE)
endif (Event2_INCLUDE_DIR AND Event2_LIBRARY)

find_path(Event2_INCLUDE_DIR event2
  PATHS /usr/include
)

find_library(Event2_LIBRARIES
  NAMES libevent-2.1.so.6
  PATHS /usr/lib /usr/local/lib
)

foreach(event2_lib openssl pthreads )
  find_library(Event2_${event2_lib}
    NAMES libevent_${event2_lib}-2.1.so.6
    PATHS /usr/lib /usr/local/lib
  )

  list(APPEND Event2_LIBRARIES ${Event2_${event2_lib}})
endforeach(event2_lib)

message(${Event2_LIBRARIES})

add_definitions(-DLIBNET_LIL_ENDIAN)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Event2
  DEFAULT_MSG
  Event2_INCLUDE_DIR
  Event2_LIBRARIES
)

mark_as_advanced(Event2_INCLUDE_DIR Event2_LIBRARIES)
