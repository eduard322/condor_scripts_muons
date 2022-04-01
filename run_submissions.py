import os
import sys


DATA_DIR = sys.argv[1]
N_JOBS=13


with open("input_for_muon_prod.txt", "r") as f:
    for line in f:
        filepath, n_events, foldername = line.strip().split(", ")
        directory = os.path.join(DATA_DIR, foldername)
        if not os.path.exists(directory): 
            os.makedirs(directory)
        os.system("condor_submit directory={dir} N={n_jobs} muon_file={mf} n_events={ne} SUB={sub} sim.sub".format(dir=DATA_DIR,
                                                                                                         n_jobs=N_JOBS,
                                                                                                         mf=filepath,
                                                                                                         ne=n_events,
                                                                                                         sub = foldername))
