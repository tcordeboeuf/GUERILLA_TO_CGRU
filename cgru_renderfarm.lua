
-- This file implements the connection to the CGRU scheluder
-- It uses curl to connect to the CGRU server and post new jobs
-- See CGRU:submit for the main submitting code

-- CGRU renderfarm interface
class ("CGRU", "RenderFarm")

-- To add cgru command 
function CGRU:construct ()
	-- The CGRU server port
	LocalPlug (self, "CGRUpath", Plug.NoSerial, types.string, "C:/cgru-windows")
	-- The CGRU suspend
	LocalPlug (self, "isSuspended", Plug.NoSerial, types.bool, "True")
	-- The CGRU priority
	LocalPlug (self, "priority", Plug.NoSerial, types.int{min = 1,max = 100}, 50)
	-- The CGRU max running task at per jobs
	LocalPlug (self, "max_running_tasks", Plug.NoSerial, types.int{min = -1}, -1)
	-- The CGRU description
	LocalPlug (self, "description", Plug.NoSerial, types.string, "nothing")
end

function CGRU:gettemplate ()
	return
		{ "CGRU",
			{
				{ "job description", self.description },
				{ "is Suspended", self.isSuspended },
				{ "priority", self.priority },
				{ "max running tasks", self.max_running_tasks },
				{ "cgru Path", self.CGRUpath },
			}
		}
end

function CGRU:submit (jobs, opts)

CGRUdescription = self.description:get()
CGRUmaxRunningTask= self.max_running_tasks:get()
CGRUpath = self.CGRUpath:get()
CGRUname = opts.Name
CGRUpriority = self.priority:get()
CGRUsuspended = self.isSuspended:get()
CGRUjobDirectory = fs.expand (opts.JobsDirectory)
-- CGRUprefix = fs.expand (opts.FilePrefix)

-- CGRUframesText = opts.FrameRange
CGRUframes={}

local frames = rangetonumbers (opts.FrameRange)

	for k, frame in ipairs (frames) do
		table.insert(CGRUframes,k,frame)  
		--print (k)
		--print (frame)
		for k, job in ipairs (jobs) do
			CGRUid = tostring(job.JobId)
		end
	end
CGRUframesText = table.concat(CGRUframes,"|")


py = require 'python'
py.import "__main__".CGRUsend(CGRUname,CGRUpriority,CGRUframesText,CGRUsuspended,CGRUjobDirectory,CGRUid,CGRUdescription,CGRUpath,CGRUmaxRunningTask)
	
	return true
end

-- Declare CGRU
RenderFarm.declare (CGRU ())
