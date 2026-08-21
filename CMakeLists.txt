#
# Copyright 2021 Bernd Pfrommer <bernd.pfrommer@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.16)
project(metavision_driver)

#
# ROS2 only. ROS1 support was removed from this fork.
#
if(DEFINED ENV{ROS_VERSION} AND NOT "$ENV{ROS_VERSION}" STREQUAL "2")
  message(SEND_ERROR
    "this fork supports ROS2 only, but ROS_VERSION=$ENV{ROS_VERSION}")
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/ROS2.cmake)
