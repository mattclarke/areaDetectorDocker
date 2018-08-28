# areaDetectorDocker

Docker file for creating the simulated areaDetector driver.

To build the image:

sudo docker build -t sim_ad .

To run on Linux:

sudo docker run --net=host -i sim_ad

To run on MacOs:

docker run -p 5064:5064 -p 5065:5065 -p 5064:5064/udp  -i sim_ad
