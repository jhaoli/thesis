begin
  file_midpoint   = "./mz.swm.360x181.dt8.stokes_on.E_midpoint.h0.nc"
  file_apvm       = "./mz.swm.360x181.dt6.day50.stokes_on.E_apvm.h0.nc"
  file_upwind3rd  = "./mz.swm.360x181.dt8.stokes_on.E_upwind3_wgt0.25.h0.nc"

  f_midpoint   = addfile(file_midpoint, "r")
  vor_midpoint = f_midpoint->vor(50,:,:)

  f_apvm   = addfile(file_apvm, "r")
  vor_apvm = f_apvm->vor(50,:,:)

  f_upwind3rd   = addfile(file_upwind3rd, "r")
  vor_upwind3rd = f_upwind3rd->vor(50,:,:)
  

  res                   = True
  res@gsnFrame          = False
  res@gsnDraw           = False
  res@gsnRightString    = ""
  res@gsnLeftString     = ""
  res@cnFillOn          = True
  res@cnFillMode        = "CellFill"
  res@cnLinesOn         = False
  res@cnLineLabelsOn    = False
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF    = -7e-05
  res@cnMaxLevelValF    = 7e-05
  res@cnLevelSpacingF   = 0.5e-05

  res@lbLabelBarOn      = False
  res@mpGridAndLimbOn   = False
  res@mpPerimOn         = False
  res@mpOutlineOn       = False
  res@mpProjection      = "Orthographic"
  res@mpCenterLonF      = -90
  res@mpCenterLatF      = 30

; create plots
  out_name = "vor_mountain_wave"
  wks = gsn_open_wks("eps", out_name)
  gsn_define_colormap(wks, "GMT_panoply")

  plots = new(3, graphic)
;  res@tiMainString = "Midpoint"
  plots(0) = gsn_csm_contour_map(wks, vor_midpoint , res)
;  res@tiMainString = "1st upwind, beta=0.01"
  plots(1) = gsn_csm_contour_map(wks, vor_apvm     , res)
;  res@tiMainString = "3rd upwind, beta=0.25"
  plots(2) = gsn_csm_contour_map(wks, vor_upwind3rd, res)
  
  resp                       = True
  resp@gsnFrame              = False
  resp@gsnPanelFigureStrings = (/"(a)", "(b)", "(c)"/)
  resp@amJust                = "TopLeft"
  resp@gsnPanelFigureStringsPerimOn = False
  resp@gsnPanelLabelBar      = True
  resp@lbOrientation         = "Horizontal"
  resp@cnExplicitLabelBarLabelsOn = True
  resp@lbBoxLinesOn               = False
;  resp@lbLabelStrings        = (/"-5E-05", "-4E-05", "-3E-05", "-2E-05", "-1E-05", "0" ,\
;                                 "1E-05", "2E-05", "3E-05", "4E-05", "5E-05"/)
  gsn_panel(wks, plots, (/1,3/), resp)
  frame(wks)
  
end
