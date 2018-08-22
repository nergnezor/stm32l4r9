cmake_minimum_required(VERSION 3.0.0)
set(CMAKE_MODULE_PATH stm32-cmake/cmake)
set(STM32_CHIP STM32L4r9AI)
set(STM_BOARD "STM32L4R9I-Discovery")
# STM32F401xC
set(STM32Cube_DIR C:/Users/erikr/STM32Cube/Repository/STM32Cube_FW_L4_V1.12.0)

find_program(arm_gcc arm-none-eabi-gcc)
get_filename_component(toolchain_bin_dir ${arm_gcc} DIRECTORY)
get_filename_component(TOOLCHAIN_PREFIX ${toolchain_bin_dir} DIRECTORY)

if(STM32_CHIP)
include(stm32-cmake/cmake/gcc_stm32.cmake)
endif()

project(firmware C)
ENABLE_LANGUAGE(ASM)
include(CTest)
enable_testing()


FIND_PACKAGE(CMSIS REQUIRED)
FIND_PACKAGE(STM32HAL COMPONENTS dma dma2d dsi flash gfxmmu gpio i2c ltdc rng rtc tim REQUIRED)
FIND_PACKAGE(STM32LL COMPONENTS fmc sdmmc REQUIRED)
FIND_PACKAGE(STM32BSP COMPONENTS io ft3x67 mfxstm32l152 REQUIRED)



file(GLOB_RECURSE STemWin_src STemWin/*.c)
file(GLOB src Core/Src/*.c)
add_executable(firmware ${src} ${CMSIS_SOURCES} ${STM32HAL_SOURCES} ${STM32LL_SOURCES} ${STM32BSP_SOURCES} ${STemWin_src} ${STM32Cube_DIR}/Middlewares/ST/STemWin/OS/GUI_X.c)
target_include_directories(firmware PUBLIC ${CMSIS_INCLUDE_DIRS} ${STM32HAL_INCLUDE_DIR} ${STM32L_INCLUDE_DIR} ${STM32BSP_INCLUDE_DIR} Core/Inc STemWin/Target ${STM32Cube_DIR}/Middlewares/ST/STemWin/inc)
target_link_libraries(firmware ${STM32Cube_DIR}/Middlewares/ST/STemWin/Lib/STemWin540_CM4_GCC_ARGB.a)

# file(GLOB src Core/Src/*.c)
# add_library(STM32 ${src} ${CMSIS_SOURCES} ${STM32HAL_SOURCES} ${STM32LL_SOURCES} ${STM32BSP_SOURCES})
# target_include_directories(STM32 PUBLIC ${CMSIS_INCLUDE_DIRS} ${STM32HAL_INCLUDE_DIR} ${STM32L_INCLUDE_DIR} ${STM32BSP_INCLUDE_DIR})

# file(GLOB_RECURSE STemWin_src STemWin/*.c)
# add_executable(firmware  ${STemWin_src} ${STM32Cube_DIR}/Middlewares/ST/STemWin/OS/GUI_X.c)
# target_include_directories(firmware PUBLIC Core/Inc STemWin/Target ${STM32Cube_DIR}/Middlewares/ST/STemWin/inc)
# target_link_libraries(firmware STM32 ${STM32Cube_DIR}/Middlewares/ST/STemWin/Lib/STemWin540_CM4_GCC_ARGB.a)



string(REPLACE softfp hard CMAKE_C_FLAGS ${CMAKE_C_FLAGS})
string(REPLACE softfp hard CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS})
target_compile_definitions(firmware PRIVATE STM32L4R9xx USE_HAL_DRIVER USE_STM32L4R9I_DISCOVERY USE_IOEXPANDER BSP_LCD_COLOR_DEPTH_16_BPP)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)


STM32_SET_TARGET_PROPERTIES(${CMAKE_PROJECT_NAME})
STM32_ADD_HEX_BIN_TARGETS(${CMAKE_PROJECT_NAME})
STM32_PRINT_SIZE_OF_TARGETS(${CMAKE_PROJECT_NAME})
