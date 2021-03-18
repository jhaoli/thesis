;
load "./plot_polar_mod.ncl"
;
begin
  file_u_E         = "./mz.swm.360x181.dt8.stokes_off.E_midpoint.h0.nc"
  file_u_PE        = "./mz.swm.360x181.dt8.stokes_off.PE_midpoint.h0.nc"
  file_u_E_stokes  = "./mz.swm.360x181.dt8.stokes_on.E_midpoint.h0.nc"
  file_u_PE_stokes = "./mz.swm.360x181.dt8.stokes_on.PE_midpoint.h0.nc"
  file_v_E         = "./mz.swm.360x180.dt3.day20.E_midpoint.h0.nc"
  file_v_PE        = "./mz.swm.360x180.dt3.day20.PE_midpoint.h0.nc"

  f_u_E = addfile(file_u_E, "r")
  u_u_E = f_u_E->u
  
  dsizes_ = dimsizes(u_u_E)
  ntim = dsizes_(0)
  
  f_u_PE = addfile(file_u_PE, "r")
  u_u_PE = f_u_PE->u

  f_u_E_stokes = addfile(file_u_E_stokes, "r")
  u_u_E_stokes = f_u_E_stokes->u

  f_u_PE_stokes = addfile(file_u_PE_stokes, "r")
  u_u_PE_stokes = f_u_PE_stokes->u

  f_v_E = addfile(file_v_E, "r")
  u_v_E = f_v_E->u

  f_v_PE = addfile(file_v_PE, "r")
  u_v_PE = f_v_PE->u


; create plots
  out_name = "u_mountain_wave"
  wks = gsn_open_wks("eps", out_name)
  gsn_define_colormap(wks, "GMT_panoply")

  plots = new(6, graphic)
  day = 20
  polar_contour_plot(wks, u_u_E(day,:,:)       ,   4, -16,  38, plots, 0)
  polar_contour_plot(wks, u_u_PE(day,:,:)      ,   4, -16,  38, plots, 1)
  
  polar_contour_plot(wks, u_u_E_stokes(day,:,:)  ,   4, -16,  38, plots, 2)
  polar_contour_plot(wks, u_u_PE_stokes(day,:,:) ,   4, -16,  38, plots, 3)

  polar_contour_plot(wks, u_v_E(day,:,:)  ,   4, -16,  38, plots, 4)
  polar_contour_plot(wks, u_v_PE(day,:,:) ,   4, -16,  38, plots, 5)

  resp                            = True
  resp@gsnFrame                   = False
  resp@gsnPanelFigureStrings      = (/"(a)", "(b)", "(c)", "(d)", "(e)", "(f)"/)
  resp@amJust                     = "TopLeft"
  resp@gsnPanelFigureStringsPerimOn = False
  resp@gsnPanelYWhiteSpacePercent = 2
  resp@gsnPanelXWhiteSpacePercent = 3
  resp@gsnPanelLabelBar           = True
  resp@lbOrientation              = "Vertical"

  gsn_panel(wks, plots, (/3,2/), resp)
  frame(wks)
;  system("convert -trim -density 300 " + out_name + ".eps" + " " + out_name + ".png")

end
