# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.


# From cmake documentation:
# True if the constant is 1, ON, YES, TRUE, Y, or a non-zero number.
# False if the constant is 0, OFF, NO, FALSE, N, IGNORE, NOTFOUND, the empty string, or ends in the suffix -NOTFOUND.
# Named boolean constants are case-insensitive.
#
# While this regex does contain a check for an empty string that check does not work
# cmake's regex is weak

macro(__plugin_option variable description value)
  if(NOT DEFINED ${variable})
    set(${variable} ${value} CACHE STRING ${description})
  endif()
endmacro()

set(TVM_ALL_OPTIONS)

#######################################################
# An option that the user can select. Can accept condition to control when option is available for user.
# Usage:
#   plugin_option(<option_variable> "doc string" <initial value or boolean expression> [IF <condition>])
macro(plugin_option variable description value)
  set(__value ${value})
  set(__condition "")
  set(__varname "__value")
  list(APPEND TVM_ALL_OPTIONS ${variable})
  foreach(arg ${ARGN})
    if(arg STREQUAL "IF" OR arg STREQUAL "if")
      set(__varname "__condition")
    else()
      list(APPEND ${__varname} ${arg})
    endif()
  endforeach()
  unset(__varname)
  if("${__condition}" STREQUAL "")
    set(__condition 2 GREATER 1)
  endif()

  if(${__condition})
    if("${__value}" MATCHES ";")
      if(${__value})
        __plugin_option(${variable} "${description}" ON)
      else()
        __plugin_option(${variable} "${description}" OFF)
      endif()
    elseif(DEFINED ${__value})
      if(${__value})
        __plugin_option(${variable} "${description}" ON)
      else()
        __plugin_option(${variable} "${description}" OFF)
      endif()
    else()
      __plugin_option(${variable} "${description}" "${__value}")
    endif()
  else()
    unset(${variable} CACHE)
  endif()
endmacro()


set(IS_FALSE_PATTERN "^[Oo][Ff][Ff]$|^0$|^[Ff][Aa][Ll][Ss][Ee]$|^[Nn][Oo]$|^[Nn][Oo][Tt][Ff][Oo][Uu][Nn][Dd]$|.*-[Nn][Oo][Tt][Ff][Oo][Uu][Nn][Dd]$|^$")
set(IS_TRUE_PATTERN "^[Oo][Nn]$|^[1-9][0-9]*$|^[Tt][Rr][Uu][Ee]$|^[Yy][Ee][Ss]$|^[Yy]$")
