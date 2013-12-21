find_program(Maven_EXECUTABLE mvn PATHS ENV M2_HOME PATH_SUFFIXES bin)
mark_as_advanced(Maven_EXECUTABLE)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Maven FOUND_VAR Maven_FOUND
                                        REQUIRED_VARS Maven_EXECUTABLE)

if(${Maven_FOUND})
    include(CMakeParseArguments)

    function(add_maven Directory Goal ResultFile)
        cmake_parse_arguments(_add_maven
            ""
            ""
            "DEPENDS;RESULT_DEPENDENCIES"
            ${ARGN}
        )
        set(RESULT_FILE "${CMAKE_CURRENT_SOURCE_DIR}/${Directory}/target/${ResultFile}")
        add_custom_command(OUTPUT ${RESULT_FILE}
                           COMMAND ${Maven_EXECUTABLE} ${Goal}
                           WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${Directory}
                           DEPENDS ${_add_maven_DEPENDS}
        )

        add_custom_target(${Directory} ALL DEPENDS ${RESULT_FILE})
        set_target_properties(${Directory} PROPERTIES
            TARGET_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${Directory}/target"
            RESULT_FILE_NAME "${ResultFile}"
            DEPENDENCIES "${_add_maven_RESULT_DEPENDENCIES}")
    endfunction()

    function(install_maven Directory Destination)
        cmake_parse_arguments(_install_maven
            ""
            "DEPENDENCIES_LOCATION"
            ""
            ${ARGN}
        )
        get_target_property(DEPENDENCIES ${Directory} DEPENDENCIES)
        if(NOT _install_maven_DEPENDENCIES_LOCATION)
            list(LENGTH DEPENDENCIES dependencies_length)
            if(${dependencies_length} GREATER 1)
                message(FATAL_ERROR "You have to privide DEPENDENCIES_LOCATION"
                                    " when you provide more than one"
                                    " RESULT_DEPENDENCIES in add_maven()")
            endif()
            set(_install_maven_DEPENDENCIES_LOCATION "${Destination}/${DEPENDENCIES}")
        endif()
        get_target_property(TARGET_DIR ${Directory} TARGET_DIR)
        get_target_property(RESULT_FILE_NAME ${Directory} RESULT_FILE_NAME)
        set(RESULT_FILE "${TARGET_DIR}/${RESULT_FILE_NAME}")
        install(FILES ${RESULT_FILE} DESTINATION ${Destination})

        foreach(directory IN LISTS DEPENDENCIES)
            list(APPEND DEPENDENCIES_PATHS "${TARGET_DIR}/${directory}/")
        endforeach()
        install(DIRECTORY ${DEPENDENCIES_PATHS} DESTINATION ${_install_maven_DEPENDENCIES_LOCATION})
    endfunction()
endif()
