;;
; calculate the climatical statistics within hs94 test case
;;

begin
  data_path = "./"
  df= data_path + "uvt_1deg_day1000.nc"

  fin = addfile(df, "r")
  
  time = fin->time
;  ilon = f_u->ilon
;  ilat = f_v->ilat
  lon  = fin->lon
  lat  = fin->lat
  lev  = fin->lev
  ntime = dimsizes(time)
  nlev  = dimsizes(lev)
  nlat  = dimsizes(lat)
  nlon  = dimsizes(lon)

  uc = fin->u
  vc = fin->v
  t  = fin->t

  lato = lat(1:nlat-2)

  uctmp = new((/ntime, nlev, nlat, nlon/), typeof(uc))
  ua    = new((/ntime, nlev, nlat-2, nlon/), typeof(uc))

  uc1 = new((/ntime, nlev, nlat, nlon-1/), typeof(uc))
  uc2 = new((/ntime, nlev, nlat, nlon-1/), typeof(uc))
  uc1 = uc(:,:,:,0:nlon-2)
  uc2 = uc(:,:,:,1:nlon-1)
  uctmp(:,:,:,1:nlon-1) = (uc1 + uc2) * 0.5
  uctmp(:,:,:,0) = (uc(:,:,:,0) + uc(:,:,:,nlon-1)) * 0.5
  ua = uctmp(:,:,1:nlat-2,:)
  delete(uctmp)

  va = new((/ntime, nlev, nlat-2, nlon/), typeof(vc))
  vc1 = vc(:,:,0:nlat-3,:)
  vc2 = vc(:,:,1:nlat-2,:)
  va = (vc1 + vc2) * 0.5
;  printVarSummary(va)

;  do it = 0, ntime-1
;    do iz = 0, nlev-1
;      do iy = 0, nlat-3
;        ua(it,iz,iy,1:nlon-1) = (uc(it, iz, iy+1, 0:nlon-2) + uc(it, iz, iy+1, 1:nlon-1)) * 0.5
;        ua(it,iz,iy,0) = (uc(it, iz, iy+1, 0) + uc(it, iz, iy+1, nlon-1)) * 0.5
;      end do
;      do ix = 0, nlon-1
;        va(it,iz,:,ix) = (vc(it, iz, 0:nlat-3, ix) + vc(it, iz, 1:nlat-2, ix)) * 0.5
;      end do
;    end do
;  end do
;  printVarSummary(ua)
;  printVarSummary(va)

;  vptp = new((/ntime, nlev, nlat-2/), typeof(uc))
;  upvp = new((/ntime, nlev, nlat-2/), typeof(uc))
;  tptp = new((/ntime, nlev, nlat-2/), typeof(uc))
;  eke  = new((/ntime, nlev, nlat-2/), typeof(uc))

  uprime = dim_rmvmean_Wrap(ua)
  vprime = dim_rmvmean_Wrap(va)
  tprime = dim_rmvmean_Wrap(t)

; Calculate U
  uzm = dim_avg_Wrap(ua(:,:,:,:))
  uclim = dim_avg_n_Wrap(uzm, 0)
  uclim@long_name = "Zonal mean zonal wind"
  uclim@units = "m/s"
  uclim!0 = "lev"
  uclim!1 = "lat"
  lat@units = "degrees_north"
  uclim@lat = lato
  uclim@lev = lev

; Calculate V
  vzm = dim_avg_Wrap(va(:,:,:,:))
  vclim = dim_avg_n_Wrap(vzm, 0)
  vclim@long_name = "Zonal mean meridional wind"
  vclim@units = "m/s"
  vclim!0 = "lev"
  vclim!1 = "lat"
  lat@units = "degrees_north"
  vclim@lat = lato
  vclim@lev = lev

; Calculate T
  tzm = dim_avg_Wrap(t(:,:,1:nlat-2,:))
  tclim = dim_avg_n_Wrap(tzm, 0)
  tclim@long_name = "Zonal mean temperature"
  tclim@units = "K"
  tclim!0 = "lev"
  tclim!1 = "lat"
  lat@units = "degrees_north"
  tclim@lat = lato
  tclim@lev = lev

