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
  fname = "bw.360x181.l26.dt60.h0.nc"
  fi = addfile(fpath+fname, "r")
  
  lon   = fi->lon 
  lat   = fi->lat
  lev   = fi->lev
  time  = fi->time
  
  phs  = fi->phs
  t    = fi->t
  vor  = fi->vor
  
  nlat = dimsizes(lat)
  nlon = dimsizes(lon)
  ntime = dimsizes(time)

  ps_vtx = new((/ntime, nlat-1, nlon/), float)
  do it = 0, ntime-1
    do j = 0, nlat-2
      do i = 0, nlon-2
        ps_vtx(it,j,i) = (phs(it,j  ,i) + phs(it,j  ,i+1) +\
                          phs(it,j+1,i) + phs(it,j+1,i+1)) * 0.25
      end do
    end do
  end do
;************************************************
; define other arguments required by vinth2p
;************************************************
  interp = 2 ;  type of interpolation: 1 = linear, 2 = log, 3 = loglog 
  extrap = False ; is extrapolation desired if data is outside the range of PS
;************************************************
  t850    = vinth2p(t  , hyam, hybm, 850.0, phs   , interp, 1000.0, 1, extrap)
  vor850  = vinth2p(vor, hyam, hybm, 850.0, ps_vtx, interp, 1000.0, 1, extrap)
;  printVarSummary(vor850)
; ============================
;  wks = gsn_open_wks("ps", "bw_360x180.l26")
;  fo = "bw.360x181.01"
  fo = "baroclinic_wave_1deg"
  wks = gsn_open_wks("ps", fo)
; gsn_define_colormap(wks, "GMT_panoply")
  gsn_define_colormap(wks, "gui_default")
  plots = new(6, graphic)
  phs = phs / 100
  phs@long_name = "surface pressure"
  phs@units     = "hPa"
  copyatt(t, t850)
  t850@long_name = "850 hPa temperature"
  t850@units     = "K"
  vor850 = vor850 * 1.0e5
  vor850@long_name  = "850 hPa rel. vorticity"
  vor850@units      = "10~S~-5~N~ 1/s"
  day0 = 7
  day1 = 9
  contour_plot(wks, phs(day0,:,:), 4, 988, 1004, plots, 0, 7, True)
  contour_plot(wks, phs(day1,:,:), 10, 940, 1020, plots, 1, 9, True)
  contour_plot(wks, t850(day0,0,:,:), 10, 230, 300, plots, 2, 7, True)
  contour_plot(wks, t850(day1,0,:,:), 10, 230, 300, plots, 3, 9, True)
  contour_plot(wks, vor850(day0,0,:,:), 1,-2,5, plots, 4, 7, True) 
  contour_plot(wks, vor850(day1,0,:,:), 5,-5,30, plots, 5, 9, False) 
  resp = True
  resp@gsnPanelYWhiteSpacePercent = 0
  resp@gsnPanelXWhiteSpacePercent = 5
  gsn_panel(wks, plots, (/3,2/), resp)
;  cmd= "convert -trim -density 300 "+ fo + " " + fo +".png"
;  system(cmd)
end

