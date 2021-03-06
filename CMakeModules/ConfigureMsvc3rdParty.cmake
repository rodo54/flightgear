# ConfigureMsvc3rdParty.cmake - Configure 3rd Party Library Paths on Windows

if (MSVC)
    GET_FILENAME_COMPONENT(PARENT_DIR ${PROJECT_BINARY_DIR} PATH)
    if (CMAKE_CL_64)
        SET(TEST_3RDPARTY_DIR "${PARENT_DIR}/3rdparty.x64")
    else (CMAKE_CL_64)
        SET(TEST_3RDPARTY_DIR "${PARENT_DIR}/3rdparty")
    endif (CMAKE_CL_64)
    if (EXISTS ${TEST_3RDPARTY_DIR})
        set(MSVC_3RDPARTY_ROOT ${PARENT_DIR} CACHE PATH "Location where the third-party dependencies are extracted")
    else (EXISTS ${TEST_3RDPARTY_DIR})
        set(MSVC_3RDPARTY_ROOT NOT_FOUND CACHE PATH "Location where the third-party dependencies are extracted")
    endif (EXISTS ${TEST_3RDPARTY_DIR})
    list(APPEND PLATFORM_LIBS "winmm.lib")
else (MSVC)
    set(MSVC_3RDPARTY_ROOT NOT_FOUND CACHE PATH "Location where the third-party dependencies are extracted")
endif (MSVC)

if (MSVC AND MSVC_3RDPARTY_ROOT)
    message(STATUS "3rdparty files located in ${MSVC_3RDPARTY_ROOT}")
    set( OSG_MSVC "msvc" )
    if (${MSVC_VERSION} EQUAL 1900)
      set( OSG_MSVC ${OSG_MSVC}140 )
  elseif (${MSVC_VERSION} EQUAL 1800)
      set( OSG_MSVC ${OSG_MSVC}120 )
  else ()
    message(FATAL_ERROR "Visual Studio 2013/2015 is required now")
  endif ()

    if (CMAKE_CL_64)
        set( OSG_MSVC ${OSG_MSVC}-64 )
        set( MSVC_3RDPARTY_DIR 3rdParty.x64 )
		    set( BOOST_LIB lib64 )
    else (CMAKE_CL_64)
        set( MSVC_3RDPARTY_DIR 3rdParty )
	    	set( BOOST_LIB lib )
    endif (CMAKE_CL_64)

    set (CMAKE_LIBRARY_PATH ${MSVC_3RDPARTY_ROOT}/${MSVC_3RDPARTY_DIR}/lib ${MSVC_3RDPARTY_ROOT}/install/${OSG_MSVC}/OpenScenegraph/lib ${MSVC_3RDPARTY_ROOT}/install/${OSG_MSVC}/OpenRTI/lib ${MSVC_3RDPARTY_ROOT}/install/${OSG_MSVC}/SimGear/lib  )
    set (CMAKE_INCLUDE_PATH ${MSVC_3RDPARTY_ROOT}/${MSVC_3RDPARTY_DIR}/include ${MSVC_3RDPARTY_ROOT}/install/${OSG_MSVC}/OpenScenegraph/include ${MSVC_3RDPARTY_ROOT}/install/${OSG_MSVC}/OpenRTI/include ${MSVC_3RDPARTY_ROOT}/install/${OSG_MSVC}/SimGear/include)

    if(NOT BOOST_INCLUDEDIR)
        # if this variable was not set by the user, set it to 3rdparty root's
        # parent dir, which is the normal location for people using our
        # windows-3rd-party repo
        GET_FILENAME_COMPONENT(MSVC_ROOT_PARENT_DIR ${MSVC_3RDPARTY_ROOT} PATH)
        set(BOOST_INCLUDEDIR ${MSVC_ROOT_PARENT_DIR})
        message(STATUS "BOOST_INCLUDEDIR is ${BOOST_INCLUDEDIR}")
      endif()

    if (USE_AEONWAVE)
      find_package(AAX COMPONENTS aax REQUIRED)
    else()
      set (OPENAL_INCLUDE_DIR ${MSVC_3RDPARTY_ROOT}/${MSVC_3RDPARTY_DIR}/include)
      set (OPENAL_LIBRARY_DIR ${MSVC_3RDPARTY_ROOT}/${MSVC_3RDPARTY_DIR}/lib)
    endif()
endif (MSVC AND MSVC_3RDPARTY_ROOT)
