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
  fname0 = "bw.360x181.l26.dt60.01.h0.nc"
  fname1 = "bw_t85_gfdl.nc"

  fi0 = addfile(fpath+fname0, "r")
  fi1 = addfile(fpath+fname1, "r")

  lon   = fi0->lon 
  lat   = fi0->lat
  lev   = fi0->lev
  time  = fi0->time
  
  ps_0   = fi0->phs
  t_0    = fi0->t
  vor_0  = fi0->vor
  
  ps_1   = fi1->ps
  t_1    = fi1->temp
  vor_1  = fi1->vor

  nlat = dimsizes(lat)
  nlon = dimsizes(lon)
  ntime = dimsizes(time)

  ps_vtx = new((/ntime, nlat-1, nlon/), float)
  do it = 0, ntime-1
    do j = 0, nlat-2
      do i = 0, nlon-2
        ps_vtx(it,j,i) = (ps_0(it,j  ,i) + ps_0(it,j  ,i+1) + \
                          ps_0(it,j+1,i) + ps_0(it,j+1,i+1)) * 0.25
      end do
    end do
  end do
;************************************************
; define other arguments required by vinth2p
;************************************************
  interp = 2 ;  type of interpolation: 1 = linear, 2 = log, 3 = loglog 
  extrap = False ; is extrapolation desired if data is outside the range of PS
;************************************************
  t850_0    = vinth2p(t_0  , hyam, hybm, 850.0, ps_0 , interp, 1000.0, 1, extrap)
  vor850_0  = vinth2p(vor_0, hyam, hybm, 850.0, ps_vtx, interp, 1000.0, 1, extrap)
  t850_1    = vinth2p(t_1  , hyam, hybm, 850.0, ps_1  , interp, 1000.0, 1, extrap)
  vor850_1  = vinth2p(vor_1, hyam, hybm, 850.0, ps_1  , interp, 1000.0, 1, extrap)
;  printVarSummary(vor850)
; ============================
  ps_0 = ps_0 / 100.0
  ps_0@long_name = "surface pressure"
  ps_0@units     = "hPa"

  ps_1 = ps_1 / 100.0
  ps_1@long_name = "surface pressure"
  ps_1@units     = "hPa"
  copyatt(t_0, t850_0)

  t850_0@long_name = "850 hPa temperature"
  t850_0@units     = "K"

  t850_1@long_name = "850 hPa temperature"
  t850_1@units     = "K"

  vor850_0 = vor850_0 * 1.0e5
  vor850_0@long_name  = "850 hPa rel. vorticity"
  vor850_0@units      = "10~S~-5~N~ 1/s"

  vor850_1 = vor850_1 * 1.0e5
  vor850_1@long_name  = "850 hPa rel. vorticity"
  vor850_1@units      = "10~S~-5~N~ 1/s"
  
  fo = "ps_bw_gmcore_gfdl"
  wks = gsn_open_wks("ps", fo)
  plots = new(10, graphic)
  
  optArg              = True
  cmap = read_colormap_file("matlab_hsv")
  colormap = (/cmap(54,:), cmap(45,:), cmap(20,:), cmap(14,:), cmap(11,:), cmap(7,:), cmap(0,:)/)
  optArg@cnfillpalette   = colormap
  optArg@mainstr      = ""
  optArg@leftstr      = "surface pressure (hPa) at day 4"
  optArg@rightstr     = "360x181L26"
  day = 4
  contour_plot(wks, ps_0(day  ,:,:), 1, 993, 1005, plots, 0, optArg, True, False)
  optArg@rightstr      = "T85L26"
  contour_plot(wks, ps_1(day-1,:,:), 1, 993, 1005, plots, 1, optArg, True, False)
  day = 6
  optArg@leftstr      = ""
  optArg@rightstr     = "360x181L26"
  optArg@mainstr      = "day 6"
  contour_plot(wks, ps_0(day  ,:,:), 1, 993, 1005, plots, 2, optArg, True, True)
  optArg@rightstr      = "T85L26"
  contour_plot(wks, ps_1(day-1,:,:), 1, 993, 1005, plots, 3, optArg, True, True)

  cmap = read_colormap_file("matlab_hsv")
  delete(colormap)
  colormap = (/cmap(54,:), cmap(50,:), cmap(46,:), cmap(38,:), cmap(32,:), cmap(21,:), cmap(15,:), cmap(11,:), cmap(7,:), cmap(0,:)/)
  day = 7
  optArg = True
  optArg@mainstr   = "day 7"
  optArg@rightstr     = "360x181L26"
  delete_VarAtts(optArg, "cnfillpalette")
  optArg@cnfillpalette   = colormap
  contour_plot(wks, ps_0(day  ,:,:), 10, 940, 1020, plots, 4, optArg, True, False)
  optArg@rightstr      = "T85L26"
  contour_plot(wks, ps_1(day-1,:,:), 10, 940, 1020, plots, 5, optArg, True, False)
  day = 8
  optArg@mainstr   = "day 8"
  optArg@rightstr     = "360x181L26"
  contour_plot(wks, ps_0(day  ,:,:), 10, 940, 1020, plots, 6, optArg, True, False)
  optArg@rightstr      = "T85L26"
  contour_plot(wks, ps_1(day-1,:,:), 10, 940, 1020, plots, 7, optArg, True, False)

  day = 10
  optArg@mainstr   = "day 10"
  optArg@rightstr     = "360x181L26"
  contour_plot(wks, ps_0(day  ,:,:), 10, 940, 1020, plots, 8, optArg, True, True)
  optArg@rightstr      = "T85L26"
  contour_plot(wks, ps_1(day-1,:,:), 10, 940, 1020, plots, 9, optArg, True, True)

  resp = True
  resp@gsnPanelYWhiteSpacePercent = 10
  resp@gsnPanelXWhiteSpacePercent = 5
  gsn_panel(wks, plots, (/5,2/), resp)
