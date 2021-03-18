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
  fpath = "./"
  fname0 = "mz.360x181.l26.dt60.03.h0.nc"
  fname1 = "mz_t85_gfdl.nc"

  fi0 = addfile(fpath+fname0, "r")
  fi1 = addfile(fpath+fname1, "r")
  
  lon   = fi0->lon 
  lat   = fi0->lat
  lev   = fi0->lev
  time  = fi0->time
  nlon  = dimsizes(lon)
  nlat  = dimsizes(lat)
  nlev  = dimsizes(lev)
  ntime = dimsizes(time)

  uc  = fi0->u
  t   = fi0->t
  phs = fi0->phs
  vor = fi0->vor
  z   = fi0->z

  u1   = fi1->ucomp
  ps1  = fi1->ps
  t1   = fi1->temp
  vor1 = fi1->vor
  h    = fi1->h
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
;******************************************
;
  ps_vtx = new((/ntime, nlat-1, nlon/), float)
  do it = 0, ntime-1
    do j = 0, nlat-2
      do i = 0, nlon-2
        ps_vtx(it,j,i) = (phs(it,j  ,i) + phs(it,j  ,i+1) +\
                          phs(it,j+1,i) + phs(it,j+1,i+1)) * 0.25
      end do
    end do
  end do
;******************************************
  interp = 2 ; type of interpolation: 1 = linear, 2 = log, 3 = loglog 
  extrap = False ; is extrapolation desired if data is outside the range of PS
  
  
  u700   = vinth2p(ua  , hyam, hybm, 700, phs, interp, 1000.0, 1, extrap)
  t700   = vinth2p(t   , hyam, hybm, 700, phs, interp, 1000.0, 1, extrap)
  vor700 = vinth2p(vor , hyam, hybm, 700, ps_vtx, interp, 1000.0, 1, extrap)
  z700   = vinth2p(z   , hyai, hybi, 700, phs, interp, 1000.0, 1, extrap)

  u700_1 = vinth2p(u1, hyam, hybm, 700, ps1, interp, 1000.0, 1, extrap)
  t700_1 = vinth2p(t1, hyam, hybm, 700, ps1, interp, 1000.0, 1, extrap)
  vor700_1 = vinth2p(vor1, hyam, hybm, 700, ps1, interp, 1000.0, 1, extrap)
  h700 = vinth2p(h , hyam, hybm, 700, ps1, interp, 1000.0, 1, extrap)
;=============================
slat = 30
slon = 90
srad = 1500 ; km
srad_unit = 1
N    = 180
opt  = False

circle = geolocation_circle(slat, slon, srad, srad_unit, N, opt)
circle_lat = circle[0]
circle_lon = circle[1]

ncirc = 100
circ_lat = new(ncirc, float)
circ_lon = new(ncirc, float)
cen_lat  = 30
cen_lon  = 90
nggcog(cen_lat, cen_lon, 30, circ_lat, circ_lon)

; ============================
  u700@long_name = "700 hPa zonal wind"
  u700@units     = "m/s"
  u700!0 = "time"
  u700&time = time
  u700!2 =  "lat"
  u700&lat = lat
  u700!3 = "lon"
  u700&lon = lon
  u700_1@long_name = "700 hPa zonal wind"
  u700_1@units     = "m/s"
  t700@long_name = "700 hPa Temperature"
  t700@units     = "K"
  vor700 = vor700 * 1.0e05
  vor700@long_name = "700 hPa rel. vorticity"
  vor700@units   = "s-1"
  vor700_1 = vor700_1 * 1.0e05
  vor700_1@long_name = "700 hPa rel. vorticity"
  vor700_1@units = "s-1"
  z700@long_name = "700 hPa geop. height"
  z700@units     = "m"
  h700@long_name = "700 hPa geop. height"
  h700@units     = "m"
