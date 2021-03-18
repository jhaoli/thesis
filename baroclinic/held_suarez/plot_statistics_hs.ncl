load "./plot_mod.ncl"
begin
 
  data_path = "./"
  df = data_path + "statistics_hs_gmcore.nc"
  fi = addfile(df, "r")
  uclim = fi->U
  tclim = fi->T
  upvpclim = fi->EMF
  ekeclim  = fi->EKE
  vptpclim = fi->EHF
  tptpclim = fi->ETV

  uclim@long_name = "Zonal mean zonal wind"
  uclim@units     = "m s~S~-1~N~"
  upvpclim@long_name = "Eddy momentum flux"
  upvpclim@units  = "m~S~2~N~ s~S~-2~N~"
  
  ekeclim@units  = "m~S~2~N~ s~S~-2~N~"
  vptpclim@units  = "K ms~S~-1~N~"
  tptpclim@units  = "K~S~2~N~"
  ; open up workspace
  wks = gsn_open_wks("ps", "hs94_1deg_gmcore")
  ; plot the plots
  plots = new(6, graphic)
  optArg          = True
  optArg@leftstr  = "(a) zonal wind (m s~S~-1~N~)"
  optArg@rightstr = "360x181L26"
  contour_zm_linearp(wks, uclim,    5, -10,  30, plots, 0, True, True, optArg) 
  optArg@leftstr  = "(b) temperature (K)"
  optArg@rightstr = ""
  contour_zm_linearp(wks, tclim,   10, 190, 300, plots, 1, True, True, optArg)
  optArg@leftstr  = "(c) eddy momentum flux (m~S~2~N~ s~S~-2~N~)"
  contour_zm_linearp(wks, upvpclim,10, -70,  70, plots, 2, True, True, optArg)
  optArg@leftstr  = "(d) eddy kinetic energy (m~S~2~N~ s~S~-2~N~)"
  contour_zm_linearp(wks, ekeclim, 30,   0, 400, plots, 3, True, True, optArg)
  optArg@leftstr  = "(e) eddy heat flux (Kms~S~-1~N~)"
  contour_zm_linearp(wks, vptpclim, 3, -20,  20, plots, 4, True, True, optArg) 
  optArg@leftstr  = "(f) temperature variance (K~S~2~N~)"
  contour_zm_linearp(wks, tptpclim, 4,   0,  45, plots, 5, True, True, optArg)

  resp = True
  resp@gsnPanelYWhiteSpacePercent = 2
  resp@gsnPanelXWhiteSpacePercent = 0
  gsn_panel(wks, plots, (/2,3/), resp)
end