;====================================

  fo = "t850_bw_gmcore_gfdl"
  wks = gsn_open_wks("ps", fo)
  plots = new(10, graphic)
  cmap = read_colormap_file("matlab_hsv")
  delete(colormap)
  colormap = (/cmap(50,:), cmap(44,:), cmap(36,:), cmap(32,:), cmap(20,:), cmap(13,:), cmap(11,:), cmap(7,:), cmap(0,:)/)
  
  optArg              = True
  delete_VarAtts(optArg, "cnfillpalette")
  optArg@cnfillpalette = colormap
  optArg@mainstr      = ""
  optArg@leftstr      = "850 hPa temperature (K) at day 4"
  optArg@rightstr     = "360x181L26"
  day = 4
  contour_plot(wks, t850_0(day  ,0,:,:), 10, 230, 300, plots, 0, optArg, True, False)
  optArg@rightstr     = "T85L26"
  contour_plot(wks, t850_1(day-1,0,:,:), 10, 230, 300, plots, 1, optArg, True, False)
  
  day = 6
  optArg@mainstr      = "day 6"
  optArg@leftstr      = ""
  optArg@rightstr     = "360x181L26"
  contour_plot(wks, t850_0(day  ,0,:,:), 10, 230, 300, plots, 2, optArg, True, False)
  optArg@rightstr     = "T85L26"
  contour_plot(wks, t850_1(day-1,0,:,:), 10, 230, 300, plots, 3, optArg, True, False)

  day = 7
  optArg@mainstr      = "day 7"
  optArg@leftstr      = ""
  optArg@rightstr     = "360x181L26"
  contour_plot(wks, t850_0(day  ,0,:,:), 10, 230, 300, plots, 4, optArg, True, False)
  optArg@rightstr     = "T85L26"
  contour_plot(wks, t850_1(day-1,0,:,:), 10, 230, 300, plots, 5, optArg, True, False)

  day = 8
  optArg@mainstr      = "day 8"
  optArg@leftstr      = ""
  optArg@rightstr     = "360x181L26"
  contour_plot(wks, t850_0(day  ,0,:,:), 10, 230, 300, plots, 6, optArg, True, False)
  optArg@rightstr     = "T85L26"
  contour_plot(wks, t850_1(day-1,0,:,:), 10, 230, 300, plots, 7, optArg, True, False)

  day = 10
  optArg@mainstr      = "day 10"
  optArg@leftstr      = ""
  optArg@rightstr     = "360x181L26"
  contour_plot(wks, t850_0(day  ,0,:,:), 10, 230, 300, plots, 8, optArg, True, True)
  optArg@rightstr     = "T85L26"
  contour_plot(wks, t850_1(day-1,0,:,:), 10, 230, 300, plots, 9, optArg, True, True)

  resp = True
  resp@gsnPanelYWhiteSpacePercent = 0
  resp@gsnPanelXWhiteSpacePercent = 5
  gsn_panel(wks, plots, (/5,2/), resp)
