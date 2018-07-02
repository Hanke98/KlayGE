ADD_DEFINITIONS(-DUNICODE -D_UNICODE)

IF(CMAKE_C_COMPILER_ID MATCHES MSVC)
	SET(KLAYGE_COMPILER_NAME "vc")
	SET(KLAYGE_COMPILER_MSVC TRUE)
	IF(MSVC_VERSION GREATER 1900)
		SET(KLAYGE_COMPILER_VERSION "141")
	ELSE()
		SET(KLAYGE_COMPILER_VERSION "140")
	ENDIF()

	SET(CMAKE_CXX_FLAGS "/W4 /WX /EHsc /MP /bigobj /Zc:throwingNew /Zc:strictStrings /Zc:rvalueCast /Gw")
	IF(MSVC_VERSION GREATER 1910)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /std:c++17")
	ELSE()
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /std:c++14")
	ENDIF()
	IF(MSVC_VERSION GREATER 1900)
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /permissive-")

		IF(MSVC_VERSION GREATER 1910)
			IF(KLAYGE_PLATFORM_WINDOWS_STORE OR (KLAYGE_ARCH_NAME STREQUAL "arm64"))
				SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Zc:twoPhase-")
			ENDIF()
		ENDIF()
	ENDIF()
	SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /DKLAYGE_SHIP /fp:fast /Ob2 /GL /Qpar")
	SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /fp:fast /Ob2 /GL /Qpar")
	SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /fp:fast /Ob1 /GL /Qpar")
	IF((MSVC_VERSION GREATER 1912) AND (KLAYGE_ARCH_NAME STREQUAL "x64"))
		SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Qspectre")
	ENDIF()

	SET(CMAKE_EXE_LINKER_FLAGS "/WX /pdbcompress")
	SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "/DEBUG:FASTLINK")
	SET(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "/DEBUG:FASTLINK /INCREMENTAL:NO /LTCG:incremental /OPT:REF /OPT:ICF")
	SET(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "/INCREMENTAL:NO /LTCG /OPT:REF /OPT:ICF")
	SET(CMAKE_EXE_LINKER_FLAGS_RELEASE "/INCREMENTAL:NO /LTCG /OPT:REF /OPT:ICF")

	SET(CMAKE_SHARED_LINKER_FLAGS "/WX /pdbcompress")
	SET(CMAKE_SHARED_LINKER_FLAGS_DEBUG "/DEBUG:FASTLINK")
	SET(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "/DEBUG:FASTLINK /INCREMENTAL:NO /LTCG:incremental /OPT:REF /OPT:ICF")
	SET(CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL "/INCREMENTAL:NO /LTCG /OPT:REF /OPT:ICF")
	SET(CMAKE_SHARED_LINKER_FLAGS_RELEASE "/INCREMENTAL:NO /LTCG /OPT:REF /OPT:ICF")

	SET(CMAKE_MODULE_LINKER_FLAGS "/WX /pdbcompress")
	SET(CMAKE_MODULE_LINKER_FLAGS_RELEASE "/INCREMENTAL:NO /LTCG")
	SET(CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL "/INCREMENTAL:NO /LTCG")

	SET(CMAKE_STATIC_LINKER_FLAGS_RELEASE "${CMAKE_STATIC_LINKER_FLAGS_RELEASE} /LTCG")
	SET(CMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO} /LTCG:incremental")
	SET(CMAKE_STATIC_LINKER_FLAGS_MINSIZEREL "${CMAKE_STATIC_LINKER_FLAGS_MINSIZEREL} /LTCG")

	IF(KLAYGE_ARCH_NAME MATCHES "x86")
		SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /arch:SSE")
		SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /arch:SSE")
		SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /arch:SSE")

		SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} /LARGEADDRESSAWARE")
		SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} /LARGEADDRESSAWARE")
	ENDIF()

	ADD_DEFINITIONS(-DWIN32 -D_WINDOWS)
	IF(KLAYGE_ARCH_NAME MATCHES "arm")
		ADD_DEFINITIONS(-D_ARM_WINAPI_PARTITION_DESKTOP_SDK_AVAILABLE=1)

		IF(KLAYGE_PLATFORM_WINDOWS_DESKTOP)
			SET(ADDITIONAL_LIBS_FOR_ARM "gdi32.lib ole32.lib oleaut32.lib comdlg32.lib advapi32.lib")
			SET(CMAKE_C_STANDARD_LIBRARIES "${CMAKE_C_STANDARD_LIBRARIES} ${ADDITIONAL_LIBS_FOR_ARM}")
			SET(CMAKE_CXX_STANDARD_LIBRARIES "${CMAKE_CXX_STANDARD_LIBRARIES} ${ADDITIONAL_LIBS_FOR_ARM}")
		ENDIF()
	ENDIF()

	IF(KLAYGE_PLATFORM_WINDOWS_STORE)
		SET(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /INCREMENTAL:NO")
		SET(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL:NO")
		SET(CMAKE_SHARED_LINKER_FLAGS_DEBUG "${CMAKE_SHARED_LINKER_FLAGS_DEBUG} /INCREMENTAL:NO")
		SET(CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL:NO")
	ELSE()
		SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /GS-")
		SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /GS-")
		SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /GS-")

		SET(CMAKE_STATIC_LINKER_FLAGS "/WX")
	ENDIF()

	SET(CMAKE_C_FLAGS ${CMAKE_CXX_FLAGS})
ELSE()
	IF(CMAKE_C_COMPILER_ID MATCHES Clang)
		SET(KLAYGE_COMPILER_NAME "clang")
		SET(KLAYGE_COMPILER_CLANG TRUE)
		IF(MSVC)
			SET(KLAYGE_COMPILER_CLANGC2 TRUE)
		ENDIF()
	ELSEIF(MINGW)
		SET(KLAYGE_COMPILER_NAME "mgw")
		SET(KLAYGE_COMPILER_GCC TRUE)
	ELSE()
		SET(KLAYGE_COMPILER_NAME "gcc")
		SET(KLAYGE_COMPILER_GCC TRUE)
	ENDIF()
	IF((NOT MSVC) AND KLAYGE_PLATFORM_WINDOWS)
		ADD_DEFINITIONS(-D_WIN32_WINNT=0x0601 -DWINVER=_WIN32_WINNT)
	ENDIF()

	IF(KLAYGE_COMPILER_CLANG)
		EXECUTE_PROCESS(COMMAND ${CMAKE_C_COMPILER} --version OUTPUT_VARIABLE CLANG_VERSION)
		STRING(REGEX MATCHALL "[0-9]+" CLANG_VERSION_COMPONENTS ${CLANG_VERSION})
		LIST(GET CLANG_VERSION_COMPONENTS 0 CLANG_MAJOR)
		LIST(GET CLANG_VERSION_COMPONENTS 1 CLANG_MINOR)
		SET(KLAYGE_COMPILER_VERSION ${CLANG_MAJOR}${CLANG_MINOR})
	ELSE()
		EXECUTE_PROCESS(COMMAND ${CMAKE_C_COMPILER} -dumpfullversion OUTPUT_VARIABLE GCC_VERSION)
		STRING(REGEX MATCHALL "[0-9]+" GCC_VERSION_COMPONENTS ${GCC_VERSION})
		LIST(GET GCC_VERSION_COMPONENTS 0 GCC_MAJOR)
		LIST(GET GCC_VERSION_COMPONENTS 1 GCC_MINOR)
		SET(KLAYGE_COMPILER_VERSION ${GCC_MAJOR}${GCC_MINOR})
	ENDIF()

	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -W -Wall -Werror -fpic")
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -W -Wall -Werror -fpic")
	IF(NOT (ANDROID OR IOS))
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=core2 -msse2")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=core2 -msse2")
	ENDIF()
	IF(KLAYGE_COMPILER_CLANG)
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")
		IF(MSVC)
			SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
		ELSE()
			SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1z")
		ENDIF()
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-inconsistent-missing-override -Wno-missing-braces")
	ELSE()
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1z")
	ENDIF()
	SET(CMAKE_CXX_FLAGS_DEBUG "-DDEBUG -g -O0")
	SET(CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG -O2 -DKLAYGE_SHIP")
	SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-DNDEBUG -g -O2")
	SET(CMAKE_CXX_FLAGS_MINSIZEREL "-DNDEBUG -Os")
	IF(KLAYGE_ARCH_NAME STREQUAL "x86")
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
		IF(NOT MSVC)
			SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -m32")
			SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -m32")
			SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -m32")
			IF(KLAYGE_PLATFORM_WINDOWS)
				SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--large-address-aware")
				SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -Wl,--large-address-aware")
				SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--large-address-aware")

				SET(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} --target=pe-i386")
			ELSE()
				SET(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} --target=elf32-i386")
			ENDIF()
		ENDIF()
	ELSEIF((KLAYGE_ARCH_NAME STREQUAL "x64") OR (KLAYGE_ARCH_NAME STREQUAL "x86_64"))
		SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m64")
		SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m64")
		IF(NOT MSVC)
			SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -m64")
			SET(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_MODULE_LINKER_FLAGS} -m64")
			SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -m64")
			IF(KLAYGE_PLATFORM_WINDOWS)
				SET(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} --target=pe-x86-64")
			ELSE()
				SET(CMAKE_RC_FLAGS "${CMAKE_RC_FLAGS} --target=elf64-x86-64")
			ENDIF()
		ENDIF()
	ENDIF()
	IF(NOT MSVC)
		SET(CMAKE_SHARED_LINKER_FLAGS_RELEASE "-s")
		SET(CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL "-s")
		SET(CMAKE_MODULE_LINKER_FLAGS_RELEASE "-s")
		SET(CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL "-s")
		SET(CMAKE_EXE_LINKER_FLAGS_RELEASE "-s")
		SET(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "-s")
	ENDIF()
ENDIF()

SET(CMAKE_C_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG})
SET(CMAKE_C_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE})
SET(CMAKE_C_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO})
SET(CMAKE_C_FLAGS_MINSIZEREL ${CMAKE_CXX_FLAGS_MINSIZEREL})
IF(KLAYGE_COMPILER_MSVC)
	SET(RTTI_FLAG "/GR")
	SET(NO_RTTI_FLAG "/GR-")
