#!/usr/bin/env python3

from netCDF4 import Dataset
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import sys

f2p0 = Dataset('./ss.swm.180x91.dt240.day12.h0.nc', 'r')
f1p0 = Dataset('./ss.swm.360x181.dt120.day12.h0.nc','r')
f0p5 = Dataset('./ss.swm.720x361.dt60.day12.h0.nc', 'r')
f0p25 = Dataset('./ss.swm.1440x721.dt30.day12.h0.nc', 'r')

def calc_l1_l2_linf(h, h0, cos_lat):
	l1 = np.sum(np.sum(np.abs(h[:,:] - h0[:,:]), axis=1) * cos_lat[:]) / np.sum(np.sum(np.abs(h0[:,:]), axis=1) * cos_lat[:])
	l2 = np.sqrt(np.sum(np.sum((h[:,:] - h0[:,:])**2, axis=1) * cos_lat[:])) / np.sqrt(np.sum(np.sum(h0[:,:]**2, axis=1) * cos_lat[:]))
	linf = np.max(np.abs(h[:,:] - h0[:,:])) / np.max(np.abs(h0[:,:]))
	return l1,l2,linf

L1 = []
L2 = []
Linf = []
day = 12
z  = f2p0.variables['z'][day,:,:]
z0 = f2p0.variables['z'][0,:,:]
cos_lat = np.cos(np.radians(f2p0.variables['lat'][:]))
l1_2p0, l2_2p0, linf_2p0 = calc_l1_l2_linf(z, z0, cos_lat)
L1.append(l1_2p0)
L2.append(l2_2p0)
Linf.append(linf_2p0)

z  = f1p0.variables['z'][day,:,:]
z0 = f1p0.variables['z'][0,:,:]
cos_lat = np.cos(np.radians(f1p0.variables['lat'][:]))
l1_1p0, l2_1p0, linf_1p0 = calc_l1_l2_linf(z, z0, cos_lat)
L1.append(l1_1p0)
L2.append(l2_1p0)
Linf.append(linf_1p0)

z = f0p5.variables['z'][day,:,:]
z0 = f0p5.variables['z'][0,:,:]
cos_lat = np.cos(np.radians(f0p5.variables['lat'][:]))
l1_0p5, l2_0p5, linf_0p5 = calc_l1_l2_linf(z, z0, cos_lat)
L1.append(l1_0p5)
L2.append(l2_0p5)
Linf.append(linf_0p5)

z = f0p25.variables['z'][day,:,:]
z0 = f0p25.variables['z'][0,:,:]
cos_lat = np.cos(np.radians(f0p25.variables['lat'][:]))
l1_0p25, l2_0p25, linf_0p25 = calc_l1_l2_linf(z, z0, cos_lat)
L1.append(l1_0p25)
L2.append(l2_0p25)
Linf.append(linf_0p25)
print(l1_2p0, l2_2p0, linf_2p0)
print(l1_1p0, l2_1p0, linf_1p0)
print(l1_0p5, l2_0p5, linf_0p5)
#exit()
# plot

fig = plt.figure(figsize=(6,4))
ax = fig.add_subplot(1,1,1)

x = np.arange(1,5)
ax.set_xscale('log')
ax.set_yscale('log')

lw = 1.2
ax.plot(x, L1, color='green' , linewidth=lw, marker='o', markeredgecolor='green', label=r'$\ell_1$')
ax.plot(x, L2, color='red'   , linewidth=lw, marker='s', markeredgecolor='red'  , label = r'$\ell_2$')
ax.plot(x, Linf, color='blue', linewidth=lw, marker='*', markeredgecolor='blue' , label = r'$\ell_{\infty}$')

order1_0 = L2[0]*6
order1_3 = order1_0 / 2**3
ax.plot([1,4], [order1_0, order1_3], color='gray')

order2_0 = L2[0]/3
order2_3 = order2_0 / 2**6
ax.plot([1,4], [order2_0, order2_3], color='gray')


ax.set_ylim(1.0e-8, 1.0e-4)
ax.set_xlim(0.9, 4.5)
ax.set_xticks([1, 2, 3, 4] )
xlabels = [r'$2^\circ$', r'$1^\circ$', r'$0.5^\circ$', r'$0.25^\circ$']
ax.set_xticklabels(xlabels, fontsize = 15)

ax.set_xlabel('resolution (degree)', fontsize=15)
ax.set_ylabel('error norms', fontsize=15)
ax.grid()
ax.legend(frameon=False, loc='lower left')

ax.text(1.6, 0.15E-04, '-1')
ax.text(1.6, 0.2E-06, '-2')

# add potenetial enstrophy conserving scheme
#ax.plot(2.0, 1.3786694347921108e-06,'o', color='k')
#ax.plot(2.0, 1.5793822300118163e-06,'s', color='k')
#ax.plot(2.0, 3.705127e-06          ,'*', color='k')

# add gamil' error norms
#ax.plot(1, 2.971286896857659e-06, 'o', color='k')
#ax.plot(2, 9.271030225723742e-07, 'o', color='k')
#ax.plot(3, 2.420419605524822e-07, 'o', color='k')
#
#ax.plot(1, 3.2206060427408165e-06, 's', color='k')
#ax.plot(2, 1.003083796401539e-06 , 's', color='k')
#ax.plot(3, 2.6184532679482646e-07, 's', color='k')
#
#ax.plot(1, 4.04345183909089e-06  , '*', color='k')
#ax.plot(2, 1.3564203457832783e-06, '*', color='k')
#ax.plot(3, 3.584597718585818e-07 , '*', color='k')

ax.set_title('Day 12')
figname = './convergence_steday_state.png'
plt.savefig(figname, dpi=300, bbox_inches='tight')

