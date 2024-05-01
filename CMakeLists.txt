cmake_minimum_required(VERSION 3.27)
project(Sample)

add_application(Sample  # <- Name of the application, should match the name in flake.nix
    sample.c
    sample.r
    CREATOR '????'  # <- Creator code, should match the one in flake.nix
)

# Some options to make things smaller.
set_target_properties(Sample PROPERTIES COMPILE_OPTIONS -ffunction-sections)
set_target_properties(Sample PROPERTIES LINK_FLAGS "-Wl,-gc-sections")

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/Sample.bin DESTINATION .)