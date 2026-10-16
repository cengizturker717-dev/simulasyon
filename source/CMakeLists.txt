cmake_minimum_required(VERSION 3.21)
project(SolidSimNative VERSION 0.3 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
find_package(Qt6 6.8 REQUIRED COMPONENTS Quick QuickControls2 Quick3D)
qt_standard_project_setup(REQUIRES 6.8)
qt_add_executable(SolidSimNative WIN32 main.cpp Motion.h Pcni.h StockGeometry.h LiveCni.h MachineData.h Machining.h VigorProfile.h ToolAngles.h)
qt_add_qml_module(SolidSimNative URI Poyraz.Native VERSION 1.0 SOURCES GridInstances.h DrillInstances.h MagazineInstances.h QML_FILES Main.qml Machine.qml Vigor.qml CameraNavigation.qml)
target_link_libraries(SolidSimNative PRIVATE Qt6::Quick Qt6::QuickControls2 Qt6::Quick3D)

# Offline lossless mesh cleanup, compiled against the pinned Qt 6.8 exporter.
add_executable(OptimizeControllerMeshes EXCLUDE_FROM_ALL tools/optimize_meshes.cpp)
target_link_libraries(OptimizeControllerMeshes PRIVATE Qt6::Quick3DUtilsPrivate)
add_executable(VigorVariants EXCLUDE_FROM_ALL tools/vigor_variants.cpp)
target_link_libraries(VigorVariants PRIVATE Qt6::Quick3DUtilsPrivate)
add_executable(MergeSceneMeshes EXCLUDE_FROM_ALL tools/merge_scene_meshes.cpp)
target_link_libraries(MergeSceneMeshes PRIVATE Qt6::Quick3DUtilsPrivate)
add_executable(MeshIO EXCLUDE_FROM_ALL tools/mesh_io.cpp)
target_link_libraries(MeshIO PRIVATE Qt6::Quick3DUtilsPrivate)
find_package(Qt6 6.8 COMPONENTS OpenGL)
if(TARGET Qt6::OpenGL)
    add_executable(VisibilityCull EXCLUDE_FROM_ALL tools/visibility_cull.cpp)
    target_link_libraries(VisibilityCull PRIVATE Qt6::Gui Qt6::OpenGL)
endif()

# Runtime regressions against the frozen stock algorithm; not deployed.
qt_add_executable(RuntimeChecks EXCLUDE_FROM_ALL tools/runtime_checks.cpp Motion.h StockGeometry.h)
target_link_libraries(RuntimeChecks PRIVATE Qt6::Quick Qt6::Quick3D)

qt_add_executable(MachiningChecks EXCLUDE_FROM_ALL tools/machining_checks.cpp Motion.h Pcni.h StockGeometry.h Machining.h)
target_link_libraries(MachiningChecks PRIVATE Qt6::Quick Qt6::Quick3D)
qt_add_executable(ProfileChecks EXCLUDE_FROM_ALL tools/profile_checks.cpp VigorProfile.h Motion.h Pcni.h StockGeometry.h Machining.h)
target_link_libraries(ProfileChecks PRIVATE Qt6::Quick Qt6::Quick3D)

qt_add_executable(LiveCniChecks EXCLUDE_FROM_ALL tools/live_cni_checks.cpp LiveCni.h)
target_link_libraries(LiveCniChecks PRIVATE Qt6::Core)

qt_add_executable(PerformanceChecks EXCLUDE_FROM_ALL tools/performance_checks.cpp tools/reference_machining.h tools/reference_pcni.h Motion.h Pcni.h StockGeometry.h Machining.h)
target_link_libraries(PerformanceChecks PRIVATE Qt6::Quick Qt6::Quick3D)

qt_add_executable(VCutChecks EXCLUDE_FROM_ALL tools/vcut_checks.cpp StockGeometry.h Pcni.h)
target_link_libraries(VCutChecks PRIVATE Qt6::Quick Qt6::Quick3D)
