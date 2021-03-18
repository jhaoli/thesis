
begin
  
  file0  = "./mz.swm.360x181.dt8.h0.nc"
  file1 = "./mz.swm.360x181.dt60.h0.nc"
  file2= "./mz.swm.360x181.dt60.vordamp.h0.nc"
  
  f0 = addfile(file0, "r")
  f1 = addfile(file1, "r")
  f2 = addfile(file2, "r")

  figure_name = "u_mz_swm_1deg_day40_reduce" 
  
;  day = 20
;  minlev = -16
;  maxlev = 38
;  cnspace = 4

  day = 40
  minlev = -38
  maxlev = 42
  cnspace = 8
  
;  day = 50
;  minlev = -20
;  maxlev = 55
;  cnspace = 5

  wks = gsn_open_wks("ps", figure_name)
  plots = new(2, graphic)

  res                      = True
  res@gsnDraw              = False
  res@gsnFrame             = False
  res@cnLinesOn            = True
  res@cnFillOn             = True
  res@cnFillPalette        = "GMT_panoply"
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = minlev
  res@cnMaxLevelValF       = maxlev
  res@cnLevelSpacingF      = cnspace
  res@mpOutlineOn          = False
  
;  res@tiMainString         = "(a)"
  res@tiMainOffsetYF       = -0.02
  res@tiMainFontThicknessF = 0.01
  res@tiMainFontHeightF    = 0.02

  plots(0) = gsn_csm_contour_map(wks, f1->u(day,:,:), res)
;  res@tiMainString         = "(b)"
;  plots(2) = gsn_csm_contour_map(wks, f1->u(day,:,:), res)

  res@gsnPolar             = "NH"
  res@mpMinLatF            = 60
  res@lbLabelBarOn         = False
  res@gsnLeftString        = ""
  res@gsnRightString       = ""
  res@vpWidthF             = 0.45
  
  res@tiMainString         = ""
  plots(1) = gsn_csm_contour_map(wks, f1->u(day,:,:), res)
;  plots(3) = gsn_csm_contour_map(wks, f1->u(day,:,:), res)

  res_panel = True

  gsn_panel(wks, plots, (/2,2/), res_panel)

end
;print("Run the following command to postprocess figure:")
;print("pdfcrop " + figure_name + ".pdf && convert -density 300 " + figure_name + "-crop.pdf " + figure_name + ".png")
