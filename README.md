# areaDetectorDocker

Docker file for creating the simulated areaDetector driver.

To build the image:

`sudo docker build -t sim_ad .`

To run on Linux:

`sudo docker run --net=host -i sim_ad`

To run on MacOs:

`docker run -p 5064:5064 -p 5065:5065 -p 5064:5064/udp  -i sim_ad`

The IOC is set to start producing simulated data on start up.
The interesting PVs for data are:
* 13SIM1:image1:ArrayData       (data)
* 13SIM1:image1:ArraySize0_RBV  (image size in x)
* 13SIM1:image1:ArraySize1_RBV  (image size in y)

For control:
* 13SIM1:cam1:Acquire           (start/stop acquisition)
* 13SIM1:cam1:Acquire_RBV
* 13SIM1:cam1:AcquireTime       (acquisition time)
* 13SIM1:cam1:AcquireTime_RBV   
* 13SIM1:cam1:StatusMessage_RBV (status message)
* 13SIM1:cam1:DetectorState_RBV (detector state as a string)