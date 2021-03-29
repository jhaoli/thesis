load "./plot_mod.ncl"
begin
  
  file0  = "./rh4.swm.360x181.dt6.h0.nc"
  file1 = "./rh4.swm.360x181.dt60.h0.nc"
  
  f0 = addfile(file0, "r")
  f1 = addfile(file1, "r")
  
  day = 100
  z0 = f0->z(day,:,:)
  z1 = f1->z(day,:,:)
  vor0 = f0->vor(day,:,:)
  vor1 = f1->vor(day,:,:)
  div0 = f0->div(day,:,:)
  div1 = f1->div(day,:,:)

  vor0 = vor0 * 1.e05
  vor1 = vor1 * 1.e05
  div0 = div0 * 1.e06
  div1 = div1 * 1.e06
  figure_name = "z_vor_div_rh4_swm_day100_reduce" 
  wks = gsn_open_wks("ps", figure_name)
  plots = new(6, graphic)

  optArg = True
  optArg@cnfillpalette        = "WhBlGrYeRe"; "GMT_panoply"
  optArg@leftstr   = "height (m) at day 100"
  optArg@rightstr  = "(a) dt=6s"
  contour_plot(wks, z0, 200, 8000, 10500, plots, 0, optArg, True, True)
  optArg@rightstr  = "(b) dt=60s"
  contour_plot(wks, z1, 200, 8000, 10500, plots, 1, optArg, True, True)
  optArg@cnfillpalette        = "ncl_default"
  optArg@leftstr   = "relative vorticity (10~S~-5~N~s~S~-1~N~) at day 100"
  optArg@rightstr  = "(c) dt=6s"
  contour_plot(wks, vor0, 1,   -9,     9, plots, 2, optArg, False, True)
  optArg@rightstr  = "(d) dt=60s"
  contour_plot(wks, vor1, 1,   -9,     9, plots, 3, optArg, False, True)
  optArg@leftstr   = "divergence (10~S~-6~N~s~S~-1~N~) at day 100"
  optArg@rightstr  = "(e) dt=6s"
  contour_plot(wks, div0, 0.2, -2,     2, plots, 4, optArg, False, True)
  optArg@rightstr  = "(f) dt=60s"
  contour_plot(wks, div1, 0.2, -2,     2, plots, 5, optArg, False, True)

  res_panel = True
  gsn_panel(wks, plots, (/3,2/), res_panel)

end
;print("Run the following command to postprocess figure:")
;print("pdfcrop " + figure_name + ".pdf && convert -density 300 " + figure_name + "-crop.pdf " + figure_name + ".png")