;===================================
; (1)
;  wks = gsn_open_wks("ps", "u700_mz_gmcore_gfdl")
;  plots = new(6, graphic)
;  optArg             = True
;  optArg@mainstr     = ""
;  optArg@leftstr     = "700 hPa zonal wind at day 5 (m/s)"
;  optArg@rightstr    = "360x181L26"
;  contour_plot(wks, u700(5   ,0,:,:), 5, -10, 45, plots, 0, optArg, False)
;  optArg@rightstr    = "T85L26"
;  contour_plot(wks, u700_1(4 ,0,:,:), 5, -10, 45, plots, 1, optArg, False)
;
;  optArg@leftstr     = "day 15"
;  optArg@rightstr    = "360x181L26"
;  contour_plot(wks, u700(15  ,0,:,:), 5, -10, 45, plots, 2, optArg, False)
;  optArg@rightstr     = "T85L26"
;  contour_plot(wks, u700_1(14,0,:,:), 5, -10, 45, plots, 3, optArg, False)
;
;  optArg@leftstr     = "day 25"
;  optArg@rightstr    = "360x181L26"
;  contour_plot(wks, u700(25  ,0,:,:), 5, -10, 45, plots, 4, optArg, True)
;  optArg@rightstr     = "T85L26"
;  contour_plot(wks, u700_1(24,0,:,:), 5, -10, 45, plots, 5, optArg, True)
;  
;  plres                    = True
;  plres@gsLineColor        = "black"
;  plres@gsLineDashPattern  = 2
;  plres@gsLineThicknessF   = 3.0
;  dum = new(6, graphic)
;  do i = 0, 5 
;;    dum(i) = gsn_add_polyline(wks, plots(i), circle_lon(0,0,:), circle_lat(0,0,:), plres)
;    dum(i) = gsn_add_polyline(wks, plots(i), circ_lon, circ_lat, plres)
;  end do
;  
;  resp = True
;  resp@gsnPanelYWhiteSpacePercent = 0
;  resp@gsnPanelXWhiteSpacePercent = 5
;  gsn_panel(wks, plots, (/3,2/), resp)
;***********************
;(2)
;  wks = gsn_open_wks("ps", "t700_mz_gmcore_gfdl")
;  plots = new(6, graphic)
;  optArg             = True
;  optArg@mainstr     = ""
;  optArg@leftstr     = "700 hPa temperature at day 5 (K)"
;  optArg@rightstr    = "360x181L26"
;  contour_plot(wks, t700(5   ,0,:,:) , 3, 273, 300, plots, 0, optArg, False)
;  optArg@rightstr    = "T85L26"
;  contour_plot(wks, t700_1(4 ,0,:,:) , 3, 273, 300, plots, 1, optArg, False)
;
;  optArg@leftstr     = "day 15"
;  optArg@rightstr    = "360x181L26"
;  contour_plot(wks, t700(15  ,0,:,:) , 3, 273, 300, plots, 2, optArg, False)
;  optArg@rightstr    = "T85L26"
;  contour_plot(wks, t700_1(14,0,:,:) , 3, 273, 300, plots, 3, optArg, False)
;  optArg@leftstr     = "day 25"
;  optArg@rightstr    = "360x181L26"
;  contour_plot(wks, t700(25  ,0,:,:) , 3, 273, 300, plots, 4, optArg, True)
;  optArg@rightstr    = "T85L26"
;  contour_plot(wks, t700_1(24,0,:,:) , 3, 273, 300, plots, 5, optArg, True)
;  
;  plres                    = True
;  plres@gsLineColor        = "black"
;  plres@gsLineDashPattern  = 2
;  plres@gsLineThicknessF   = 3.0
;  dum = new(6, graphic)
;  do i = 0, 5 
;;    dum(i) = gsn_add_polyline(wks, plots(i), circle_lon(0,0,:), circle_lat(0,0,:), plres)
;    dum(i) = gsn_add_polyline(wks, plots(i), circ_lon, circ_lat, plres)
;  end do
;
;  resp = True
;  resp@gsnPanelYWhiteSpacePercent = 0
;  resp@gsnPanelXWhiteSpacePercent = 5
;  gsn_panel(wks, plots, (/3,2/), resp)
;=====================================
;(3)
  wks = gsn_open_wks("ps", "vor700_mz_gmcore_gfdl")
  plots = new(6, graphic)
  optArg             = True
  optArg@cnfillpalette = "ViBlGrWhYeOrRe"
  optArg@mainstr     = ""
  optArg@leftstr     = "700 hPa rel. vorticity at day 5 (10~S~-5~N~ s~S~-1~N~)"
  optArg@rightstr    = "360x181L26"
  contour_plot(wks, vor700(5   ,0,:,:) , 0.5, -5, 5, plots, 0, optArg, False)
  optArg@rightstr    = "T85L26"
  contour_plot(wks, vor700_1(4 ,0,:,:) , 0.5, -5, 5, plots, 1, optArg, False)

  optArg@leftstr     = "day 15"
  optArg@rightstr    = "360x181L26"
  contour_plot(wks, vor700(15  ,0,:,:) , 0.5, -5, 5, plots, 2, optArg, False)
  optArg@rightstr    = "T85L26"
  contour_plot(wks, vor700_1(14,0,:,:) , 0.5, -5, 5, plots, 3, optArg, False)
  optArg@leftstr     = "day 25"
  optArg@rightstr    = "360x181L26"
  contour_plot(wks, vor700(25  ,0,:,:) , 0.5, -5, 5, plots, 4, optArg, True)
  optArg@rightstr    = "T85L26"
  contour_plot(wks, vor700_1(24,0,:,:) , 0.5, -5, 5, plots, 5, optArg, True)
  
  plres                    = True
  plres@gsLineColor        = "black"
  plres@gsLineDashPattern  = 2
  plres@gsLineThicknessF   = 3.0
  dum = new(6, graphic)
  do i = 0, 5 
