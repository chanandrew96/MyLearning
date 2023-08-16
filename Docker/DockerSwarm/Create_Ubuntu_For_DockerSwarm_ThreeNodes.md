# !!! Not recommended to run docker in docker container !!!
# Use WSL2 to do so


# Testing Docker Swarm with 3 nodes
In this code, we will try to create 3 Ubuntu machine on Docker and connect them using docker Swarm
## Create Docker Container using Ubuntu image
  1. First, we pull the latest Ubuntu image to our local using command below  
     ``` shell
     docker pull ubuntu
     ```
  3. Use the Ubuntu to create the first container  
     - Set port number for the container in order to access the Ubuntu using SSH (SSH default use port 22)  
     - Use port 3500 for the first container SSH, the command below will map the port 22 inside the container to the port 3500 in host machine
     - Assign the container name to "UbuntuContainer1" using `--name`
     - Remember to place the Image name at the last / after all of the arguments  
     ``` shell
     docker run -it -p 127.0.0.1:3500:22 --name UbuntuContainer1 ubuntu
     docker run -it --cap-add SYS_ADMIN -p 127.0.0.1:3500:22 --name UbuntuContainer1 ubuntu 
     ```
  4. You will logged into the container using `root` account once the container created       
  5. Since the Ubuntu image is a clearn version without the components we gonna use in upcoming part, we need to install the components first
     We use `-y` option here to default all prompts answer is `yes`  
     - sudo
       ``` shell
       apt-get update && apt-get install -y sudo
       ```
     - systemctl
       ``` shell
       apt-get update && apt-get install -y systemctl
       ```
     - ssh
       ``` shell
       apt-get update && apt-get install -y ssh
       ```
     - docker
       ``` shell
       sudo apt update
       sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
       curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg
       sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 
       apt-cache policy docker-ce
       sudo apt install docker-ce -y
       ```
     - net-tools  
       ``` shell
       apt-get update && apt-get install -y net-tools
       ```
     - vim (editor)
       ``` shell
       apt-get update && apt-get install -y vim
       ```
  6.   After all components above installed, we could commit the container as a new image for creating another 2 container later  
       In command below, we commit an image called `CustomUbuntuImage` using container `UbuntuContainer1`       
       ``` shell
       docerk commit UbuntuContainer1 CustomUbuntuImage
       ```
## Initialize Docker Swarm in the container
  1. Start by starting Docker Service on container
      ``` shell
      service docker start
      ```
  2. Initialize Swarm in the first container  
      ``` shell
      docker swarm init
      ```
  4. 
