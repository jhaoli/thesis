;
load "./plot_polar_mod.ncl"
;
begin
  file_e_apvm        = "./cp.swm.360x181.dt6.day10.stokes_off.E_upwind3_wgt0.25.h0.nc"
  file_pe_midpoint   = "./cp.swm.360x181.dt6.day10.stokes_off.PE_midpoint.h0.nc"
  file_pe_apvm       = "./cp.swm.360x181.dt6.day10.stokes_off.PE_upwind3_wgt0.25.h0.nc"

  f_e_apvm = addfile(file_e_apvm, "r")
  u_e_apvm = f_e_apvm->u
  
  dsizes_ = dimsizes(u_e_apvm)
  ntim = dsizes_(0)
  
  f_pe_midpoint = addfile(file_pe_midpoint, "r")
  u_pe_midpoint = f_pe_midpoint->u

  f_pe_apvm = addfile(file_pe_apvm, "r")
  u_pe_apvm = f_pe_apvm->u

; create plots
  out_name = "u_cross_pole"
  wks = gsn_open_wks("eps", out_name)
  gsn_define_colormap(wks, "GMT_panoply")

  plots = new(3, graphic)
  
  polar_contour_plot(wks, u_e_apvm(ntim-1,:,:) ,   4, -20, 40, plots, 0)
  polar_contour_plot(wks, u_pe_midpoint(ntim-1,:,:),   4, -20, 40, plots, 1)
  polar_contour_plot(wks, u_pe_apvm(ntim-1,:,:),   4, -20, 40, plots, 2)

  resp                            = True
  resp@gsnFrame                   = False
  resp@gsnPanelFigureStrings      = (/"(a)", "(b)", "(c)"/)
  resp@amJust                     = "TopLeft"
  resp@gsnPanelFigureStringsPerimOn = False
  resp@gsnPanelYWhiteSpacePercent = 2
  resp@gsnPanelXWhiteSpacePercent = 3
  resp@gsnPanelLabelBar           = True
  gsn_panel(wks, plots, (/1,3/), resp)
  frame(wks)
;  system("convert -trim -density 300 " + out_name + ".eps" + " " + out_name + ".png")

end
