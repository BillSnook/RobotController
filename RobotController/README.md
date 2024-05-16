#  Robot Controller app

Communicates with a program on the Pi that controls hardware on the robot tank.
Such as the motors and the sensors, notably the new tof depth camera.

This section will summarize the services we need from the robot.


Commands from controller to robot

    Overview
  For simplicity, our UI will use a smaller set of speeds than the motor can provide, using a speed index.
  The speed index table uses a small (8) range of speeds that the device recognizes for forward and reverse.
  These speeds translate on the device into the actual value sent to the motor controller for each track.
  The motor controller accepts values from 0 to 4095 and the index has values of 0 through 8.
  0 is stopped, 1 is slowest speed, 8 is fastest speed. For reverse, -1 is slowest, -8 is fastest.
  This allows us to control speed in 8 index increments which is much simpler to manage.
  Motors and motor controllers are slightly different on each device and vary slightly in response to each value.
  This requires some calibration to set appropriate motor controller values for each index value.
  It is also important to have the speed of both tracks match to keep the vehicle on a mostly straight path.
  This needs to be determined experimentally during calibration and may need to be repeated occasionally.
  
  We accomplish this by keeping an index file on each device with appropriate settings along with a working copy.
  If no file is found as will happen at initial startup, a default one is created with reasonable values.
  This file is loaded as the working copy and is used in real time when the controller sends index values.
  The file lists each index, 0 through 8 forward, 0 through 8 reverse, with its left and right track values.
  This is transferred to the controller when the calibration page is opened, so it can be displayed and updated.
  As calibration changes are made, the index and new value is sent to the device to update the working index copy.
  If the changes are acceptable, the calibration page can ask that the working copy be saved to the file.
  
  To help in initial setups, if we set the slowest and fastest speed, we can fill in a linear table from those.
  

    General
Get robot status - hardware, sensors
Set robot mode - only test mode for now

Safe shutdown command

    Movement control
  Calibrate motor speeds
  
  Need to link with device speed index table which is used to control speeds in realtime
    Fetch from device from working copy
    Update individual speed entries in working copy
    Command device to save to working copy
  We send the list from device to controller as a single transaction
  Each individual controller change (index, newValue) is sent to the device
  
Setup speed ranges
    D - Get working copy of the speed table from robot
    E - modify an entry, sending index and new value to the robot
    d - Save current working copy to file for future use
    e - Fill in speed table from slowest and fastest entries, forward and reverse
Set left track speed
Set right track speed
Set straight speed
    G - set speed to index sent


    Depth camera
Get tof camera working


    Maintainence
Diagnostics
Test/development support



    Operations
Stop
Test
Recon
Hunt
Evade
