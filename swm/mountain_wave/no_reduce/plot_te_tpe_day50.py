#!/usr/bin/env python3
#_*_coding: utf-8 _*_

import os, sys
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from netCDF4 import Dataset

fi_apvm   = "./mz.swm.360x181.dt6.day50.stokes_on.E_apvm.h0.nc"
fi_upwind = "./mz.swm.360x181.dt6.day50.stokes_on.E_upwind3rd_wgt0.25.h0.nc"

f_apvm    = Dataset(fi_apvm, "r")
te_apvm   = f_apvm.variables['te'][:]
tpe_apvm  = f_apvm.variables['tpe'][:]
tim       = f_apvm.variables['time'][:]

f_upwind    = Dataset(fi_upwind, "r")
te_upwind   = f_upwind.variables['te'][:]
tpe_upwind  = f_upwind.variables['tpe'][:]

fig = plt.figure(figsize=(8,6))

ax0 = fig.add_subplot(2,1,1)

x = np.arange(len(tim))

ax0.plot(x, (te_apvm - te_apvm[0]) / te_apvm[0], label='TE with APVM' , linestyle='-', color='red')
ax0.plot(x, (te_upwind - te_upwind[0]) / te_upwind[0], label='TE with 3rd upwind', linestyle='--', color='blue')
ax0.set_title('Total energy')
ax0.grid(linestyle='dotted', linewidth=0.4)
ax0.minorticks_on()
ax0.set_xticks(np.arange(0,50,5))

ax1 = fig.add_subplot(2,1,2)
ax1.plot(x, (tpe_apvm - tpe_apvm[0]) / tpe_apvm[0], label = 'TPE with APVM' , linestyle='-', color='red')
ax1.plot(x, (tpe_upwind - tpe_upwind[0]) / tpe_upwind[0], label = 'TPE with 3rd upwind' , linestyle='--', color='blue')
#ax1.set_title('Total potential enstrophy')
#ax1.set_ylabel')
ax1.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
ax1.minorticks_on()
ax1.set_xticks(np.arange(0,50,5))

ax1.set_xlabel('Time (day)')

ax1.grid(linestyle='dotted', linewidth=0.4)

figname = "./te_tpe_apvm_upwind_day50_mountain_wave.png"
plt.savefig(figname, dpi=300, bbox_inches='tight')

