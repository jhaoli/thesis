;
load "./plot_polar_mod.ncl"
;
begin
  file_u_pole        = "./cp.swm.360x181.dt6.day10.stokes_off.h0.nc"
  file_u_pole_stokes = "./cp.swm.360x181.dt6.day10.stokes_on.h0.nc"
  file_v_pole        = "./cp.swm.360x180.dt3.day10.h0.nc"

  f_u_pole = addfile(file_u_pole, "r")
  z_u_pole = f_u_pole->z
  u_u_pole = f_u_pole->u
  v_u_pole = f_u_pole->v
  
  dsizes_ = dimsizes(z_u_pole)
  ntim = dsizes_(0)
  
  f_u_pole_stokes = addfile(file_u_pole_stokes, "r")
  z_u_pole_stokes = f_u_pole_stokes->z
  u_u_pole_stokes = f_u_pole_stokes->u
  v_u_pole_stokes = f_u_pole_stokes->v

  f_v_pole = addfile(file_v_pole, "r")
  z_v_pole = f_v_pole->z
  u_v_pole = f_v_pole->u
  v_v_pole = f_v_pole->v

; create plots
  out_name = "huv_cross_pole"
  wks = gsn_open_wks("eps", out_name)
  gsn_define_colormap(wks, "GMT_panoply")

  plots = new(9, graphic)
  
  polar_contour_plot(wks, z_u_pole(ntim-1,:,:), 100, 5200,  6500, plots, 0)
  polar_contour_plot(wks, u_u_pole(ntim-1,:,:),   4, -20 ,   20, plots, 1)
  polar_contour_plot(wks, v_u_pole(ntim-1,:,:),   2, -20 ,   20, plots, 2)

  polar_contour_plot(wks, z_u_pole_stokes(ntim-1,:,:), 100, 5200, 6500, plots, 3)
  polar_contour_plot(wks, u_u_pole_stokes(ntim-1,:,:),   4, -20 ,   20, plots, 4)
  polar_contour_plot(wks, v_u_pole_stokes(ntim-1,:,:),   2, -20 ,   20, plots, 5)
 
  polar_contour_plot(wks, z_v_pole(ntim-1,:,:), 100, 5200,6500, plots, 6)
  polar_contour_plot(wks, u_v_pole(ntim-1,:,:),  4, -20 ,  20, plots, 7)
  polar_contour_plot(wks, v_v_pole(ntim-1,:,:),  2, -20 ,  20, plots, 8)

  resp                            = True
  resp@gsnFrame                   = False
  resp@gsnPanelFigureStrings      = (/"(a)", "(b)", "(c)", "(d)", "(e)", "(f)", "(g)", "(h)", "(i)"/)
  resp@amJust                     = "TopLeft"
  resp@gsnPanelFigureStringsPerimOn = False
  resp@gsnPanelYWhiteSpacePercent = 2
  resp@gsnPanelXWhiteSpacePercent = 3
  gsn_panel(wks, plots, (/3,3/), resp)
  frame(wks)
;  system("convert -trim -density 300 " + out_name + ".eps" + " " + out_name + ".png")

end