;    dum(i) = gsn_add_polyline(wks, plots(i), circle_lon(0,0,:), circle_lat(0,0,:), plres)
    dum(i) = gsn_add_polyline(wks, plots(i), circ_lon, circ_lat, plres)
  end do

  resp = True
  resp@gsnPanelYWhiteSpacePercent = 0
  resp@gsnPanelXWhiteSpacePercent = 5
  gsn_panel(wks, plots, (/3,2/), resp)
;=====================================
;(4)
;  wks = gsn_open_wks("ps", "z700_mz_gmcore_gfdl")
;  plots = new(6, graphic)
;  optArg             = True
;  optArg@cnfillpalette = "ncl_default"
;  optArg@mainstr     = ""
;  optArg@leftstr     = "700 hPa geopotential height (m) at day 5"
;  optArg@rightstr    = "360x181L26"
;  contour_plot(wks, z700(5   ,0,:,:) , 100, 2500, 3300, plots, 0, optArg, False)
;  optArg@rightstr    = "T85L26"
;  contour_plot(wks, h700(4 ,0,:,:) , 100, 2500, 3300, plots, 1, optArg, False)
;
;  optArg@leftstr     = "day 15"
;  optArg@rightstr    = "360x181L26"
;  contour_plot(wks, z700(15  ,0,:,:) , 100, 2500, 3300, plots, 2, optArg, False)
;  optArg@rightstr    = "T85L26"
;  contour_plot(wks, h700(14,0,:,:) , 100, 2500, 3300, plots, 3, optArg, False)
;  optArg@leftstr     = "day 25"
;  optArg@rightstr    = "360x181L26"
;  contour_plot(wks, z700(25  ,0,:,:) , 100, 2500, 3300, plots, 4, optArg, True)
;  optArg@rightstr    = "T85L26"
;  contour_plot(wks, h700(24,0,:,:) , 100, 2500, 3300, plots, 5, optArg, True)
;  
;  plres                    = True
;  plres@gsLineColor        = "black"
;  plres@gsLineDashPattern  = 2
;  plres@gsLineThicknessF   = 3.0
;  dum = new(6, graphic)
;  do i = 0, 5 
;;    dum(i) = gsn_add_polyline(wks, plots(i), circle_lon(0,0,:), circle_lat(0,0,:), plres)
;    dum(i) = gsn_add_polyline(wks, plots(i), circ_lon, circ_lat, plres)
;  end do
;  
;  resp = True
;  resp@gsnPanelYWhiteSpacePercent = 0
;  resp@gsnPanelXWhiteSpacePercent = 5
;  gsn_panel(wks, plots, (/3,2/), resp)
end
