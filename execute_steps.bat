setlocal
set PATH=%PATH%;C:\ProgramData\Anaconda3;C:\ProgramData\Anaconda3\scripts


call activate cdi_37
D:
cd Operations\Global_CDI\[base directory]\scripts

C:\ProgramData\Anaconda3\envs\cdi_37\python.exe STEP_0000_execute_all_steps.py

call conda deactivate
endlocal