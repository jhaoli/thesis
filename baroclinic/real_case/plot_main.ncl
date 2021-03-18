load "./plot_mod.ncl"

begin
  fname0 = "./case1p0/vor_1p0.nc"
  fname1 = "./case0p5/vor_0p50.nc"
  fname2 = "./case0p15/vor_0p15.nc"

  fi0 = addfile(fname0, "r")
  fi1 = addfile(fname1, "r")
  fi2 = addfile(fname2, "r")
  print("Addfile ok!")  

  vor0 = fi0->vor(0,20,:,:)
  vor1 = fi1->vor(0,20,:,:)
  vor2 = fi2->vor(0,20,:,:)
  print("read ok!")
; ============================
  vor0 = vor0 * 1.0e04
  vor0@long_name = "appro 700 hPa rel. vorticity"
  vor0@units   = "s-1"
  vor1 = vor1 * 1.0e04
  vor1@long_name = "appro 700 hPa rel. vorticity"
  vor1@units   = "s-1"
  vor2 = vor2 * 1.0e04
  print("calc ok!")
;  printVarSummary(vor)
;  exit()
;===================================
; (1)
  wks = gsn_open_wks("ps", "vor_realcase_gmcore")
  plots = new(3, graphic)
  optArg             = True
  optArg@cnfillpalette = "ncl_default"
  optArg@mainstr     = ""
  optArg@leftstr     = "relative vorticity (10~S~-4~N~ s~S~-1~N~)"
  optArg@rightstr    = "(a) 360x181"
  contour_plot(wks, vor0, 0.1, -1, 1, plots, 0, optArg, False)

  optArg@rightstr    = "(b) 720x361"
  contour_plot(wks, vor1, 0.1, -1, 1, plots, 1, optArg, False)
  
  optArg@rightstr    = "(c) 2400x1201"
  contour_plot(wks, vor2, 0.1, -1, 1, plots, 2, optArg, False)
  print("plot (c) ended")
;=====================================
  resp = True
  resp@gsnPanelLabelBar           = True
  resp@lbOrientation              = "Vertical"
  resp@lbLeftMarginF              = -0.2
  resp@gsnPanelYWhiteSpacePercent = 0
  resp@gsnPanelXWhiteSpacePercent = 5
  resp@pmLabelBarHeightF          = 0.6
  resp@pmLabelBarWidthF           = 0.07
  gsn_panel(wks, plots, (/3,1/), resp)
;=====================================
end