;==============================================
  fo = "vor850_bw_gmcore_gfdl"
  wks = gsn_open_wks("ps", fo)
  plots = new(10, graphic)
  delete(cmap)
  cmap = read_colormap_file("BlRe")
  delete(colormap)
  colormap = (/cmap(30,:), cmap(35,:), cmap(40,:), cmap(45,:), cmap(48,:), cmap(53,:), cmap(60,:), cmap(67,:), cmap(74,:), cmap(81,:)/)
  
  optArg              = True
  delete_VarAtts(optArg, "cnfillpalette")
  optArg@cnfillpalette = colormap
  optArg@mainstr      = ""
  optArg@leftstr      = "850 hPa relative vorticity (10~S~-5~N~ s~S~-1~N~) at day 4"
  optArg@rightstr     = "360x181L26"
  day = 4
  contour_plot(wks, vor850_0(day  ,0,:,:), 1, -3, 5, plots, 0, optArg, False, False)
  optArg@rightstr     = "T85L26"
  contour_plot(wks, vor850_1(day-1,0,:,:), 1, -3, 5, plots, 1, optArg, False, False)
  
  day = 6
  optArg@mainstr      = "day 6"
  optArg@leftstr      = ""
  optArg@rightstr     = "360x181L26"
  contour_plot(wks, vor850_0(day  ,0,:,:), 1, -3, 5, plots, 2, optArg, False, True)
  optArg@rightstr     = "T85L26"
  contour_plot(wks, vor850_1(day-1,0,:,:), 1, -3, 5, plots, 3, optArg, False, True)
   
  delete(colormap)
  colormap = (/ cmap(35,:), cmap(40,:), cmap(45,:), cmap(48,:), cmap(53,:), cmap(58,:), cmap(63,:), cmap(68,:), cmap(73,:), cmap(78,:), cmap(83,:)/)
  
  optArg              = True
  delete_VarAtts(optArg, "cnfillpalette")
  optArg@cnfillpalette = colormap
  day = 7
  optArg@mainstr      = "day 7"
  optArg@leftstr      = ""
  optArg@rightstr     = "360x181L26"
  contour_plot(wks, vor850_0(day  ,0,:,:), 5, -10, 35, plots, 4, optArg, False, False)
  optArg@rightstr     = "T85L26"
  contour_plot(wks, vor850_1(day-1,0,:,:), 5, -10, 35, plots, 5, optArg, False, False)

  day = 8
  optArg@mainstr      = "day 8"
  optArg@leftstr      = ""
  optArg@rightstr     = "360x181L26"
  contour_plot(wks, vor850_0(day  ,0,:,:), 5, -10, 35, plots, 6, optArg, False, False)
  optArg@rightstr     = "T85L26"
  contour_plot(wks, vor850_1(day-1,0,:,:), 5, -10, 35, plots, 7, optArg, False, False)

  day = 10
  optArg@mainstr      = "day 10"
  optArg@leftstr      = ""
  optArg@rightstr     = "360x181L26"
  contour_plot(wks, vor850_0(day  ,0,:,:), 5, -10, 35, plots, 8, optArg, False, True)
  optArg@rightstr     = "T85L26"
  contour_plot(wks, vor850_1(day-1,0,:,:), 5, -10, 35, plots, 9, optArg, False, True)

  resp = True
  resp@gsnPanelYWhiteSpacePercent = 10
  resp@gsnPanelXWhiteSpacePercent = 5
  gsn_panel(wks, plots, (/5,2/), resp)
;  cmd= "convert -trim -density 300 "+ fo + " " + fo +".png"
;  system(cmd)
end

