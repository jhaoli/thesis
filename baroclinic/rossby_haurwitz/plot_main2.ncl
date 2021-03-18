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
;  fpath = "/Users/hao/Documents/work/Models/taiyuan_dl/GMCORE/build.ifort/rh4.360x180/"
  fpath = "./"
  fname0 = "rh4.360x181.l26.dt60.day110.00.h0.nc"
  fname1 = "rh4_t85_gfdl.nc"

  fi0 = addfile(fpath+fname0, "r")
  fi1 = addfile(fpath+fname1, "r")

  lon   = fi0->lon 
  lat   = fi0->lat
  time  = fi0->time
  lev   = fi0->lev
  
  nlev  = dimsizes(lev)
  nlat  = dimsizes(lat)
  nlon  = dimsizes(lon)

  day = 15
  uc   = fi0->u(day,:,:,:)
  vc   = fi0->v(day,:,:,:)
  phs  = fi0->phs(day,:,:)
  t    = fi0->t(day,:,:,:)
  wp   = fi0->wp(day,:,:,:)
  vor  = fi0->vor(day,:,:,:)
  div  = fi0->div(day,:,:,:)

  ps    = fi1->ps(day-1,:,:)
  ucomp = fi1->ucomp(day-1,:,:,:)
  vcomp = fi1->vcomp(day-1,:,:,:)
  temp  = fi1->temp(day-1,:,:,:)
  omega = fi1->omega(day-1,:,:,:)
  div_1  = fi1->div(day-1,:,:,:)
	vor_1  = fi1->vor(day-1,:,:,:)

;******************************************
; convert the C grid to A grid for u and v wind.
  uctmp = new((/nlev, nlat, nlon/), typeof(uc))
  ua    = new((/nlev, nlat, nlon/), typeof(uc))

  uc1 = new((/nlev, nlat, nlon-1/), typeof(uc))
  uc2 = new((/nlev, nlat, nlon-1/), typeof(uc))
  uc1 = uc(:,:,0:nlon-2)
  uc2 = uc(:,:,1:nlon-1)
  uctmp(:,:,1:nlon-1) = (uc1 + uc2) * 0.5
  uctmp(:,:,0) = (uc(:,:,0) + uc(:,:,nlon-1)) * 0.5
  ua = uctmp(:,:,:)
  delete(uctmp)
  
  va = new((/nlev, nlat, nlon/), typeof(vc))
  vc1 = vc(:,0:nlat-3,:)
  vc2 = vc(:,1:nlat-2,:)
  va(:,1:nlat-2,:) = (vc1 + vc2) * 0.5
;  printVarSummary(va)
;******************************************
;
	ps_vtx = new((/nlat-1, nlon/), float)
    do j = 0, nlat-2
      do i = 0, nlon-2
        ps_vtx(j,i) = (phs(j  ,i) + phs(j  ,i+1) +\
                       phs(j+1,i) + phs(j+1,i+1)) * 0.25
      end do
    end do
;******************************************
;
  interp = 2; type of interpolation: 1 = linear, 2 = log, 3 = loglog
  extrap = False ; is extrapolation desired if data is outside the range of PS
   
  u850  = vinth2p(ua , hyam, hybm, 850, phs, interp, 1000.0, 1, extrap)
  v850  = vinth2p(va , hyam, hybm, 850, phs, interp, 1000.0, 1, extrap)
  t850  = vinth2p(t  , hyam, hybm, 850, phs, interp, 1000.0, 1, extrap)
  wp850 = vinth2p(wp , hyam, hybm, 850, phs, interp, 1000.0, 1, extrap)
  div850 = vinth2p(div , hyam, hybm, 850, phs, interp, 1000.0, 1, extrap)
	vor850 = vinth2p(vor , hyam, hybm, 850, ps_vtx, interp, 1000.0, 1, extrap)

  u850_1 = vinth2p(ucomp, hyam, hybm, 850, ps, interp, 1000.0, 1, extrap)
  v850_1 = vinth2p(vcomp, hyam, hybm, 850, ps, interp, 1000.0, 1, extrap)
  t850_1 = vinth2p(temp , hyam, hybm, 850, ps, interp, 1000.0, 1, extrap)
  omega850 = vinth2p(omega , hyam, hybm, 850, ps, interp, 1000.0, 1, extrap)
  div850_1 = vinth2p(div_1 , hyam, hybm, 850, ps, interp, 1000.0, 1, extrap)
  vor850_1 = vinth2p(vor_1 , hyam, hybm, 850, ps, interp, 1000.0, 1, extrap)
  
