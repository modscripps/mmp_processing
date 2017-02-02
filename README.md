# mmp_processing

mymatlab/mmp:

-This is where all the processing scripts are contained.

-Before doing anything else, update "mmpfolders" so that it points to 
the right directories, then run "set_mmp_paths". 

mymatlab/mmp/batchprocess:

-"batchprocess4WW14_mmp" is the most recent batch processing, see comments
for details.

-"copyDataAndRunBatchProcess" can be edited to streamline data transfer and
processing.

database:

-This is where the calibration information for each MMP is contained.

-"config" has the configuration of sensors on each instruments. "cal" has 
the calibration coefficients for the sensors.

-When sensors are swapped out, make sure the corresponding "config" file is
updated. The most common ones to need replacing are shear probes (V) and 
thermistors (TH). Make sure both this database and the log binder that goes 
with the MMP sensors are updated.

-When an old sensor is calibrated,the information needs to get added to the 
cal file. Shear probes are under "Af" by serial number. When a new sensor 
is calibrated, a new file should be created to store the calibration 
coefficients.
