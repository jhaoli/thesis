
begin
  
  file0  = "./rh4.swm.360x181.dt6.h0.nc"
  file1 = "./rh4.swm.360x181.dt60.h0.nc"
  file2= "./rh4.swm.360x181.dt60.vordamp.h0.nc"
  
  f0 = addfile(file0, "r")
  f1 = addfile(file1, "r")
  f2 = addfile(file2, "r")

  figure_name = "vor_rh4_swm_1deg_dt60_day22_reduce" 
  
  day = 22
  minlev = -9e-05
  maxlev = 9e-05
  cnspace = 1e-5

  wks = gsn_open_wks("ps", figure_name)
  plots = new(6, graphic)

  res                      = True
  res@gsnDraw              = False
  res@gsnFrame             = False
  res@cnLinesOn            = False
  res@cnFillOn             = True
  res@cnFillMode           = "AreaFill" ; CellFill
  res@cnLineLabelsOn       = False
  res@cnFillPalette        = "GMT_panoply"
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = minlev
  res@cnMaxLevelValF       = maxlev
  res@cnLevelSpacingF      = cnspace
  res@mpOutlineOn          = False
  
  res@tiMainOffsetYF       = -0.02
  res@tiMainFontHeightF    = 0.02
  res@tiMainFontThicknessF = 0.02

  res@tiMainString         = "(a)"
  plots(0) = gsn_csm_contour_map(wks, f0->vor(day,:,:), res)
  
  res@tiMainString         = "(b)"
  plots(2) = gsn_csm_contour_map(wks, f1->vor(day,:,:), res)

  res@tiMainString         = "(c)"
  plots(4) = gsn_csm_contour_map(wks, f2->vor(day,:,:), res)

  res@gsnPolar             = "NH"
  res@mpMinLatF            = 60
  res@lbLabelBarOn         = False
  res@gsnLeftString        = ""
  res@gsnRightString       = ""
  res@vpWidthF             = 0.45
  
  res@tiMainString         = ""
  plots(1) = gsn_csm_contour_map(wks, f0->vor(day,:,:), res)
  plots(3) = gsn_csm_contour_map(wks, f1->vor(day,:,:), res)
  plots(5) = gsn_csm_contour_map(wks, f2->vor(day,:,:), res)

  res_panel = True

  gsn_panel(wks, plots, (/3,2/), res_panel)

end
;print("Run the following command to postprocess figure:")
;print("pdfcrop " + figure_name + ".pdf && convert -density 300 " + figure_name + "-crop.pdf " + figure_name + ".png")