;  printMinMax(z500, False)
;  exit
; ============================
; (1)
  
  u850@long_name = "zonal wind at 850 hPa"
  u850@units     = "m/s"
  u850!1 = "lat"
  u850!2 = "lon"
  u850&lat = lat
  u850&lon = lon

  v850@long_name = "meridional wind at 850 hPa"
  v850@units     = "m/s"
  copy_VarCoords(u850, v850)

  phs = phs / 100.0
  phs@long_name  = "surface pressure"
  phs@units      = "hPa"
  ps = ps / 100.0
  ps@long_name   = "surface pressure"
  ps@units       = "hpa"

  t850@long_name = "temperature at 850 hPa"
  t850@units     = "K"

  wp850@long_name= "vertical pressure velocity at 850 hPa"
  wp850@units    = "Pa/s"
  div850   = div850   * 1.0e06
  div850_1 = div850_1 * 1.0e06

	vor850   = vor850   * 1.0e05
	vor850_1 = vor850_1 * 1.0e05

  wks = gsn_open_wks("ps", "uvt_rh4_gmcore_gfdl")
; gsn_define_colormap(wks, "GMT_panoply")
;  gsn_define_colormap(wks, "gui_default")
  plots = new(6, graphic)
  optArg          = True
  optArg@leftstr  = "zonal wind at 850 hPa (m/s)"
  optArg@rightstr = "360x181L26" 

  contour_plot(wks, u850(0  ,:,:), 2, 0, 24, plots, 0, optArg)
  optArg@rightstr = "T85L26"
  contour_plot(wks, u850_1(0,:,:), 2, 0, 24, plots, 1, optArg)

  optArg@leftstr  = "meridional wind at 850 hPa (m/s)"
  optArg@rightstr = "360x181L26" 
  contour_plot(wks, v850(0  ,:,:), 2, -14, 14, plots, 2, optArg)
  optArg@rightstr = "T85L26"
  contour_plot(wks, v850_1(0,:,:), 2, -14, 14, plots, 3, optArg)

  optArg@leftstr  = "temperature at 850 hPa (K)"
  optArg@rightstr = "360x181L26" 
  contour_plot(wks, t850(0  ,:,:), 0.04, 281.44, 281.92, plots, 4, optArg)
  optArg@rightstr = "T85L26" 
  contour_plot(wks, t850_1(0,:,:), 0.04, 281.44, 281.92, plots, 5, optArg)

  resp = True
  resp@gsnPanelYWhiteSpacePercent = 0
  resp@gsnPanelXWhiteSpacePercent = 5
  gsn_panel(wks, plots, (/3,2/), resp)

;===========================
  wks = gsn_open_wks("ps", "vordivomega_rh4_gmcore_gfdl")
; gsn_define_colormap(wks, "GMT_panoply")
;  gsn_define_colormap(wks, "gui_default")
  plots                 = new(6, graphic)
  optArg                = True
  optArg@cnfillpalette  = "ViBlGrWhYeOrRe"
  optArg@leftstr        = "850 hPa rel. vorticity (10~S~-5~N~ s~S~-1~N~)"
  optArg@rightstr       = "360x181L26"
  contour_plot(wks, vor850(0  ,:,:), 0.5, -2.5, 2.5, plots, 0, optArg)
  optArg@rightstr       = "T85L26"
  contour_plot(wks, vor850_1(0,:,:), 0.5, -2.5, 2.5, plots, 1, optArg)

  optArg@leftstr        = "850 hPa divergence (10~S~-6~N~ s~S~-1~N~)"
  optArg@rightstr       = "360x181L26"
  contour_plot(wks, div850(0  ,:,:), 0.2, -1, 1, plots, 2, optArg)
  optArg@rightstr       = "T85L26"
  contour_plot(wks, div850_1(0,:,:), 0.2, -1, 1, plots, 3, optArg)
  optArg@leftstr        = "850 hPa omega (Pa/s)"
  optArg@rightstr       = "360x181L26"

  contour_plot(wks, wp850(0   ,:,:), 0.005, -0.02, 0.02, plots, 4, optArg)
  optArg@rightstr       = "T85L26"
  contour_plot(wks, omega850(0,:,:), 0.005, -0.02, 0.02, plots, 5, optArg)

  resp = True
  resp@gsnPanelYWhiteSpacePercent = 0
  resp@gsnPanelXWhiteSpacePercent = 5
  gsn_panel(wks, plots, (/3,2/), resp)

end

