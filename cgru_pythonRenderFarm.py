import sys,os

# this is a simply proc to convert a number to a string number with digit 

def paddingNumber( number = 0, length = 0) :
	paddedStr = str(number)
	while len(paddedStr) < length :
		paddedStr = "0" + paddedStr
	return paddedStr

			
def CGRUsend(CGRUname,CGRUpriority,CGRUframesText,CGRUsuspended,CGRUjobDirectory,CGRUid,CGRUdescription,CGRUpath,CGRUmaxRunningTask):
	
	# CGRU declaration
	
	os.environ["CGRU_LOCATION"] = CGRUpath
	os.environ["PYTHONPATH"] = CGRUpath + "/lib/python;"+ CGRUpath +"/afanasy/python"
	os.environ["AF_ROOT"] = CGRUpath +"/afanasy"
	os.environ["CGRU_VERSION"] = "2.1.0"
	CGRUpath = CGRUpath.replace("/","\\")
	sys.path.append(CGRUpath + "\\lib\\python")
	sys.path.append(CGRUpath + "\\afanasy\\python")
	sys.path.append(CGRUpath + "\\utilities\\keeper")	
	guerillaEnv = os.getenv("GUERILLA")
	
	import af
	
	taskTab = []
	idPad = paddingNumber(int(CGRUid),3)
	frameTab = CGRUframesText.split("|")
	
	# set job description
	
	job = af.Job("G_" + CGRUname,'generic')
	job.setDescription(CGRUdescription)
	job.setPriority(int(CGRUpriority))
	
	# set block description
	
	block = af.Block("G_" + CGRUname,'generic')
	block.setWorkingDirectory(CGRUjobDirectory)
	block.setMaxRunningTasks(CGRUmaxRunningTask)
	
	if CGRUsuspended == "True" :
		job.offLine()
	

	# creating task from frames for working with guerilla frames nomenclature (1-100:2 etc...)
	
	for frames in frameTab :
	
		framesPad = paddingNumber(int(frames),5)
		filesNamesTab = [CGRUname,idPad,(framesPad + ".lua")]
		luaFilesNames = "_".join(filesNamesTab)
		command = "\"" + guerillaEnv + "/lua.exe\""  + " " + CGRUjobDirectory + "/" + luaFilesNames 
		
		cgruTask = af.Task(("frame : " + frames))
		cgruTask.setCommand(command)
		taskTab.append(cgruTask)
		
	block.tasks = taskTab
	job.blocks.append(block)
	job.output(1)
	job.send()
