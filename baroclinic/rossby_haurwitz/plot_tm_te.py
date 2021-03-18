#!/usr/bin/env python3
#_*_coding: utf-8 _*_*

import os,sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from netCDF4 import Dataset

fi  = Dataset('./rh4.360x181.l26.dt60.day110.00.h0.nc', 'r')

time = fi.variables['time'][0:90]
tm   = fi.variables['tm'][0:90]
te   = fi.variables['te'][0:90]

fig = plt.figure(figsize=(5,2))
ax = fig.add_subplot(111)
ax.plot(time, (tm-tm[0])/tm[0], linestyle='--', linewidth=2.0, marker='', color='blue', label='mass')
ax.plot(time, (te-te[0])/te[0], linestyle='-' , linewidth=2.0, marker='',color='red', label='energy')

ax.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
ax.set_xlabel('Time (days)')
ax.set_ylabel('Normalized TM/TE')
ax.set_xticks(np.arange(0,91,10))
ax.set_xticklabels(np.arange(0,91,10))
#ax.set_xticks(np.arange(0,,4))
ax.set_xlim(0,90)
ax.set_ylim(-5E-05, 1E-05)
ax.minorticks_on()
ax.legend(loc='lower left', frameon=False)
#  ax.set_yticks(np.arange(-90,120,30))
ax.grid(linestyle='dotted', linewidth=0.2)
#*******************************************'

fig.savefig("tm_te_rh4.png", dpi=300, format='png', bbox_inches='tight')
fig.clf()

