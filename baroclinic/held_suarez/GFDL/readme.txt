(1)从原始数据提取后1000天u v t 三个变量：
$cdo -selvar,u,v,t -seltimestep,200/1200 hs_t85_gfdl.nc uvt_day1000_t85_gfdl.nc

(2)用NCL计算统计量并生成nc文件(hs.t85.statistics.nc)：
$ncl calc_statistics_hs.ncl

(3)用NCL plot统计量：
$ncl plot_statistics_hs.ncl
