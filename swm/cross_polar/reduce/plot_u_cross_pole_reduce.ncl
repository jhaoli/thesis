;
load "./plot_polar_mod.ncl"
;
begin
  file0 = "./cp.swm.360x181.dt6.upwind.h0.nc"
  file1 = "./cp.swm.360x181.dt60.upwind.h0.nc"

  f0 = addfile(file0, "r")
  u0 = f0->u
  v0 = f0->v

  dsizes_ = dimsizes(u0)
  ntim = dsizes_(0)
  
  f1 = addfile(file1, "r")
  u1 = f1->u
  v1 = f1->v

; create plots
  out_name = "u_cross_pole_reduce"
  wks = gsn_open_wks("eps", out_name)
  gsn_define_colormap(wks, "GMT_panoply")

  plots = new(4, graphic)
  
  polar_contour_plot(wks, u0(ntim-1,:,:),   4, -20 ,   20, plots, 0)
  polar_contour_plot(wks, v0(ntim-1,:,:),   4, -20 ,   20, plots, 1)
  polar_contour_plot(wks, u1(ntim-1,:,:),   4, -20 ,   20, plots, 2)
  polar_contour_plot(wks, v1(ntim-1,:,:),   4, -20 ,   20, plots, 3)

  resp                            = True
  resp@gsnFrame                   = False
  resp@gsnPanelFigureStrings      = (/"(a)", "(b)", "(c)", "(d)"/)
  resp@amJust                     = "TopLeft"
  resp@gsnPanelFigureStringsPerimOn = False
  resp@gsnPanelYWhiteSpacePercent = 2
  resp@gsnPanelXWhiteSpacePercent = 3
  gsn_panel(wks, plots, (/2,2/), resp)
  frame(wks)
;  system("convert -trim -density 300 " + out_name + ".eps" + " " + out_name + ".png")

end
