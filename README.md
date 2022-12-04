# ngspice-batch-runner
The following repository handles running ngspice on AWS Batch.

## Use Instructions
1. Place the simulation in `xschem/simulation`
2. Build the docker container with `docker container build . -t ngspice-batch-runner:latest`
3. Execute with the correct enviroment variables

## ENVs
- AWS_BATCH_JOB_ARRAY_INDEX: This enviroment variable is injected by AWS when running array jobs to each child job. 
- NGSPICE_TEST: is the spice file
- NGSPICE_TEST_PATH: is the path to the spice file


## Repo Info
### Local Testing
A docker compose file has been created to handle local testing. It sets the enviroment variables as needed. 

### Execution
This container is based off of `hpretl/iic-osic-tools`. The `iic` container uses an endpoint, but providedes a nice internal bipass with the `-s` option which is used here rather than creating a new endpoint (might change later). 

The basch script `ngspice-runner.sh` handles moving the spice file to the volume and executing ngspice. 

# AWS Notes
- In order to perform the large, multi-bit simulations, AWS Batch was utilized to reduce the execution time; for the large 2048 step test, the execution time was reduce from ~170 to 6.5 hours by utilizing 256 containers. The details and code can be found here, but the large strokes are as follows:
- Ngspice simulations are set to only calculate 4-8 bits per simulation. The input values are shifted with an iterator variable passed into the command line with the -D flag. 
- The spice simulations are containerized in a docker container based on the iic-osic-tools container, using the -s flag to bypass the Docker entrypoint. 
- The new container is built using a github workflow and pushed to AWS Elastic Container Registry (ECR) on release.
- In AWS EC2, an Elastic File System (EFS) must be created to store all of the simulation data. The big key to remember is to open the Security Group inbound rule for Network File System traffic for port 2049
- In AWS a Batch Compute Environment is configured for AWS Fargate and a large vCPU cap (we used 5000). 
- An AWS Batch Job Queue is configured for a Managed Queue
- An AWS Batch Job Definition is created with the following settings:
		- Assign public IP - Needed to access ECR
		- Execution Role - Must have IAM to access root on EFS and ECR
		- Image - Use ECR URI
		- Environment Variables - Set for the correct simulation
		- Job role configuration - use the same IAM role as Execution Role
		- Mount Points Configuration - Set for the docker volume location
		- Volumes Configuration - Here enter the EFS file system ID and enable Transit encryption with selected job roll. 
		- Job Attempts - When spinning up large numbers of containers, often times a container will fail so retry is important.
- Finally Submit a new job using the previously defined job definition and job queue. Select Array Job and enter in the number of child jobs desired. This will inject an environment variable into the container which will be passed to the simulation. 
- Inside the container, a bash script copies the simulation to the docker volume and executes ngspice passing the AWS iterator environment variable to ngspice. 
When all the jobs have finished, AWS Data Sync is used to copy the data from the EFS into S3. From S3 the simulation data is synchronized for local evaluation.

