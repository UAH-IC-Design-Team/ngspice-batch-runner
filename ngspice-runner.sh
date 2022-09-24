#!/bin/sh

# Run ngspice 
ls -l /foss/data

#export ngspice_test=mos_curves.spice

# Create the path
export data_path=run_data_$(echo $AWS_BATCH_JOB_ARRAY_INDEX)_$(date +%s)
mkdir $data_path

# copy the spice test
cp -r /foss/data/$NGSPICE_TEST_PATH/$NGSPICE_TEST ./$data_path

cd $data_path
ngspice -b ./$NGSPICE_TEST -D iterator=$AWS_BATCH_JOB_ARRAY_INDEX
ls -l 
