begin
  
  file0 = "./mz.swm.360x181.dt8.h0.nc"
  file1 = "./mz.swm.360x181.dt60.h0.nc"
  
  f0 = addfile(file0, "r")
  f1 = addfile(file1, "r")

  figure_name = "u_mz_swm_1deg_day20_reduce" 
  
  day     = 20
  minlev  = -16
  maxlev  = 38
  cnspace = 4

;====================================
  ncirc = 100
  circ_lat = new(ncirc, float)
  circ_lon = new(ncirc, float)
  cen_lat  = 30
  cen_lon  = 270
  nggcog(cen_lat, cen_lon, 30, circ_lat, circ_lon)
;====================================

  wks = gsn_open_wks("ps", figure_name)
  plots = new(4, graphic)

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
  res@mpCenterLonF         = 0
  
  res@tiMainOffsetYF       = -0.02
  res@tiMainFontThicknessF = 0.01
  res@tiMainFontHeightF    = 0.5
  res@gsnStringFontHeightF = 0.03
  res@gsnRightString       = "(a) dt=8s"
  res@gsnLeftString        = "u wind component (m s~S~-1~N~)"
  plots(0) = gsn_csm_contour_map(wks, f0->u(day,:,:), res)
  res@gsnRightString       = "(b) dt=60s"
  plots(2) = gsn_csm_contour_map(wks, f1->u(day,:,:), res)

  res@gsnPolar             = "NH"
  res@mpMinLatF            = 60
  res@lbLabelBarOn         = False
  res@gsnLeftString        = ""
  res@gsnRightString       = ""
  res@vpWidthF             = 0.45
  
  res@tiMainString         = ""
  plots(1) = gsn_csm_contour_map(wks, f0->u(day,:,:), res)
  plots(3) = gsn_csm_contour_map(wks, f1->u(day,:,:), res)
;====================================
  plres                    = True
  plres@gsLineColor        = "black"
  plres@gsLineDashPattern  = 2
  plres@gsLineThicknessF   = 3.0
  dum = new(4, graphic)
  do i = 0, 3
;    dum(i) = gsn_add_polyline(wks, plots(i), circle_lon(0,0,:), circle_lat(0,0,:), plres)
    dum(i) = gsn_add_polyline(wks, plots(i), circ_lon, circ_lat, plres)
  end do
;===================================
  res_panel = True
  gsn_panel(wks, plots, (/2,2/), res_panel)

end
;print("Run the following command to postprocess figure:")
;print("pdfcrop " + figure_name + ".pdf && convert -density 300 " + figure_name + "-crop.pdf " + figure_name + ".png")
