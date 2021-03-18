load "./plot_mod.ncl"

begin
  fname0 = "./vor_day1_5_10_15_30.nc"

  fi0 = addfile(fname0, "r")
  print("Addfile ok!")  

  vor0 = fi0->vor(1:4,:,:)
  print("read ok!")
; ============================
  vor0 = vor0 * 1.0e04
  vor0@long_name = "appro 700 hPa rel. vorticity"
  vor0@units   = "s-1"
  print("calc ok!")
;  printVarSummary(vor)
;  exit()
;===================================
; (1)
  wks = gsn_open_wks("ps", "vor_day30_realcase_gmcore")
  plots = new(4, graphic)
  optArg             = True
  optArg@cnfillpalette = "ncl_default"
  optArg@mainstr     = ""
  optArg@leftstr     = "relative vorticity (10~S~-4~N~ s~S~-1~N~)"
  optArg@rightstr    = "(a) day 5"
  contour_plot(wks, vor0(0,:,:), 0.1, -1, 1, plots, 0, optArg, False)

  optArg@rightstr    = "(b) day 10"
  contour_plot(wks, vor0(1,:,:), 0.1, -1, 1, plots, 1, optArg, False)
  
  optArg@rightstr    = "(c) day 15"
  contour_plot(wks, vor0(2,:,:), 0.1, -1, 1, plots, 2, optArg, False)

  optArg@rightstr    = "(d) day 30"
  contour_plot(wks, vor0(3,:,:), 0.1, -1, 1, plots, 3, optArg, False)

  print("plot ended")
;=====================================
  resp = True
  resp@gsnPanelLabelBar           = True
  resp@lbOrientation              = "Horizontal"
  resp@lbLeftMarginF              = -0.2
  resp@gsnPanelYWhiteSpacePercent = 0
  resp@gsnPanelXWhiteSpacePercent = 3
;  resp@pmLabelBarHeightF          = 0.6
  resp@pmLabelBarWidthF           = 0.7
  gsn_panel(wks, plots, (/2,2/), resp)
;=====================================
end
