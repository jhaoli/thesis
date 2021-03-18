#!/usr/bin/env python3

from netCDF4 import Dataset
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import sys


#f = Dataset(sys.argv[1], 'r')

f0 = Dataset("error_norms_2p0.nc", 'r')
f1 = Dataset("error_norms_1p0.nc", 'r')

time   = f0.variables['time']
l2_1_2p0 = f0.variables['l2_1']
l2_2_2p0 = f0.variables['l2_2']

l2_1_1p0 = f1.variables['l2_1']
l2_2_1p0 = f1.variables['l2_2']

fig = plt.figure(figsize=(8,4))
ax = fig.add_subplot(1,2,1)

x = np.arange(len(time))
lw = 1.2
ax.plot(x[0:], l2_1_2p0[0:], color='red', linewidth=lw, marker= '', label='180x91L26')
ax.plot(x[0:], l2_1_1p0[0:], color='blue', linewidth=lw, marker= '', label='360x181L26')

ax.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
ax.minorticks_on()
#ax.set_ylim(1.0e-8, 1.0e-4)
#ax.set_xlim(0, len(time))
ax.set_ylim(0, 3.0E-05)
#ax.set_xticks(np.arange(0, len(time), 5))
#ax.set_xticklabels(np.arange(0, len(time),5))
#ax.set_yscale("log")
ax.set_title("(a) symmetry error", fontsize=14)
ax.set_xlabel('Time (days)', fontsize=13)
#ax.set_ylabel('error norms', fontsize=15)
ax.grid()
leg = ax.legend(frameon=False, loc='lower left', framealpha=0.2)
leg.get_frame().set_facecolor('grey')

ax1 = fig.add_subplot(1,2,2)
ax1.plot(x[0:], l2_2_2p0[0:], color='red', linewidth=lw, marker='', label = '180x91L26')
ax1.plot(x[0:], l2_2_1p0[0:], color='blue', linewidth=lw, marker='', label = '360x181L26')

ax1.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
ax1.set_title("(b) evolution error", fontsize=14)
ax1.set_xlabel('Time (days)', fontsize=13)
ax1.minorticks_on()
ax1.grid()
ax1.legend(frameon=False, loc='lower left')

figname = './errornorms_steday_state.png'
plt.savefig(figname, dpi=300, bbox_inches='tight')

