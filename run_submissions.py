import os
import sys
from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument("--output", dest="output", help="Output", required=False,  default=".")
parser.add_argument("--geofile",   dest="geofile",  help="Geofile", required=False,  default="scaled.root")
options = parser.parse_args()

DATA_DIR = options.output
GF = options.geofile
EOS = os.environ['EOS_PUBLIC']
N_JOBS=20


with open("geofiles/input_for_muon_prod.txt", "r") as f:
    for line in f:
        filepath, n_events, foldername = line.strip().split(", ")
        directory = os.path.join(EOS, DATA_DIR, foldername)
        if not os.path.exists(directory): 
            os.makedirs(directory)
            #for i in range(1, N_JOBS + 1):
                #job_dir = os.path.join(directory, str(i))
                #os.makedirs(job_dir)
        os.system("condor_submit directory={dir} N={n_jobs} muon_file={mf} n_events={ne} SUB={sub} GEOFILE={geofile} sim.sub".format(dir=DATA_DIR,
                                                                                                         n_jobs=N_JOBS,
                                                                                                         mf=filepath,
                                                                                                         ne=n_events,
                                                                                                         sub = foldername,
													 geofile = GF))
