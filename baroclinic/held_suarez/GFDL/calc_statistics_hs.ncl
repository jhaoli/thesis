;;**********************************
; calculate the climatical statistics within hs94 test case
; 
; jianghaolee@126.com
;;**********************************
begin
  data_path = "./"
  df = data_path + "uvt_day1000_t85_gfdl.nc"

  fi = addfile(df, "r")
  
  time  = fi->time
  lon   = fi->lon
  lat   = fi->lat
  pfull = fi->pfull
  ntime = dimsizes(time)
  nlev  = dimsizes(pfull)
  nlat  = dimsizes(lat)
  nlon  = dimsizes(lon)

  u  = fi->u
  v  = fi->v
  t  = fi->t

  uprime = dim_rmvmean_Wrap(u)
  vprime = dim_rmvmean_Wrap(v)
  tprime = dim_rmvmean_Wrap(t)

; Calculate U
  uzm = dim_avg_Wrap(u(:,:,:,:))
  uclim = dim_avg_n_Wrap(uzm, 0)
  uclim@long_name = "Zonal mean zonal wind (U)"
  uclim@units = "m/s"
  uclim!0 = "pfull"
  uclim!1 = "lat"
  lat@units = "degrees_north"
  uclim@lat = lat
  uclim@pfull = pfull 

; Calculate V
  vzm = dim_avg_Wrap(v(:,:,:,:))
  vclim = dim_avg_n_Wrap(vzm, 0)
  vclim@long_name = "Zonal mean meridional wind (V)"
  vclim@units = "m/s"
  vclim!0 = "pfull"
  vclim!1 = "lat"
  lat@units = "degrees_north"
  vclim@lat = lat
  vclim@pfull = pfull

; Calculate T
  tzm = dim_avg_Wrap(t(:,:,:,:))
  tclim = dim_avg_n_Wrap(tzm, 0)
  tclim@long_name = "Zonal mean temperature (T)"
  tclim@units = "K"
  tclim!0 = "pfull"
  tclim!1 = "lat"
  lat@units = "degrees_north"
  tclim@lat = lat
  tclim@pfull = pfull

; Calculate V'T'
  vptptemp =uprime
  vptptemp = (/vprime * tprime/)
  vptpzm = dim_avg_Wrap(vptptemp)
  vptpclim = dim_avg_n_Wrap(vptpzm,0)
  vptpclim@long_name = "Northward eddy heat flux (V'T')"
  vptpclim@units = "Km/s"
  vptpclim!0 = "pfull"
  vptpclim!1 = "lat"
  lat@units = "degrees_north"
  vptpclim@lat = lat
  vptpclim@pfull = pfull

; Calculate U'V'
  upvptemp = uprime
  upvptemp = (/uprime * vprime/)
  upvpzm = dim_avg_Wrap(upvptemp)
  upvpclim = dim_avg_n_Wrap(upvpzm, 0)
  upvpclim@long_name = "Northward eddy momentum flux (U'V')"
  upvpclim@units = "m~S~2~N~/s~S~2~N~"
  upvpclim!0 = "pfull"
  upvpclim!1 = "lat"
  lat@units = "degrees_north"
  upvpclim@lat = lat
  upvpclim@pfull = pfull

; Calculate T'T'
  tptptemp = tprime
  tptptemp = (/tprime * tprime/)
  tptpzm = dim_avg_Wrap(tptptemp)
  tptpclim = dim_avg_n_Wrap(tptpzm, 0)
  tptpclim@long_name = "Eddy temperature variance (T'T')"
  tptpclim@units = "K~S~2~N~"
  tptpclim!0 = "pfull"
  tptpclim!1 = "lat"
  lat@units = "degrees_north"
  tptpclim@lat = lat
  tptpclim@pfull = pfull

; Calculate (U'^2 + V'^2)/2
  eketemp = uprime
  eketemp = (/uprime * uprime * 0.5 + vprime * vprime * 0.5/)
  ekezm = dim_avg_Wrap(eketemp)
  ekeclim = dim_avg_n_Wrap(ekezm, 0)
  ekeclim@long_name = "Eddy kinetic energy (U'~S~2~N~+V'~S~2~N~)/2"
  ekeclim@units = "m~S~2~N~/s~S~2~N~"
  ekeclim!0 = "pfull"
  ekeclim!1 = "lat"
  lat@units = "degrees_north"
  ekeclim@lat = lat
  ekeclim@pfull = pfull
  ;**************************************
  ;write out netcdf
  ;**************************************
  diro = "./"
  fo = "hs.t85.statistics.nc"
  system("/bin/rm -f " + diro + fo)
  fout = addfile(fo, "c") ; open output file

  setfileoption(fout, "DefineMode", True)
  ; create global attributes
  fatt = True
  fatt@title = "HS94 statistics calculated using NCL"
  fileattdef(fout, fatt)
  ;
  dimNames = (/"pfull", "lat"/)
  dimSizes = (/nlev, nlat/)
  dimUnlim = (/False, False/)
  filedimdef(fout, dimNames, dimSizes, dimUnlim)
  ;
  filevardef(fout, "pfull", typeof(pfull) , getvardims(pfull))
  filevardef(fout, "lat", typeof(lat)     , getvardims(lat))
  filevardef(fout, "U"  , typeof(uclim)   , getvardims(uclim))
  filevardef(fout, "V"  , typeof(vclim)   , getvardims(vclim))
  filevardef(fout, "T"  , typeof(tclim)   , getvardims(tclim))
  filevardef(fout, "EMF", typeof(upvpclim), getvardims(upvpclim))
  filevardef(fout, "EKE", typeof(ekeclim) , getvardims(ekeclim))
  filevardef(fout, "EHF", typeof(vptpclim), getvardims(vptpclim))
  filevardef(fout, "ETV", typeof(tptpclim), getvardims(tptpclim))

  ;
  filevarattdef(fout, "pfull", pfull)
  filevarattdef(fout, "lat", lat)
  filevarattdef(fout, "U"  , uclim)
  filevarattdef(fout, "V"  , vclim)
  filevarattdef(fout, "T"  , tclim)
  filevarattdef(fout, "EMF", upvpclim)
  filevarattdef(fout, "EKE", ekeclim)
  filevarattdef(fout, "EHF", vptpclim)
  filevarattdef(fout, "ETV", tptpclim)

  ; explicit exit file definition mode.
  setfileoption(fout, "DefineMode", False)
  ; 
  fout->pfull = (/pfull/)
  fout->lat = (/lat/)
  fout->U   = (/uclim/)
  fout->V   = (/vclim/)
  fout->T   = (/tclim/)
  fout->EMF = (/upvpclim/)
  fout->EKE = (/ekeclim/)
  fout->EHF = (/vptpclim/)
  fout->ETV = (/tptpclim/)

end
