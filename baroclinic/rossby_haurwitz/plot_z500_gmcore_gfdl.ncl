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
  fname_gmcore = "rh4.360x181.l26.dt60.day110.00.h0.nc"
  fname_gfdl   = "rh4_t85_gfdl.nc"

  fi0 = addfile(fpath+fname_gmcore, "r")
  fi1 = addfile(fpath+fname_gfdl,"r")
  
  lon   = fi0->lon 
  lat   = fi0->lat
  time  = fi0->time
  lev   = fi0->lev
  
  ntime = dimsizes(time)
  nlev  = dimsizes(lev)
  nlat  = dimsizes(lat)
  nlon  = dimsizes(lon)
  
  phs0  = fi0->phs
  z0    = fi0->z

  phs1  = fi1->ps
  z1    = fi1->h

;=======================  
  interp = 2; type of interpolation: 1 = linear, 2 = log, 3 = loglog
  extrap = False ; is extrapolation desired if data is outside the range of PS
   
  z500_0  = vinth2p(z0  , hyai, hybi, 500, phs0, interp, 1000.0, 1, extrap)
  z500_1  = vinth2p(z1  , hyam, hybm, 500, phs1, interp, 1000.0, 1, extrap)
;  printVarSummary(z500_0)
;  exit
; ============================
; (1)
  
  z500_0@long_name = "geopotential height at 500 hPa"
  z500_0@units     = "m"
;=============================
  res                           = True
  res@gsnFrame                  = False
  res@gsnDraw                   = False
  res@cnLinesOn                 = True
  res@cnFillOn                  = False
  res@gsnAddCyclic              = True
  res@gsnPolar                  = "NH"
  res@gsnLeftString             = ""
  res@gsnRightString            = ""
  res@cnLevelSelectionMode      = "ManualLevels"
  res@cnLineLabelBackgroundColor= "white"
  res@cnLineThicknessF          = 1.4
  res@cnMinLevelValF            = 5200
  res@cnMaxLevelValF            = 5600
  res@cnLevelSpacingF           = 100
  res@cnExplicitLegendLabelsOn  = False
  res@cnExplicitLineLabelsOn    = False
  res@cnInfoLabelOn             = False
  res@cnLineLabelDensityF       = 2
  res@tiMainOffsetYF            = 0.01
  res@tiMainFontThicknessF      = 0.1
  res@mpGridAndLimbOn           = True
  res@mpPerimOn                 = False
  res@mpOutlineOn               = False
  res@mpFillOn                  = False

  wks = gsn_open_wks("ps", "z500_rh4_gmcore_gfdl")
; gsn_define_colormap(wks, "GMT_panoply")
  gsn_define_colormap(wks, "gui_default")
  plots = new(6, graphic)

  day = 26
  res@tiMainString              = "360x181L26 day " + tostring(day)
  plots(0) = gsn_csm_contour_map_polar(wks, z500_0(day,0,:,:), res)
    
  day = 52
  res@tiMainString              = "360x181L26 day " + tostring(day)
  plots(1) = gsn_csm_contour_map_polar(wks, z500_0(day,0,:,:), res)
  
  day = 78
  res@tiMainString              = "360x181L26 day " + tostring(day)
  plots(2) = gsn_csm_contour_map_polar(wks, z500_0(day,0,:,:), res)

  day = 26
  res@tiMainString              = "T85L26 day " + tostring(day)
  plots(3) = gsn_csm_contour_map_polar(wks, z500_1(day-1,0,:,:), res)

  day = 52
  res@tiMainString              = "T85L26 day " + tostring(day)
  plots(4) = gsn_csm_contour_map_polar(wks, z500_1(day-1,0,:,:), res)
  
  day = 78
  res@tiMainString              = "T85L26 day " + tostring(day)
  plots(5) = gsn_csm_contour_map_polar(wks, z500_1(day-1,0,:,:), res)


  resp = True
  resp@gsnPanelYWhiteSpacePercent = 3
  resp@gsnPanelXWhiteSpacePercent = 2
  gsn_panel(wks, plots, (/2,3/), resp)

end

