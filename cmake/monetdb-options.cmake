#[[
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0.  If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright 1997 - July 2008 CWI, August 2008 - 2020 MonetDB B.V.
#]]

option(RELEASE_VERSION
  "Use release values for version variables"
  OFF)

# In case of .hg/.git we assume a development
if(EXISTS "${CMAKE_SOURCE_DIR}/.hg" OR EXISTS "${CMAKE_SOURCE_DIR}/.git")
  set(DEVELOPMENT TRUE)
else()
  set(DEVELOPMENT FALSE)
endif()

option(TESTING 
  "Enable support for testing" 
  ON)

cmake_dependent_option(CINTEGRATION 
  "Enable support for C UDFs (default=ON)"
  ON
  "NOT WIN32"
  OFF)

cmake_dependent_option(PY3INTEGRATION 
  "Enable support for Python 3 integration into MonetDB (default=ON)"
  ON
  "DEVELOPMENT"
  OFF)

cmake_dependent_option(RINTEGRATION 
  "Enable support for R integration into MonetDB (default=ON)"
  ON
  "DEVELOPMENT"
  OFF)

option(FITS 
  "Enable support for FITS (default=ON)"
  ON)

option(GEOM
  "Enable support for geom module (default=ON)"
  ON) 

option(INT128 
  "Enable support for 128-bit integers (default=ON)"
  ON) 

option(LIDAR 
  "Enable support for LiDAR data (default=ON)"
  ON) 

option(NETCDF 
  "Enable support for netcdf (default=ON)" 
  ON)

option(ODBC 
  "Compile the MonetDB ODBC driver (default=ON)"
  ON)

cmake_dependent_option(SHP
  "Enable support for ESRI Shapefiles (default=ON)"
  ON
  GEOM
  ON)

set(ENABLE_MAPI "YES" CACHE STRING "Enable MAPI (default=YES)") # Check with HAVE_MAPI

option(SANITIZER 
  "Enable support for the GCC address sanitizer (default=OFF)"
  OFF)

cmake_dependent_option(STRICT 
  "Enable strict compiler flags (default=ON for development sources, OFF for tarball instalation)"
  ON
  "DEVELOPMENT"
  OFF)

cmake_dependent_option(ASSERT 
  "Enable asserts (default=ON for development sources, OFF for tarball instalation)"
  ON
  "DEVELOPMENT"
  OFF)

set(ENABLE_STATIC_ANALYSIS "NO" CACHE STRING "Configure for static code analysis (use only if you know what you are doing)") # Check with STATIC_CODE_ANALYSIS
# compiler options, profiling (google perf tools), valgrind

option(WITH_BZ2
  "Include bz2 support"
  ON)

option(WITH_CURL
  "Include curl support"
  ON)

option(WITH_LZMA
  "Include lzma support"
  ON)

option(WITH_XML2
  "Include xml2 support"
  ON)

option(WITH_LZ4
  "Include lz4 support"
  ON)

option(WITH_PROJ
  "Include proj support"
  ON)

option(WITH_READLINE
  "Include readline support"
  ON)

option(WITH_PCRE
  "Include pcre support"
  ON)

option(WITH_SNAPPY
  "Include snappy support"
  ON)

option(WITH_UUID
  "Include uuid support"
  ON)

option(WITH_VALGRIND
  "Include valgrind support"
  ON)

option(WITH_ZLIB
  "Include zlib support"
  ON)

option(CMAKE_SUMMARY
  "Show a summary of the cmake configuration (for debug purposes)"
  OFF)
