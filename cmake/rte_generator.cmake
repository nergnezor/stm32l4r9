function(Rte_Generate config_xml config_src rte_includes)
  if (UNIX)
    find_program(PYTHON python2.7)
  else()
    find_program(PYTHON python)
  endif()

  set(gen_file_prefix "zfa_rte")

  set(rte_generated_src
    ${gen_file_prefix}_ports.c
    ${gen_file_prefix}_ports.h
    ${gen_file_prefix}.c
    ${gen_file_prefix}.h)
  
  add_custom_command(
    OUTPUT ${rte_generated_src}
    MAIN_DEPENDENCY ${config_xml}
    DEPENDS ${NSFW_ROOT_DIR}/application/components.xml ${NSFW_ROOT_DIR}/service/components.xml
    COMMAND ${PYTHON} generate_rte.py -c ${NSFW_ROOT_DIR}/application/components.xml -x ${NSFW_ROOT_DIR}/service/components.xml -r ${CMAKE_CURRENT_SOURCE_DIR}/${config_xml} -f ${gen_file_prefix} -n zfa -o ${CMAKE_CURRENT_BINARY_DIR} -i ${rte_includes}
    WORKING_DIRECTORY ${NSFW_ROOT_DIR}/../tools/rte_generator)

  add_library(rte_gen ${rte_generated_src} ${config_src})
  target_include_directories(rte_gen PUBLIC ${CMAKE_CURRENT_BINARY_DIR} .)
  target_link_libraries(rte_gen rte os_${NSFW_OS} application service)
endfunction()
