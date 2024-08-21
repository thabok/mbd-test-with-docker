import glob
import os

from btc_embedded import EPRestApi, util

# expect epp file matching the mdl/slx file name the 'model' directory
work_dir = os.path.abspath('model')
epp_file = next((epp_file for epp_file in glob.glob(os.path.join(work_dir, '*.epp'))
         if os.path.exists(epp_file[:-4] + '.mdl') or
            os.path.exists(epp_file[:-4] + '.slx')), None)
if not epp_file: raise Exception(f"No BTC EmbeddedPlatform Project found in workdir '{work_dir}'")

# BTC EmbeddedPlatform API object
ep = EPRestApi()

# run script
util.run_matlab_script(ep, os.path.join(work_dir, 'init_Wrapper_seat_heating_control.m'))

# Load a BTC EmbeddedPlatform profile (*.epp) and update it
ep.get('profiles/' + epp_file + '?discardCurrentProfile=true', message="Loading profile")

# Execute requirements-based tests
scopes = ep.get('scopes')
scope_uids = [scope['uid'] for scope in scopes]
toplevel_scope_uid = scope_uids[0]
rbt_exec_payload = {
    'UIDs': scope_uids,
   'data' : { 'execConfigNames' : [ 'SL MIL (TOPLEVEL)' ], 'forceExecute' : True }
}
response = ep.post('scopes/test-execution-rbt', rbt_exec_payload, message="Executing requirements-based tests")
util.print_rbt_results(response)

# Create project report
report = ep.post(f"scopes/{toplevel_scope_uid}/project-report", message="Creating test report")
# export project report to a file called 'report.html'
report_dir = os.path.join(work_dir, 'reports')
ep.post(f"reports/{report['uid']}", { 'exportPath': report_dir, 'newName': 'report' })

# Save *.epp
ep.put('profiles', { 'path': epp_file }, message="Saving profile")

print('Finished with workflow and create a test report here: ' + report_dir)