# ngspice-batch-runner
The following repository handles running ngspice on AWS Batch.

## Steps

### Docker Image 
- Build docker image from iic-osic-tools
- Copy data into container
- Set workdir to the volume mount point

### Run configuration
- Mount EFS volume to container
- Copy spice file into volume
- Set entrypoint and command to run ngspice
