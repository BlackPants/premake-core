--
-- tests/oven/test_filtering.lua
-- Test the project object configuration accessor.
-- Copyright (c) 2011-2014 Jason Perkins and the Premake project
--

	local suite = test.declare("oven_filtering")
	local oven = premake.oven
	local solution = premake.solution

	local sln, prj


--
-- Setup
--

	function suite.setup()
		sln = test.createsolution()
	end

	local function prepare()
		sln = test.getsolution(sln)
		prj = test.getproject(sln, 1)
	end


--
-- Test filtering by the selected action.
--

	function suite.onAction()
		_ACTION = "vs2012"
		filter { "action:vs2012" }
		defines { "USE_VS2012" }
		prepare()
		test.isequal({ "USE_VS2012" }, prj.defines)
	end

	function suite.onActionMismatch()
		_ACTION = "vs2010"
		filter { "action:vs2012" }
		defines { "USE_VS2012" }
		prepare()
		test.isequal({}, prj.defines)
	end


--
-- Test filtering on command line options.
--

	function suite.onOptionNoValue()
		_OPTIONS["release"] = ""
		filter { "options:release" }
		defines { "USE_RELEASE" }
		prepare()
		test.isequal({ "USE_RELEASE" }, prj.defines)
	end

	function suite.onOptionNoValueUnset()
		filter { "options:release" }
		defines { "USE_RELEASE" }
		prepare()
		test.isequal({ }, prj.defines)
	end

	function suite.onOptionWithValue()
		_OPTIONS["renderer"] = "opengl"
		filter { "options:renderer=opengl" }
		defines { "USE_OPENGL" }
		prepare()
		test.isequal({ "USE_OPENGL" }, prj.defines)
	end

	function suite.onOptionWithValueMismatch()
		_OPTIONS["renderer"] = "direct3d"
		filter { "options:renderer=opengl" }
		defines { "USE_OPENGL" }
		prepare()
		test.isequal({ }, prj.defines)
	end

	function suite.onOptionWithValueUnset()
		filter { "options:renderer=opengl" }
		defines { "USE_OPENGL" }
		prepare()
		test.isequal({ }, prj.defines)
	end
