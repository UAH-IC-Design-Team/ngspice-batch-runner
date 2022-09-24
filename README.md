# ngspice-batch-runner
The following repository handles running ngspice on AWS Batch.

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

## Design Steps

### Docker Image 
- Build docker image from iic-osic-tools
- Copy data into container
- Set workdir to the volume mount point

### Run configuration
- Mount EFS volume to container
- Copy spice file into volume
- Set entrypoint and command to run ngspice
