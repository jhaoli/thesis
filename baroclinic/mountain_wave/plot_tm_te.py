#!/usr/bin/env python3
#_*_coding: utf-8 _*_*

import os,sys
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from netCDF4 import Dataset

fi  = Dataset('./mz.360x181.l26.dt60.03.h0.nc', 'r')

time = fi.variables['time'][0:31]
tm   = fi.variables['tm'][0:31]
te   = fi.variables['te'][0:31]

fig,ax0 = plt.subplots(figsize=(5,2.5))
#time = np.arange(0,31)

ax0.plot(time, (te-te[0])/te[0], color='red', linewidth=1.5, label='total energy')
ax0.plot(time, (tm-tm[0])/tm[0], color='blue',linewidth=1.5,  label='total mass')

ax0.ticklabel_format(style='sci', axis='y', scilimits=(0,0))

ax0.set_xlabel('Time (days)')
ax0.set_xticks(np.arange(0,31,5))
ax0.set_xticklabels(np.arange(0,31,5))
#ax.set_xticks(np.arange(0,,4))
ax0.set_xlim(0,30)
ax0.minorticks_on()
ax0.legend(loc="lower left", frameon=False)
ax0.set_ylim(-4.0E-05,1.0E-05)
ax0.set_ylabel('normalized TM/TE')
ax0.grid()
#*******************************************'
fig.savefig("tm_te_mz_gmcore.png", dpi=300, format='png', bbox_inches='tight')
fig.clf()

