if(NOT TARGET papilo)
  include(${CMAKE_CURRENT_LIST_DIR}/papilo-targets.cmake)
endif()
set(PAPILO_IMPORTED_TARGETS papilo)
set(PAPILO_FOUND 1)

include(CMakeFindDependencyMacro)

# If PAPILO was built with Quadmath then we also need it.
set(PAPILO_HAVE_FLOAT128 1)
if(PAPILO_HAVE_FLOAT128)
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
    find_dependency(Quadmath)
    if(NOT Quadmath_FOUND)
        message(WARNING "Dependency Quadmath was not found but is required for PAPILO_HAVE_FLOAT128.")
        set(PAPILO_FOUND 0)
    endif()
endif()

# If PAPILO was built with GMP then we also need it.
set(PAPILO_HAVE_GMP 1)
if(PAPILO_HAVE_GMP AND PAPILO_FOUND)
    if(NOT GMP_FOUND)
        find_dependency(GMP)
    endif()
    if(NOT GMP_FOUND)
        message(WARNING "Dependency GMP was not found but is required for PAPILO_HAVE_GMP.")
        set(PAPILO_FOUND 0)
    endif()
endif()

# If PAPILO was built with TBB then we also need it.
set(PAPILO_TBB on)
if(PAPILO_TBB AND PAPILO_FOUND)
    if(NOT TBB_FOUND)
        list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
        find_package(TBB 2018 COMPONENTS tbb tbbmalloc REQUIRED HINTS ${CMAKE_CURRENT_LIST_DIR}/_deps/local/ ${CMAKE_CURRENT_LIST_DIR}/_deps/local/lib)
    endif()
    if(NOT TBB_FOUND)
        message(WARNING "Dependency TBB was not found using HINTS ${CMAKE_CURRENT_LIST_DIR}/_deps/local/ and ${CMAKE_CURRENT_LIST_DIR}/_deps/local/lib, but is required for PAPILO_TBB.")
        set(PAPILO_FOUND 0)
    endif()
endif()

# If PAPILO uses the standard hashmap then we also do.
set(PAPILO_USE_STANDARD_HASHMAP 0)

# If PAPILO was built with iostreams / program_options / serialization then we also need it.
set(PAPILO_HAVE_BOOST_IOSTREAMS 1)
set(PAPILO_USE_BOOST_IOSTREAMS_WITH_ZLIB )
set(PAPILO_USE_BOOST_IOSTREAMS_WITH_BZIP2 )
set(PAPILO_COMMAND_LINE_AVAILABLE 1)
set(PAPILO_SERIALIZATION_AVAILABLE 1)
set(BOOST_COMPONENTS)
if(PAPILO_HAVE_BOOST_IOSTREAMS)
    set(BOOST_COMPONENTS ${BOOST_COMPONENTS} iostreams)
endif()
if(PAPILO_COMMAND_LINE_AVAILABLE)
    set(BOOST_COMPONENTS ${BOOST_COMPONENTS} program_options)
endif()
if(PAPILO_SERIALIZATION_AVAILABLE)
    set(BOOST_COMPONENTS ${BOOST_COMPONENTS} serialization)
endif()
if(BOOST_COMPONENTS AND PAPILO_FOUND)
    if((NOT Boost_PROGRAM_OPTIONS_FOUND AND PAPILO_COMMAND_LINE_AVAILABLE) OR (NOT Boost_SERIALIZATION_FOUND AND PAPILO_SERIALIZATION_AVAILABLE) OR (NOT Boost_IOSTREAMS_FOUND AND PAPILO_HAVE_BOOST_IOSTREAMS))
        find_dependency(Boost 1.65 COMPONENTS ${BOOST_COMPONENTS})
    endif()
    if(NOT Boost_IOSTREAMS_FOUND AND PAPILO_HAVE_BOOST_IOSTREAMS)
        message(WARNING "Dependency Boost::iostreams was not found but is required for PAPILO_USE_BOOST_IOSTREAMS_WITH_ZLIB or PAPILO_USE_BOOST_IOSTREAMS_WITH_BZIP2.")
        set(PAPILO_FOUND 0)
    endif()
    if(NOT Boost_PROGRAM_OPTIONS_FOUND AND PAPILO_COMMAND_LINE_AVAILABLE)
        message(WARNING "Dependency Boost::program_options was not found but is required for PAPILO_COMMAND_LINE_AVAILABLE.")
        set(PAPILO_FOUND 0)
    endif()
    if(NOT Boost_SERIALIZATION_FOUND AND PAPILO_SERIALIZATION_AVAILABLE)
        message(WARNING "Dependency Boost::serialization was not found but is required for PAPILO_SERIALIZATION_AVAILABLE.")
        set(PAPILO_FOUND 0)
    endif()
endif()

# We also need Threads.
if(PAPILO_FOUND)
    if(NOT Threads_FOUND)
        find_dependency(Threads REQUIRED)
    endif()
    if(NOT Threads_FOUND)
        message(WARNING "Dependency Threads was not found but is required.")
        set(PAPILO_FOUND 0)
    endif()
endif()

if(1 AND PAPILO_FOUND)
   enable_language(Fortran)
endif()

