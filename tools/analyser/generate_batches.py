#!/usr/bin/env python3
import sys
import glob
from os.path import join

GLOB = '*_runtime.hex'

CONTRACT_DIR = sys.argv[1]
N_BATCHES = int(sys.argv[2])

files = glob.glob(join(CONTRACT_DIR, GLOB))

per_batch = max(len(files) // N_BATCHES, 1)

batches = [[] for x in range(N_BATCHES)]

i = 0
while len(files) > 0:
    batches[i % N_BATCHES].append(files.pop())
    i += 1

for i, b in enumerate(batches):
    with open('batch_{}.txt'.format(i), 'w') as f:
        for fname in b:
            print(fname, file=f)
