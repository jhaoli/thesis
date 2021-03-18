#!/usr/bin/env python3

from netCDF4 import Dataset
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import sys

def calc_l1_l2_linf(h, h0, cos_lat):
  l1 = np.sum(np.sum(np.abs(h[:,:] - h0[:,:]), axis=1) * cos_lat[:]) / np.sum(np.sum(np.abs(h0[:,:]), axis=1) * cos_lat[:])
  l2 = np.sqrt(np.sum(np.sum((h[:,:] - h0[:,:])**2, axis=1) * cos_lat[:])) / np.sqrt(np.sum(np.sum(h0[:,:]**2, axis=1) * cos_lat[:]))
  linf = np.max(np.abs(h[:,:] - h0[:,:])) / np.max(np.abs(h0[:,:]))
  return l1,l2,linf
	
f = Dataset(sys.argv[1], 'r')

time = f.variables['time']
z = f.variables['z']
z0 = z[0,:,:]
cos_lat = np.cos(np.radians(f.variables['lat'][:]))

L1 = []
L2 = []
Linf = []
for it in np.arange(len(time)):
	l1_, l2_, linf_ = calc_l1_l2_linf(z[it], z0, cos_lat)
	L1.append(l1_)
	L2.append(l2_)
	Linf.append(linf_)

fig = plt.figure(figsize=(8,4))
ax = fig.add_subplot(1,1,1)

x = np.arange(len(time))
lw = 1.2
ax.plot(x, L1, color='black', linewidth=lw, marker= '', label=r'$\ell_1$')

ax.plot(x, L2, color='red', linewidth=lw, marker='', label = r'$\ell_2$')

ax.plot(x, Linf, color='blue', linewidth=lw, marker='', label = r'$\ell_{\infty}$')

ax.set_ylim(1.0e-8, 1.0e-4)
ax.set_xlim(0, 365)
ax.set_xticks(np.arange(0, len(time), 10), minor = True)
ax.set_yscale("log")
ax.set_xlabel('Time (days)', fontsize=15)
ax.set_ylabel('error norms', fontsize=15)
ax.grid()
ax.legend(frameon=False, loc='lower left')

figname = './timeseries_error_steday_state.png'
plt.savefig(figname, dpi=300, bbox_inches='tight')

