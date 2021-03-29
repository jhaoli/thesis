load "./plot_mod.ncl"
begin
  
  file0 = "./mz.swm.360x181.dt8.h0.nc"
  file1 = "./mz.swm.360x181.dt60.h0.nc"
  
  f0 = addfile(file0, "r")
  f1 = addfile(file1, "r")

  z0 = f0->z(50,:,:)
  z1 = f1->z(50,:,:)
  vor0 = f0->vor(50,:,:)
  vor1 = f1->vor(50,:,:)
;====================================
ncirc = 100
circ_lat = new(ncirc, float)
circ_lon = new(ncirc, float)
cen_lat  = 30
cen_lon  = 270
nggcog(cen_lat, cen_lon, 30, circ_lat, circ_lon)
;===================================
  figure_name = "z_vor_mz_swm_1deg_day50" 
  wks = gsn_open_wks("ps", figure_name)
  plots = new(4, graphic)

  vor0 = vor0 * 1.e05
  vor1 = vor1 * 1.e05

  optArg = True
  optArg@mainstr    = ""
  optArg@leftstr    = "height (m) at day 50"
  optArg@rightstr   = "(a) dt=8s"
  contour_plot(wks, z0  , 100, 5000, 6000, plots, 0, optArg, True, True)
  optArg@rightstr    = "(b) dt=60s"
  contour_plot(wks, z1  , 100, 5000, 6000, plots, 1, optArg, True, True)
  
  optArg@cnfillpalette   = "ncl_default"
  optArg@rightstr   = "(c) dt=8s"
  optArg@leftstr   = "relative vorticity (10~S~-5~N~s~S~-1~N~) at day 50"
  contour_plot(wks, vor0, 0.5, -8  , 8   , plots, 2, optArg, False, True)
  optArg@rightstr   = "(d) dt=60s"
  contour_plot(wks, vor1, 0.5, -8  , 8   , plots, 3, optArg, False, True)

  plres                    = True
  plres@gsLineColor        = "black"
  plres@gsLineDashPattern  = 2
  plres@gsLineThicknessF   = 3.0
  dum = new(4, graphic)
  do i = 0, 3
;    dum(i) = gsn_add_polyline(wks, plots(i), circle_lon(0,0,:), circle_lat(0,0,:), plres)
    dum(i) = gsn_add_polyline(wks, plots(i), circ_lon, circ_lat, plres)
  end do

  resp = True
  gsn_panel(wks, plots, (/2,2/), resp)

end
;print("Run the following command to postprocess figure:")
;print("pdfcrop " + figure_name + ".pdf && convert -density 300 " + figure_name + "-crop.pdf " + figure_name + ".png")
