#!/usr/bin/env python3
#_*_coding: utf-8 _*_

import os, sys
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from netCDF4 import Dataset

file0   = "mz.swm.360x181.dt60.h0.nc"
file1   = "mz.swm.360x181.dt60.vordamp.h0.nc"


f0    = Dataset(file0, 'r')
tm0   = f0.variables['tm'][:]
te0   = f0.variables['te'][:]
tpe0  = f0.variables['tpe'][:]
tim   = f0.variables['time'][:]

f1   = Dataset(file1, 'r')
tm1  = f1.variables['tm'][:]
te1  = f1.variables['te'][:]
tpe1 = f1.variables['tpe'][:]


fig = plt.figure(figsize=(10,8))
ax0 = fig.add_subplot(3,2,1)

x = np.arange(len(tim))
ax0.plot(x, (tm0 - tm0[0]) / tm0[0], label='total mass', color='black', linewidth=2)
ax0.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
#ax0.set_ylim(-5E-12,0.2E-12)
ax0.minorticks_on()
ax0.set_xticks(np.arange(0,len(tim),5))
ax0.set_xticklabels(np.arange(0,51,5))
ax0.set_ylabel('Normalized TM', fontsize=12)
ax0.legend(frameon=False, fontsize=12, loc='lower left')
ax0.grid(linestyle='dotted', linewidth=0.4)

ax1 = fig.add_subplot(3,2,2)
ax1.plot(x, (tm1 - tm1[0]) / tm1[0], label='total mass', color='black', linewidth=2)
ax1.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
ax1.minorticks_on()
ax1.set_xticks(np.arange(0,len(tim),5))
ax1.set_xticklabels(np.arange(0,51,5))
ax1.legend(frameon=False, fontsize=12, loc='lower left')
ax1.grid(linestyle='dotted', linewidth=0.4)

ax2 = fig.add_subplot(3,2,3)
ax2.plot(x, (te0 - te0[0]) / te0[0], label='toal energy', color='black', linewidth=2 )
ax2.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
ax2.minorticks_on()
ax2.set_xticks(np.arange(0,len(tim),5))
ax2.set_xticklabels(np.arange(0,51,5))
ax2.set_ylabel('Normalized TE', fontsize=12)
ax2.legend(frameon=False, fontsize=12, loc=(0.02,0.5))
ax2.grid(linestyle='dotted', linewidth=0.4)

ax3 = fig.add_subplot(3,2,4)
ax3.plot(x, (te1 - te1[0]) / te1[0], label='toal energy', color='black', linewidth=2)
ax3.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
#a10.set_ylim(-5E-12,0.2E-12)
ax3.minorticks_on()
ax3.set_xticks(np.arange(0,len(tim),5))
ax3.set_xticklabels(np.arange(0,51,5))
ax3.legend(frameon=False, fontsize=12, loc=(0.02, 0.5))
ax3.grid(linestyle='dotted', linewidth=0.4)

ax4= fig.add_subplot(3,2,5)
ax4.plot(x, (tpe0 - tpe0[0]) / tpe0[0], label='potential enstrophy' , color='black', linewidth=2)
ax4.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
ax4.minorticks_on()
ax4.set_xticks(np.arange(0,len(tim),5))
ax4.set_xticklabels(np.arange(0,len(tim),5))
ax4.legend(frameon=False, fontsize=12, loc=(0.02,0.5))
ax4.set_xlabel('Time (days)')
ax4.set_ylabel('Normalized TPE')
ax4.grid(linestyle='dotted', linewidth=0.4)

ax5 = fig.add_subplot(3,2,6)
ax5.plot(x, (tpe1 - tpe1[0]) / tpe1[0], label='potential enstrophy', color='black',linewidth=2)
ax5.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
#a1.set_ylim(-1.0E-05,2E-06)
ax5.minorticks_on()
ax5.set_xticks(np.arange(0,len(tim),5))
ax5.set_xticklabels(np.arange(0,len(tim),5))
ax5.legend(frameon=False, fontsize=12, loc=(0.02,0.5))
ax5.set_xlabel('Time (days)')
ax5.grid(linestyle='dotted', linewidth=0.4)

figname = './tm_te_tpe_mountain_wave_reduce.png'
plt.savefig(figname, dpi=300, bbox_inches='tight')
