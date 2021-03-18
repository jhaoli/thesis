#!/usr/bin/env python3

from netCDF4 import Dataset
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import sys

def calc_l2_1(u, w, dlev):
  u_zonal = np.mean(u, axis=2)
  u_mean = np.repeat(u_zonal[:,:,np.newaxis], 360, axis=2)
  sum1 = np.sum((u - u_mean)**2, axis=2)
  a = sum1[:,1:-1] * np.repeat(w[np.newaxis,:], 26,axis=0)
  fenzi = np.sum(np.sum(a * np.repeat(dlev[:,np.newaxis], 179, axis=1), axis=0))
  fenmu = 360 * np.sum(np.repeat(w[:,np.newaxis], 26, axis=1) * np.repeat(dlev[np.newaxis, :], 179))
  print(fenzi, fenmu)
  l2_1 = np.sqrt(fenzi / fenmu)

  return l2_1

def calc_l2_2(u, u0, w, dlev):
  anomal = (u - u0)**2
  a = np.sum(anomal[:,1:-1] * np.repeat(w[np.newaxis,:], 26, axis=0), axis=1)
  fenzi = np.sum(a * dlev)
  fenmu = np.sum(w) * np.sum(dlev)
  l2_2 = np.sqrt(fenzi / fenmu)
  return l2_2

f = Dataset(sys.argv[1], 'r')

time = f.variables['time']
u    = f.variables['u']
ilev = f.variables['ilev']
ilat = f.variables['ilat']

cos_lat = np.cos(np.radians(f.variables['lat'][:]))
w = np.abs(np.sin(ilat[1:180]) - np.sin(ilat[0:-1]))
dlev = ilev[1:27] - ilev[0:26]

l2_1 = []
l2_2 = []
uzonal = np.mean(u[:,:,:,:], axis=3)
for it in np.arange(len(time)):
  l2_ = calc_l2_1(u[it], w, dlev)
  l2_1.append(l2_)
  l2_ = calc_l2_2(uzonal[it,:,:], uzonal[0,:,:], w, dlev)
  l2_2.append(l2_)
print(l2_1)
print(l2_2)

l2_1 = [0.0000000000000000        3.2824784228213272E-014   3.4692838422862737E-014   3.4583822286604933E-014   3.6290576282520196E-014   6.0063220800728945E-012   3.8899702163571274E-014   4.2481161939875500E-014   4.6430884657684036E-014   4.6050767260358547E-014   4.5081702948292066E-014   4.6998831114052308E-014   1.1714848009146188E-009   5.2302045499446374E-014   5.4478811790458637E-014   6.0856635232806181E-014   1.1903763682567348E-008   1.4048241682918342E-008   1.8356729174668768E-008   3.1825802717690374E-008   6.3262761935266724E-008   1.2394632731229013E-007   1.5113708451353749E-007   2.3260084987940918E-007   3.3285391489914276E-007   5.7383489542958448E-007   1.1452485957920102E-006   2.3724653982993747E-006   5.0135631972567492E-006   1.0666985940191481E-005   2.2734348240354846E-005]
l2_2 = [0.0000000000000000        2.0521926552319106E-002   2.3399632234236335E-002   2.7118231308861686E-002   2.5091365550674882E-002   2.0940565545743660E-002   2.0251786761377708E-002   2.1373741384864274E-002   2.1548940491964739E-002   2.0900458676393941E-002   2.3200190690375114E-002   2.1945058010438855E-002   2.4550243813170489E-002   2.1581465133615602E-002   2.0250844102670765E-002   1.8900467966116972E-002   1.9641419793418942E-002   1.9726983170442882E-002   2.1992260786047581E-002   2.1307888775001223E-002   2.2276453092235884E-002   2.3030459718536466E-002   2.0277261836954070E-002   1.9955140527196710E-002   1.8944675175995483E-002   2.0732618991699092E-002   2.2873485128030138E-002   2.3963089419765157E-002   2.2110228394476853E-002   2.1688642701434134E-002   1.9193803174733529E-002]
fig = plt.figure(figsize=(8,4))
ax = fig.add_subplot(1,2,1)

x = np.arange(len(time))
lw = 1.2
ax.plot(x[0:], l2_1[0:], color='black', linewidth=lw, marker= '', label=r'$\ell_1$')

ax.minorticks_on()
#ax.set_ylim(1.0e-8, 1.0e-4)
ax.set_xlim(0, len(time))
#ax.set_ylim(1.E-06, 1.0E-04)
ax.set_xticks(np.arange(0, len(time), 5))
ax.set_xticklabels(np.arange(0, len(time),5))
ax.set_yscale("log")
ax.set_xlabel('Time (days)', fontsize=15)
ax.set_ylabel('error norms', fontsize=15)
ax.grid()
ax.legend(frameon=False, loc='lower left')

ax1 = fig.add_subplot(1,2,2)
ax1.plot(x[0:], l2_2[0:], color='red', linewidth=lw, marker='', label = r'$\ell_2$')


figname = './errornorm_steday_state.png'
plt.savefig(figname, dpi=300, bbox_inches='tight')

