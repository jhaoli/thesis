
begin
  
  file0  = "./rh4.swm.360x181.dt6.h0.nc"
  file1 = "./rh4.swm.360x181.dt60.h0.nc"
  file2= "./rh4.swm.360x181.dt60.vordamp.h0.nc"
  
  f0 = addfile(file0, "r")
;  f1 = addfile(file1, "r")
  f2 = addfile(file2, "r")

  figure_name = "hu_rh4_swm_1deg_dt60_day89_reduce" 
  
  day = 89

  wks = gsn_open_wks("ps", figure_name)
  plots = new(4, graphic)

  res                      = True
  res@gsnDraw              = False
  res@gsnFrame             = False
  res@cnLinesOn            = True
  res@cnFillOn             = True
  res@cnFillMode           = "AreaFill" ; CellFill
  res@cnLineLabelsOn       = False
  res@cnFillPalette        = "WhBlGrYeRe"; "GMT_panoply"
  res@cnLevelSelectionMode = "ManualLevels"
  res@mpOutlineOn          = False
  res@tiMainFontHeightF     = 0.02
  res@tiMainFontThicknessF  = 0.02
  res@tiMainOffsetYF        = -0.02
  
  resh = res
  resh@cnMinLevelValF       = 8000
  resh@cnMaxLevelValF       = 10500
  resh@cnLevelSpacingF       = 200

  resh@tiMainString          = "(a)"
  plots(0) = gsn_csm_contour_map(wks, f0->z(day,:,:), resh)
  resh@tiMainString          = "(c)"
  plots(2) = gsn_csm_contour_map(wks, f2->z(day,:,:), resh)

  resu = res
  resu@cnFillPalette       = "GMT_panoply"
  resu@cnMinLevelValF      = 0
  resu@cnMaxLevelValF      = 100
  resu@cnLevelSpacingF     = 5

  resu@tiMainString          = "(b)"
  plots(1) = gsn_csm_contour_map(wks, f0->u(day,:,:), resu)
  resu@tiMainString          = "(d)"
  plots(3) = gsn_csm_contour_map(wks, f2->u(day,:,:), resu)

  res_panel = True

  gsn_panel(wks, plots, (/2,2/), res_panel)

end
;print("Run the following command to postprocess figure:")
;print("pdfcrop " + figure_name + ".pdf && convert -density 300 " + figure_name + "-crop.pdf " + figure_name + ".png")
