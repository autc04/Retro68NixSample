cmake_minimum_required(VERSION 3.27)
project(Sample)

add_application(Sample
    sample.c
    sample.r)

# Some options to make things smaller.
set_target_properties(Sample PROPERTIES COMPILE_OPTIONS -ffunction-sections)
set_target_properties(Sample PROPERTIES LINK_FLAGS "-Wl,-gc-sections")

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/Sample.bin DESTINATION .)