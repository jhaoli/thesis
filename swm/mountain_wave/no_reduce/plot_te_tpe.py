#!/usr/bin/env python3
#_*_coding: utf-8 _*_

import os, sys
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from netCDF4 import Dataset

file_u_E         = "./mz.swm.360x181.dt8.stokes_off.E_midpoint.h0.nc"
file_u_PE        = "./mz.swm.360x181.dt8.stokes_off.PE_midpoint.h0.nc"
file_u_E_stokes  = "./mz.swm.360x181.dt8.stokes_on.E_midpoint.h0.nc"
file_u_PE_stokes = "./mz.swm.360x181.dt8.stokes_on.PE_midpoint.h0.nc"
file_v_E         = "./mz.swm.360x180.dt3.day20.E_midpoint.h0.nc"
file_v_PE        = "./mz.swm.360x180.dt3.day20.PE_midpoint.h0.nc"

day = 20
day = 21
f_u_E   = Dataset(file_u_E, 'r')
te_u_E  = f_u_E.variables['te'][0:day]


f_u_PE  = Dataset(file_u_PE, 'r')
tpe_u_PE = f_u_PE.variables['tpe'][0:day]

f_u_E_stokes = Dataset(file_u_E_stokes, 'r')
te_u_E_stokes= f_u_E_stokes.variables['te'][0:day]

f_u_PE_stokes   = Dataset(file_u_PE_stokes, 'r')
tpe_u_PE_stokes = f_u_PE_stokes.variables['tpe'][0:day]

f_v_E  = Dataset(file_v_E, 'r')
te_v_E = f_v_E.variables['te'][0:day]

f_v_PE = Dataset(file_v_PE, 'r')
tpe_v_PE = f_v_PE.variables['tpe'][0:day]


fig = plt.figure(figsize=(8,6))
ax0 = fig.add_subplot(2,1,1)

x = np.arange(day)

ax0.plot(x, (te_u_E - te_u_E[0]) / te_u_E[0], label='u@pole'         , color='green', marker='o', markeredgecolor='green')
ax0.plot(x, (te_u_E_stokes - te_u_E_stokes[0]) / te_u_E_stokes[0], label='modified u@pole', color='red'  , marker='s', markeredgecolor='red')
ax0.plot(x, (te_v_E - te_v_E[0]) / te_v_E[0], label='v@pole'         , color='blue' , marker='*', markeredgecolor='blue')
ax0.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
#ax0.set_ylim(-5E-12,0.2E-12)
ax0.minorticks_on()
ax0.set_xticks(np.arange(0,day,2))
ax0.set_xticklabels(np.arange(0,21,2))
ax0.set_ylabel('Normalized total energy', fontsize=12)
ax0.set_title('TE conserving scheme')
ax0.legend(frameon=False, fontsize=12, loc='lower left')
ax0.grid(linestyle='dotted', linewidth=0.4)

ax1 = fig.add_subplot(2,1,2)
ax1.plot(x, (tpe_u_PE - tpe_u_PE[0]) / tpe_u_PE[0], label='u@pole'         , color='green', marker='o', markeredgecolor='green')
ax1.plot(x, (tpe_u_PE_stokes - tpe_u_PE_stokes[0]) / tpe_u_PE_stokes[0], label='modified u@pole', color='red'  , marker='s', markeredgecolor='red')
ax1.plot(x, (tpe_v_PE - tpe_v_PE[0]) / tpe_v_PE[0], label='v@pole'         , color='blue' , marker='*', markeredgecolor='blue')
ax1.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
#ax1.set_ylim(-1.0E-05,2E-06)
ax1.minorticks_on()
ax1.set_xticks(np.arange(0,day,2))
ax1.set_xticklabels(np.arange(0,day,2))
ax1.set_ylabel('Normalized potential enstrophy', fontsize=12)
ax1.set_title('TPE conserving scheme')
ax1.legend(frameon=False, fontsize=12, loc='upper left')
ax1.set_xlabel('Time (days)')
ax1.grid(linestyle='dotted', linewidth=0.4)

figname = './timeseries_te_tpe_mountain_wave.png'
plt.savefig(figname, dpi=300, bbox_inches='tight')
