#!/usr/bin/env groovy
// This shared library is available at https://github.com/ROCmSoftwarePlatform/rocJENKINS/
@Library('rocJenkins') _

// This is file for internal AMD use.
// If you are interested in running your own Jenkins, please raise a github issue for assistance.

import com.amd.project.*
import com.amd.docker.*

////////////////////////////////////////////////////////////////////////
// Mostly generated from snippet generator 'properties; set job properties'
// Time-based triggers added to execute nightly tests, eg '30 2 * * *' means 2:30 AM
properties([
    pipelineTriggers([cron('0 1 * * *'), [$class: 'PeriodicFolderTrigger', interval: '5m']]),
    buildDiscarder(logRotator(
      artifactDaysToKeepStr: '',
      artifactNumToKeepStr: '',
      daysToKeepStr: '',
      numToKeepStr: '10')),
    disableConcurrentBuilds(),
    [$class: 'CopyArtifactPermissionProperty', projectNames: '*']
   ])


////////////////////////////////////////////////////////////////////////
import java.nio.file.Path;

ThrustCI:
{

    def Thrust = new rocProject('thrust')
    // customize for project

    // Define test architectures, optional rocm version argument is available
    def nodes = new dockerNodes(['gfx900', 'gfx906', 'gfx803'], Thrust)

    boolean formatCheck = false

    def compileCommand =
    {
        platform, project->

        project.paths.construct_build_prefix()
        def command = """
	    	    echo "Header Only Library"
                """

        platform.runCommand(this, command)
    }

    def testCommand =
    {
        platform, project->

        def command

        command = """#!/usr/bin/env bash
                set -x
                cd ${project.paths.project_build_prefix}/testing
		./cu_to_cpp.sh 
		./script_compile_testing_hcc.sh
		cd ..
		./script_run_hcc.sh testing/ 
            """

        platform.runCommand(this, command)
    }

    def packageCommand =
    {
        platform, project->

        def command = """
                      set -x
                      cd ${project.paths.project_build_prefix}/build/release
                      make package
                      rm -rf package && mkdir -p package
                      mv *.deb package/
                      dpkg -c package/*.deb
                      """

        platform.runCommand(this, command)
        platform.archiveArtifacts(this, """${project.paths.project_build_prefix}/build/release/package/*.deb""")
    }

    buildProject(Thrust, formatCheck, nodes.dockerArray, compileCommand, testCommand, packageCommand)

}
