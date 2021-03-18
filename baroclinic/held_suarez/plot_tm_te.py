#!/usr/bin/env python3
#_*_coding: utf-8 _*_*

import os,sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from netCDF4 import Dataset

fi  = Dataset('./tmte_1deg_day1200.nc', 'r')

time = fi.variables['time']
tm   = fi.variables['tm']
te   = fi.variables['te']

fig = plt.figure(figsize=(5,2.5))
ax = fig.add_subplot(111)
ax.plot(time, (te-te[0])/te[0], linestyle='-', linewidth=1.2, color='red', label='total energy')
ax.plot(time, (tm-tm[0])/tm[0], linestyle='-', linewidth=1.2, color='blue', label='total mass')

ax.ticklabel_format(axis='y',style='sci', scilimits=(0,0))
ax.set_xlabel('Time (days)')
ax.set_ylabel('Normalized TM/TE')
ax.set_xlim(0,1200)
ax.set_xticks(np.arange(0,1201,200))
ax.set_ylim(-0.1E-02,1.2E-02)
ax.minorticks_on()
ax.legend(loc="best", frameon=False)
#  ax.set_yticks(np.arange(-90,120,30))
ax.grid(linestyle='dotted', linewidth=0.2)
fig.savefig("hs_tmte_gmcore.png", dpi=300, format='png', bbox_inches='tight')
fig.clf()

