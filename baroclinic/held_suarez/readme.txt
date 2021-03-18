(1)从前200天和后1000天提取te，tm变量：
$cdo -selvar,te,tm hs.360x181.l26.dt60.day200.01.h0.nc tmte_day200.nc
$cdo -selvar,te,tm hs.360x181.l26.dt60.day1000.01.h0.nc tmte_day1000.nc

(2)对后1000天去掉第一个时次:
$cdo -seltimestep,2/1001 tmte_day1000.nc tmp.nc

(3) 前后时间合并
$cdo mergetime tmte_day200.nc tmp.nc tmte_1deg_day1200.nc
