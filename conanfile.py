import os
from conans import ConanFile, CMake, tools


class H3DAPIConan(ConanFile):
    name = "h3dapi"
    version = "2.4-beta"
    url = "https://github.com/ulricheck/conan-h3dapi.git"

    short_paths = True
    settings = "os", "compiler", "build_type", "arch"
    generators = "cmake"
    exports = "FindHAPI.cmake"
    options = {"shared": [True, False]}
    default_options = "shared=True"

    requires = (
        "h3dutil/1.4-beta@camposs/stable",
        "hapi/1.4-beta@camposs/stable",
        "glew/[>=2.1.0]/camposs/stable",
        )

    # exports = "*"
    def requirements(self):
        if self.settings.os == "Windows":
            self.requires("h3dapi_windows_dependencies/[>=2.3]@camposs/stable")

    def imports(self):
        #needed to replace the existing findXXX.cmake scripts from H3D common modules
        self.copy("FindH3DUtil.cmake", src="cmake", dst="source/build/localModules", root_package="h3dutil")
        self.copy("FindHAPI.cmake", src="cmake", dst="source/build/localModules", root_package="hapi")

    def source(self):
        repo_url = "https://www.h3dapi.org:8090/H3DAPI/trunk/H3DAPI/"
        self.run("svn checkout %s source" % repo_url)
        tools.replace_in_file("source/build/CMakeLists.txt", "project( H3DAPI )", '''project( H3DAPI )
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()
MESSAGE(STATUS "Using External Root: $ENV{H3D_EXTERNAL_ROOT}")
''')

        tools.replace_in_file("source/H3DLoad/build/CMakeLists.txt", 
            """set( CMAKE_MODULE_PATH "${H3DLoad_SOURCE_DIR}/../../build/modules" )""", 
            """set( CMAKE_MODULE_PATH "${H3DLoad_SOURCE_DIR}/../../build/localModules" "${H3DLoad_SOURCE_DIR}/../../build/modules" )""")

        tools.replace_in_file("source/H3DViewer/build/CMakeLists.txt", 
            """set( CMAKE_MODULE_PATH "${H3DViewer_SOURCE_DIR}/modules" "${H3DViewer_SOURCE_DIR}/../../build/modules" )""", 
            """set( CMAKE_MODULE_PATH "${H3DViewer_SOURCE_DIR}/../../build/localModules" "${H3DViewer_SOURCE_DIR}/modules" "${H3DViewer_SOURCE_DIR}/../../build/modules" )""")

       
    def build(self):
        cmake = CMake(self)
        cmake.definitions["BUILD_SHARED_LIBS"] = self.options.shared
        cmake.configure(source_dir=os.path.join("source", "build"))
        cmake.build()
        cmake.install()

    def package(self):
        self.copy(pattern='*.h', dst="include", src="source/include", keep_path=True)
        self.copy(pattern='FindH3DAPI.cmake', dst="cmake", keep_path=False)
        self.copy(pattern='*', src="source/examples", dst="examples", keep_path=False)

    def package_info(self):
        libfolder = 'lib'
        if self.settings.os == "Windows":
            if self.settings.arch == "x86":
                libfolder = "lib32"
            else:
                libfolder = "lib64"

        self.cpp_info.libs = tools.collect_libs(self, folder=libfolder)
        self.cpp_info.libdirs = [libfolder]
