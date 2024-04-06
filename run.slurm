#!/bin/bash
#SBATCH -J 130cores_test
#SBATCH -N 26
#SBATCH --ntasks-per-node=5
#SBATCH -p normal

generate_nodelist()
{
NODES=`scontrol show hostnames $SLURM_JOB_NODELIST`
echo $NODES
CPUS_PER_NODES=`echo $SLURM_JOB_CPUS_PER_NODE | cut -d '(' -f1`
echo $CPUS_PER_NODES
if [ -f ./nodelist ]; then
	rm -f ./nodelist
fi

for i in $NODES
do
	for k in `seq 1 $CPUS_PER_NODES`
		do
			echo $i >> nodelist
		done
done
}

NP=`cat ./nodelist | wc -l`

# generate nodelist file
generate_nodelist

# run env
module purge

# for hpcx
module add compiler/intel/2017.5.239
module add mpi/hpcx/2.11.0/intel-2017.5.239

############## user define ################
# key file
inputfile=
# other parameters
otherparas=
###########################################



############# DO NOT MODIFY LINES BELOW ############### 
# Run single node simulation
#mpiexec -np $NP -hostfile nodelist ./HPUFM
mpirun -mca oob_tcp_if_include ib0 -np $NP ./HPUFM

#mpiexec -n $NP ./HPUFM
