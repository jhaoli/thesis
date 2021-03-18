load "./plot_mod.ncl"

    hyai =(/0.002194067  , \ ;  1
            0.004895209  , \ ;  2
            0.009882418  , \ ;  3
            0.01805201   , \ ;  4
            0.02983724   , \ ;  5
            0.04462334   , \ ;  6
            0.06160587   , \ ;  7
            0.07851243   , \ ;  8
            0.07731271   , \ ;  9
            0.07590131   , \ ; 10
            0.07424086   , \ ; 11
            0.07228744   , \ ; 12
            0.06998933   , \ ; 13
            0.06728574   , \ ; 14
            0.06410509   , \ ; 15
            0.06036322   , \ ; 16
            0.05596111   , \ ; 17
            0.05078225   , \ ; 18
            0.04468960   , \ ; 19
            0.03752191   , \ ; 20
            0.02908949   , \ ; 21
            0.02084739   , \ ; 22
            0.01334443   , \ ; 23
            0.00708499   , \ ; 24
            0.00252136   , \ ; 25
            0.00000000   , \ ; 26
            0.00000000/)     ; 27
    
    hybi =(/0.000000     , \ ;  1
            0.000000     , \ ;  2
            0.000000     , \ ;  3
            0.000000     , \ ;  4
            0.000000     , \ ;  5
            0.000000     , \ ;  6
            0.000000     , \ ;  7
            0.000000     , \ ;  8
            0.01505309   , \ ;  9
            0.03276228   , \ ; 10
            0.05359622   , \ ; 11
            0.07810627   , \ ; 12
            0.1069411    , \ ; 13
            0.1408637    , \ ; 14
            0.1807720    , \ ; 15
            0.2277220    , \ ; 16
            0.2829562    , \ ; 17
            0.3479364    , \ ; 18
            0.4243822    , \ ; 19
            0.5143168    , \ ; 20
            0.6201202    , \ ; 21
            0.7235355    , \ ; 22
            0.8176768    , \ ; 23
            0.8962153    , \ ; 24
            0.9534761    , \ ; 25
            0.9851122    , \ ; 26
            1.0000000/)      ; 27 

  hyam = new(dimsizes(hyai)-1, float)
  hybm = new(dimsizes(hybi)-1, float)
  do i = 0, dimsizes(hyai)-2
    hyam(i) = (hyai(i) + hyai(i+1)) * 0.5
    hybm(i) = (hybi(i) + hybi(i+1)) * 0.5
  end do
begin
  ;fpath = "/Users/hao/Documents/work/Models/taiyuan/GMCORE_r/build/mz.360x181.l26/"
  fpath = "./"
  fname = "mz.360x181.l26.dt60.01.h0.nc"
  fi = addfile(fpath+fname, "r")
  
  lon   = fi->lon 
  lat   = fi->lat
  lev   = fi->lev
  time  = fi->time
  nlon  = dimsizes(lon)
  nlat  = dimsizes(lat)
  nlev  = dimsizes(lev)
  ntime = dimsizes(time)

  uc   = fi->u
  vc   = fi->v
  t   = fi->t
  z   = fi->z
  t   = fi->t
  phs = fi->phs
;******************************************
; convert the C grid to A grid for u and v wind.
  uctmp = new((/ntime, nlev, nlat, nlon/), typeof(uc))
  ua    = new((/ntime, nlev, nlat, nlon/), typeof(uc))

  uc1 = new((/ntime, nlev, nlat, nlon-1/), typeof(uc))
  uc2 = new((/ntime, nlev, nlat, nlon-1/), typeof(uc))
  uc1 = uc(:,:,:,0:nlon-2)
  uc2 = uc(:,:,:,1:nlon-1)
  uctmp(:,:,:,1:nlon-1) = (uc1 + uc2) * 0.5
  uctmp(:,:,:,0) = (uc(:,:,:,0) + uc(:,:,:,nlon-1)) * 0.5
  ua = uctmp(:,:,:,:)
  delete(uctmp)

  va = new((/ntime, nlev, nlat, nlon/), typeof(vc))
  vc1 = vc(:,:,0:nlat-3,:)
  vc2 = vc(:,:,1:nlat-2,:)
  va(:,:,1:nlat-2,:) = (vc1 + vc2) * 0.5
;  printVarSummary(va)
;******************************************
;
  interp = 2 ; type of interpolation: 1 = linear, 2 = log, 3 = loglog 
  extrap = False ; is extrapolation desired if data is outside the range of PS
  
  
  u700 = vinth2p(ua, hyam, hybm, 700, phs, interp, 1000.0, 1, extrap)
  v700 = vinth2p(va, hyam, hybm, 700, phs, interp, 1000.0, 1, extrap)
  z700 = vinth2p(z , hyai, hybi, 700, phs, interp, 1000.0, 1, extrap)
  t700 = vinth2p(t , hyam, hybm, 700, phs, interp, 1000.0, 1, extrap)
; ============================
; (1)
  wks = gsn_open_wks("ps", "mz_1deg_dt60_uv_700hpa")
; gsn_define_colormap(wks, "GMT_panoply")
  gsn_define_colormap(wks, "gui_default")
  plots = new(6, graphic)
  u700@long_name = "700 hPa zonal wind"
  u700@units     = "m/s"
  u700!0 = "time"
  u700&time = time
  u700!2 =  "lat"
  u700&lat = lat
  u700!3 = "lon"
  u700&lon = lon
  copy_VarCoords(u700, v700)
  v700@long_name = "700 hPa merid. wind"
  v700@units     = "m/s"
  z700@long_name = "700 hPa geop. height"
  z700@units     = "m"
  t700@long_name = "700 hPa Temperature"
  t700@units     = "K"
  
  optArg         = True
  optArg@mainstr = "day 5"
  contour_plot(wks, u700(5 ,0,:,:), 5, -10, 45, plots, 0, optArg)
  contour_plot(wks, v700(5 ,0,:,:), 5, -30, 15, plots, 1, optArg)

  optArg@mainstr = "day 15"
  contour_plot(wks, u700(15,0,:,:), 5, -10, 45, plots, 2, optArg)
  contour_plot(wks, v700(15,0,:,:), 5, -30, 15, plots, 3, optArg)

  optArg@mainstr = "day 25"
  contour_plot(wks, u700(25,0,:,:), 5, -10, 45, plots, 4, optArg)
  contour_plot(wks, v700(25,0,:,:), 5, -30, 15, plots, 5, optArg)
;***********************
;  optArg         = True
;  optArg@mainstr = "day 5"
;  contour_plot(wks, z700(5 ,0,:,:) , 100, 2500, 3300, plots, 0, optArg)
;  contour_plot(wks, t700(5 ,0,:,:) , 3  , 273 , 300 , plots, 1, optArg)
;  optArg@mainstr = "day 15"
;  contour_plot(wks, z700(15,0,:,:) , 100, 2500, 3300, plots, 2, optArg)
;  contour_plot(wks, t700(15,0,:,:) , 3  , 273 , 300 , plots, 3, optArg)
;  optArg@mainstr = "day 25"
;  contour_plot(wks, z700(25,0,:,:) , 100, 2500, 3300, plots, 4, optArg)
;  contour_plot(wks, t700(25,0,:,:) , 3  , 273 , 300 , plots, 5, optArg)

 
  resp = True
  resp@gsnPanelYWhiteSpacePercent = 0
  resp@gsnPanelXWhiteSpacePercent = 5
  gsn_panel(wks, plots, (/3,2/), resp)

end

