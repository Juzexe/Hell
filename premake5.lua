workspace "HellEngine"
	architecture "x64"
	startproject "HellEngine"

	configurations
	{
		"Debug",
		"Release",
		"Dist" 
	}

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

group "Dependencies"
	include "HellEngine/vendor/GLFW"
	include "HellEngine/vendor/Glad"
	include "HellEngine/vendor/imgui"
	--include "HellEngine/vendor/assimp"
	--include "HellEngine/vendor/bullet"

project "HellEngine"
	location "HellEngine"
	kind "ConsoleApp"
	language "C++"
	cppdialect "C++17"
	--staticruntime "off"


	targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

	pchheader "hellpch.h"
	pchsource "HellEngine/src/hellpch.cpp"

	files
	{
		"%{prj.name}/src/**.h",
		"%{prj.name}/src/**.cpp",
		"%{prj.name}/res/**.vert",
		"%{prj.name}/res/**.frag",
		"%{prj.name}/vendor/fmod/include/**.h",
		"%{prj.name}/vendor/fmod/include/**.hpp",
		"%{prj.name}/vendor/fmod/include/**.cpp"
	}

	defines
	{
		"_CRT_SECURE_NO_WARNINGS"
	}

	includedirs
	{
		"%{prj.name}/res",
		"%{prj.name}/src",
		"%{prj.name}/vendor/glm",
		"%{prj.name}/vendor/stb_image",
		"%{prj.name}/vendor/tinyobj",
		"%{prj.name}/vendor/GLFW/include",
		"%{prj.name}/vendor/Glad/include",
		"%{prj.name}/vendor/imgui",
		"%{prj.name}/vendor/imguizmo",
		"%{prj.name}/vendor/glm",
		"%{prj.name}/vendor/FbxSDK/include",
		"%{prj.name}/vendor/FbxSDK/include/fbxsdk",
		"%{prj.name}/vendor/bullet",
		"%{prj.name}/vendor/assimp/include",
		"%{prj.name}/vendor/rapidjson/include",
		"%{prj.name}/vendor/fmod/include"
	}


	libdirs 
	{ 
		"HellEngine/vendor/FbxSDK/lib/x64/debug",
		"HellEngine/vendor/bullet/bullet/lib/RelWithDebInfo",
		"HellEngine/vendor/fmod/lib/x64",
		"HellEngine/vendor/assimp/lib/"
	}
	
	
	links 
	{ 
		"GLFW",
		"Glad",
		"ImGui",
		"opengl32.lib",
		"libfbxsdk-md.lib",
		--"assimp",
		"fmodL_vc.lib",
		"fmod_vc.lib",
		"assimp-vc142-mt.lib",
		"Bullet3Dynamics_RelWithDebugInfo.lib",
		"BulletDynamics_RelWithDebugInfo.lib",
		"BulletCollision_RelWithDebugInfo.lib",
		"LinearMath_RelWithDebugInfo.lib"
	}

    files -- I WANT THESE BELOW TO NOT REQUIRE A THE PRECOMPILED HEADER 
	{
		"%{prj.name}/vendor/imgui/include/**.h",
		"%{prj.name}/vendor/imgui/include/**.cpp",
		"%{prj.name}/vendor/imguizmo/**.h",
		"%{prj.name}/vendor/imguizmo/**.cpp",
		"%{prj.name}/vendor/stb_image/**.h",
		"%{prj.name}/vendor/tinyobj/**.cpp",
		"%{prj.name}/vendor/tinyobj/**.h",
		"%{prj.name}/vendor/stb_image/**.cpp",
		"%{prj.name}/vendor/glm/glm/**.hpp",
		"%{prj.name}/vendor/glm/glm/**.inl"
	}

	filter { "files:HellEngine/vendor/**.cpp" }
    	flags { "NoPCH" }
	filter { "files:HellEngine/src/ImGuizmo/**.cpp" }
    	flags { "NoPCH" }
	filter { "files:HellEngine/src/ImGui/**.cpp" }
    	flags { "NoPCH" }
	filter { "files:HellEngine/src/Audio/extras/stb_vorbis.c" }
    	flags { "NoPCH" }

	filter "system:windows"
		systemversion "latest"

		defines
		{
			"HELL_PLATFORM_WINDOWS",
			"HELL_BUILD_DLL",
			"GLFW_INCLUDE_NONE"
		}

	filter "configurations:Debug"
		defines "HELL_DEBUG" 
		runtime "Debug"
		symbols "on"
      	buildoptions "/MDd"

	filter "configurations:Release"
		defines "HELL_RELEASE"
		runtime "Release"
		optimize "on"
        buildoptions "/MDd"

	filter "configurations:Dist"
		defines "HELL_DIST"
		runtime "Release"
		optimize "on"
        buildoptions "/MDd"