#!/usr/bin/env python3
#_*_coding: utf-8 _*_

import os, sys
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from netCDF4 import Dataset

file_u_pole        = "./cp.swm.360x181.dt6.day10.stokes_off.h0.nc"
file_u_pole_stokes = "./cp.swm.360x181.dt6.day10.stokes_on.h0.nc"
file_v_pole        = "./cp.swm.360x180.dt3.day10.h0.nc"

f_u_pole = Dataset(file_u_pole, 'r')
te0  = f_u_pole.variables['te'][:]
tpe0 = f_u_pole.variables['tpe'][:]
tim = f_u_pole.variables['time'][:]

f_u_pole_stokes = Dataset(file_u_pole_stokes, 'r')
te1  = f_u_pole_stokes.variables['te'][:]
tpe1 = f_u_pole_stokes.variables['tpe'][:]

f_v_pole = Dataset(file_v_pole, 'r')
te2  = f_v_pole.variables['te'][:]
tpe2 = f_v_pole.variables['tpe'][:]

fig = plt.figure(figsize=(8,6))
ax0 = fig.add_subplot(2,1,1)

x = np.arange(len(tim))
ax0.plot(x, (te0  - te0[0] ) / te0[0], label='u@pole'         , color='green', marker='o', markeredgecolor='green')
ax0.plot(x, (te1  - te1[0] ) / te1[0], label='modified u@pole', color='red'  , marker='s', markeredgecolor='red')
ax0.plot(x, (te2  - te2[0] ) / te2[0], label='v@pole'         , color='blue' , marker='*', markeredgecolor='blue')
ax0.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
ax0.set_ylim(-2.5E-12,0.2E-12)
ax0.minorticks_on()
ax0.set_xticks(np.arange(0,41,4))
ax0.set_xticklabels(np.arange(0,11,1))
ax0.set_ylabel('Normalized total energy', fontsize=12)
ax0.legend(frameon=False, fontsize=12, loc='lower left')

ax1 = fig.add_subplot(2,1,2)
ax1.plot(x, (tpe0 - tpe0[0]) / tpe0[0], label='u@pole'         , color='green', marker='o', markeredgecolor='green')
ax1.plot(x, (tpe1 - tpe1[0]) / tpe1[0], label='modified u@pole', color='red'  , marker='s', markeredgecolor='red')
ax1.plot(x, (tpe2 - tpe2[0]) / tpe2[0], label='v@pole'         , color='blue' , marker='*', markeredgecolor='blue')
ax1.ticklabel_format(style='sci', axis='y', scilimits=(2,1))
#ax1.set_ylim(-1.0E-05,2E-06)
ax1.minorticks_on()
ax1.set_xticks(np.arange(0,41,4))
ax1.set_xticklabels(np.arange(0,11,1))
ax1.set_ylabel('Normalized potential enstrophy', fontsize=12)
ax1.legend(frameon=False, fontsize=12, loc='upper left')
ax1.set_xlabel('Time (days)')

figname = './timeseries_te_tpe_cross_pole.png'
plt.savefig(figname, dpi=300, bbox_inches='tight')
