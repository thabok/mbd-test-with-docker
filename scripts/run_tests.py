import glob
import os
from datetime import datetime

from btc_embedded import EPRestApi, util

# expect epp file matching the mdl/slx file name the 'model' directory
work_dir = os.path.abspath('test')
epp_file = next((epp_file for epp_file in glob.glob(os.path.join(work_dir, '*.epp'))), None)
if not epp_file: raise Exception(f"No BTC EmbeddedPlatform Project found in workdir '{work_dir}'")
project_name = os.path.basename(epp_file)[:-4]

# BTC EmbeddedPlatform API object
ep = EPRestApi()

# Load a BTC EmbeddedPlatform profile (*.epp) and update it
ep.get('profiles/' + epp_file + '?discardCurrentProfile=true', message="Loading profile")
ep.put('architectures?performUpdateCheck=true', message="Updating model & generating code")

# Execute requirements-based tests
exec_start_time = datetime.now()
scopes = ep.get('scopes')
scope_uids = [scope['uid'] for scope in scopes]
toplevel_scope_uid = scope_uids[0]
rbt_exec_payload = {
    'UIDs': scope_uids,
   'data' : { 'execConfigNames' : [ 'SL MIL', 'SIL' ] }
}
response = ep.post('scopes/test-execution-rbt', rbt_exec_payload, message="Executing requirements-based tests")
util.print_rbt_results(response)
test_cases = ep.get('test-cases-rbt')

# Create project report
report = ep.post(f"scopes/{toplevel_scope_uid}/project-report", message="Creating test report")
# export project report to a file called 'report.html'
report_dir = os.path.abspath('reports')
ep.post(f"reports/{report['uid']}", { 'exportPath': report_dir, 'newName': 'report' })
# Dump JUnit XML report
util.dump_testresults_junitxml(
    rbt_results=response,
    scopes=scopes,
    test_cases=test_cases,
    start_time=exec_start_time,
    project_name=project_name,
    output_file=os.path.join(report_dir, 'test_results.xml')
)

# Save *.epp
ep.put('profiles', { 'path': epp_file }, message="Saving profile")

print('Finished with workflow and create a test report here: ' + report_dir)