; Calculate V'T'
  vptptemp =uprime
  vptptemp = (/vprime * tprime(:,:,1:nlat-2,:)/)
  vptpzm = dim_avg_Wrap(vptptemp(:, :, :, :))
  vptpclim = dim_avg_n_Wrap(vptpzm,0)
  vptpclim@long_name = "Northward eddy heat flux"
  vptpclim@units = "Km/s"
  vptpclim!0 = "lev"
  vptpclim!1 = "lat"
  lat@units = "degrees_north"
  vptpclim@lat = lato
  vptpclim@lev = lev

; Calculate U'V'
  upvptemp = uprime
  upvptemp = (/uprime * vprime/)
  upvpzm = dim_avg_Wrap(upvptemp(:,:,:,:))
  upvpclim = dim_avg_n_Wrap(upvpzm, 0)
  upvpclim@long_name = "Northward eddy momentum flux"
  upvpclim@units = "m^2/s^2"
  upvpclim!0 = "lev"
  upvpclim!1 = "lat"
  lat@units = "degrees_north"
  upvpclim@lat = lato
  upvpclim@lev = lev

; Calculate T'T'
  tptptemp = tprime
  tptptemp = (/tprime * tprime/)
  tptpzm = dim_avg_Wrap(tptptemp(:,:,1:nlat-2,:))
  tptpclim = dim_avg_n_Wrap(tptpzm, 0)
  tptpclim@long_name = "Eddy temperature variance"
  tptpclim@units = "K^2"
  tptpclim!0 = "lev"
  tptpclim!1 = "lat"
  lat@units = "degrees_north"
  tptpclim@lat = lato
  tptpclim@lev = lev

; Calculate (U'^2 + V'^2)/2
  eketemp = uprime
  eketemp = (/uprime * uprime * 0.5 + vprime * vprime * 0.5/)
  ekezm = dim_avg_Wrap(eketemp(:,:,:,:))
  ekeclim = dim_avg_n_Wrap(ekezm, 0)
  ekeclim@long_name = "Eddy kinetic energy"
  ekeclim@units = "m^2/s^2"
  ekeclim!0 = "lev"
  ekeclim!1 = "lat"
  lat@units = "degrees_north"
  ekeclim@lat = lato
  ekeclim@lev = lev
  ;**************************************
  ;write out netcdf
  ;**************************************
  diro = "./"
  fo = "statistics_hs_gmcore.nc"
  system("/bin/rm -f " + diro + fo)
  fout = addfile(fo, "c") ; open output file

  setfileoption(fout, "DefineMode", True)
  ; create global attributes
  fatt = True
  fatt@title = "HS94 statistics calculated using NCL"
  fileattdef(fout, fatt)
  ;
  dimNames = (/"lev", "lat"/)
  dimSizes = (/nlev, nlat-2/)
  dimUnlim = (/False, False/)
  filedimdef(fout, dimNames, dimSizes, dimUnlim)
  ;
  filevardef(fout, "lev", typeof(lev)     , getvardims(lev))
  filevardef(fout, "lat", typeof(lat)     , getvardims(lato))
  filevardef(fout, "U"  , typeof(uclim)   , getvardims(uclim))
  filevardef(fout, "V"  , typeof(vclim)   , getvardims(vclim))
  filevardef(fout, "T"  , typeof(tclim)   , getvardims(tclim))
  filevardef(fout, "EMF", typeof(upvpclim), getvardims(upvpclim))
  filevardef(fout, "EKE", typeof(ekeclim) , getvardims(ekeclim))
  filevardef(fout, "EHF", typeof(vptpclim), getvardims(vptpclim))
  filevardef(fout, "ETV", typeof(tptpclim), getvardims(tptpclim))

  ;
  filevarattdef(fout, "lev", lev)
  filevarattdef(fout, "lat", lato)
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
  fout->lev = (/lev/)
  fout->lat = (/lato/)
  fout->U   = (/uclim/)
  fout->V   = (/vclim/)
  fout->T   = (/tclim/)
  fout->EMF = (/upvpclim/)
  fout->EKE = (/ekeclim/)
  fout->EHF = (/vptpclim/)
  fout->ETV = (/tptpclim/)

end