ELSE()
	SET(RTTI_FLAG "-frtti")
	IF(KLAYGE_COMPILER_CLANGC2)
		SET(NO_RTTI_FLAG "")
	ELSE()
		SET(NO_RTTI_FLAG "-fno-rtti")
	ENDIF()
ENDIF()
SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} ${RTTI_FLAG}")
SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} ${NO_RTTI_FLAG}")
SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} ${NO_RTTI_FLAG}")
SET(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} ${NO_RTTI_FLAG}")
IF(KLAYGE_PLATFORM_ANDROID)
	SET(ANDROID_API_DEFINITION "-D__ANDROID_API__=${ANDROID_NATIVE_API_LEVEL}")
	SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${ANDROID_API_DEFINITION}")
	SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${ANDROID_API_DEFINITION}")

	# TODO: Figure out why LINK_DIRECTORIES doesn't work for ${ANDROID_STL_LIBRARY_DIRS}
	SET(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -L${ANDROID_STL_LIBRARY_DIRS}")
ENDIF()

SET(KLAYGE_OUTPUT_SUFFIX _${KLAYGE_COMPILER_NAME}${KLAYGE_COMPILER_VERSION})

IF(MSVC)
	# create vcproj.user file for Visual Studio to set debug working directory
	FUNCTION(CREATE_VCPROJ_USERFILE TARGETNAME)
		SET(SYSTEM_NAME $ENV{USERDOMAIN})
		SET(USER_NAME $ENV{USERNAME})

		CONFIGURE_FILE(
			${KLAYGE_ROOT_DIR}/cmake/VisualStudio2010UserFile.vcxproj.user.in
			${CMAKE_CURRENT_BINARY_DIR}/${TARGETNAME}.vcxproj.user
			@ONLY
		)
	ENDFUNCTION()
ENDIF()
IF(KLAYGE_PLATFORM_DARWIN OR KLAYGE_PLATFORM_IOS)
	# create .xcscheme file for Xcode to set debug working directory
	FUNCTION(CREATE_XCODE_USERFILE PROJECTNAME TARGETNAME)
		IF(KLAYGE_PLATFORM_DARWIN OR KLAYGE_PLATFORM_IOS)
			SET(SYSTEM_NAME $ENV{USERDOMAIN})
			SET(USER_NAME $ENV{USER})

			CONFIGURE_FILE(
				${KLAYGE_ROOT_DIR}/cmake/xcode.xcscheme.in
				${PROJECT_BINARY_DIR}/${PROJECTNAME}.xcodeproj/xcuserdata/${USER_NAME}.xcuserdatad/xcschemes/${TARGETNAME}.xcscheme
				@ONLY
			)
		ENDIF()
	ENDFUNCTION()
ENDIF()
	
FUNCTION(CREATE_PROJECT_USERFILE PROJECTNAME TARGETNAME)
	IF(MSVC)
		CREATE_VCPROJ_USERFILE(${TARGETNAME})
	ELSEIF(KLAYGE_PLATFORM_DARWIN OR KLAYGE_PLATFORM_IOS)
		CREATE_XCODE_USERFILE(${PROJECTNAME} ${TARGETNAME})
	ENDIF()
ENDFUNCTION()

FUNCTION(ADD_PRECOMPILED_HEADER TARGET_NAME PRECOMPILED_HEADER PRECOMPILED_HEADER_PATH PRECOMPILED_SOURCE)
	IF(KLAYGE_COMPILER_MSVC)
		ADD_MSVC_PRECOMPILED_HEADER(${TARGET_NAME} ${PRECOMPILED_HEADER} ${PRECOMPILED_SOURCE})
	ELSEIF(NOT KLAYGE_COMPILER_CLANG)
		# TODO: Enables PCH with Clang
		IF(NOT KLAYGE_PLATFORM_LINUX)
			# TODO: PCH under Linux causes an error with wine
			ADD_GCC_PRECOMPILED_HEADER(${TARGET_NAME} ${PRECOMPILED_HEADER} ${PRECOMPILED_HEADER_PATH})
		ENDIF()
	ENDIF()
ENDFUNCTION()

FUNCTION(ADD_MSVC_PRECOMPILED_HEADER TARGET_NAME PRECOMPILED_HEADER PRECOMPILED_SOURCE)
	GET_FILENAME_COMPONENT(PRECOMPILED_BASE_NAME ${PRECOMPILED_HEADER} NAME_WE)
	SET(PCHOUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_CFG_INTDIR}/${PRECOMPILED_BASE_NAME}.pch")

	SET_TARGET_PROPERTIES(${TARGET_NAME} PROPERTIES COMPILE_FLAGS "/Yu\"${PRECOMPILED_HEADER}\" /Fp\"${PCHOUTPUT}\"" OBJECT_DEPENDS "${PCHOUTPUT}")
	SET_SOURCE_FILES_PROPERTIES(${PRECOMPILED_SOURCE} PROPERTIES COMPILE_FLAGS "/Yc\"${PRECOMPILED_HEADER}\" /Fp\"${PCHOUTPUT}\"" OBJECT_OUTPUTS "${PCHOUTPUT}")
ENDFUNCTION()

FUNCTION(ADD_GCC_PRECOMPILED_HEADER TARGET_NAME PRECOMPILED_HEADER PRECOMPILED_HEADER_PATH)
	SET(CXX_COMPILE_FLAGS ${CMAKE_CXX_FLAGS})

	SET(HEADER "${PRECOMPILED_HEADER_PATH}/${PRECOMPILED_HEADER}")
	GET_FILENAME_COMPONENT(PRECOMPILED_HEADER_NAME ${HEADER} NAME)
	GET_FILENAME_COMPONENT(PRECOMPILED_HEADER_PATH ${HEADER} PATH)

	SET(OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/${PRECOMPILED_HEADER_NAME}.gch")
	IF(CMAKE_BUILD_TYPE)
		SET(PCH_OUTPUT "${OUT_DIR}/${CMAKE_BUILD_TYPE}.c++")
		STRING(TOUPPER ${CMAKE_BUILD_TYPE} UPPER_CMAKE_BUILD_TYPE)
		LIST(APPEND CXX_COMPILE_FLAGS ${CMAKE_CXX_FLAGS_${UPPER_CMAKE_BUILD_TYPE}})
	ELSE()
		SET(PCH_OUTPUT "${OUT_DIR}/default.c++")
	ENDIF()

	ADD_CUSTOM_COMMAND(OUTPUT ${OUT_DIR}
		COMMAND ${CMAKE_COMMAND} -E make_directory ${OUT_DIR}
	)

	GET_DIRECTORY_PROPERTY(DIRECTORY_FLAGS INCLUDE_DIRECTORIES)

	SET(CURRENT_BINARY_DIR_INCLUDED_BEFORE_PATH FALSE)
	FOREACH(item ${DIRECTORY_FLAGS})
		IF(${item} STREQUAL ${PRECOMPILED_HEADER_PATH} AND NOT CURRENT_BINARY_DIR_INCLUDED_BEFORE_PATH)
			MESSAGE(FATAL_ERROR
				"This is the ADD_GCC_PRECOMPILED_HEADER function. "
				"CMAKE_CURREN_BINARY_DIR has to mentioned at INCLUDE_DIRECTORIES's argument list before ${PRECOMPILED_HEADER_PATH}, where ${PRECOMPILED_HEADER_NAME} is located"
			)
		ENDIF()

		IF(${item} STREQUAL ${CMAKE_CURRENT_BINARY_DIR})
			SET(CURRENT_BINARY_DIR_INCLUDED_BEFORE_PATH TRUE)
		ENDIF()

		LIST(APPEND CXX_COMPILE_FLAGS "-I\"${item}\"")
	ENDFOREACH(item)

	GET_DIRECTORY_PROPERTY(DIRECTORY_FLAGS COMPILE_DEFINITIONS)
	FOREACH(item ${DIRECTORY_FLAGS})
		LIST(APPEND CXX_COMPILE_FLAGS "-D${item}")
	ENDFOREACH()

	SEPARATE_ARGUMENTS(CXX_COMPILE_FLAGS)

	ADD_CUSTOM_COMMAND(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${PRECOMPILED_HEADER_NAME}
		COMMAND ${CMAKE_COMMAND} -E copy ${HEADER} ${CMAKE_CURRENT_BINARY_DIR}/${PRECOMPILED_HEADER_NAME}
	)

	SET(PCHOUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${PRECOMPILED_HEADER_NAME})
	
	ADD_CUSTOM_COMMAND(OUTPUT ${PCH_OUTPUT}
		COMMAND ${CMAKE_CXX_COMPILER} ${CXX_COMPILE_FLAGS} -Wno-error -x c++-header -o ${PCH_OUTPUT} ${HEADER} DEPENDS ${HEADER} ${OUT_DIR} ${CMAKE_CURRENT_BINARY_DIR}/${PRECOMPILED_HEADER_NAME}
	)
	ADD_CUSTOM_TARGET(${TARGET_NAME}_gch
		DEPENDS ${PCH_OUTPUT}
	)
	ADD_DEPENDENCIES(${TARGET_NAME} ${TARGET_NAME}_gch)

	SET_TARGET_PROPERTIES(${TARGET_NAME} PROPERTIES COMPILE_FLAGS "-include ${PRECOMPILED_HEADER_NAME} -Winvalid-pch" OBJECT_DEPENDS "${PCHOUTPUT}")
ENDFUNCTION()
