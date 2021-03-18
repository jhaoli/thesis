begin

  fi0 = "./pgf_test.dt60.360x181.l15.upwind.divdamp2.0.007.lin97.h0.nc"
  
  ;*******************************
  ; Panel plot
  ;*******************************
  
  df0    = addfile(fi0, "r")
  zs     = df0->zs(0,:,:)

  lon = df0->lon
  lat = df0->lat

  res                   = True
  res@gsnDraw           = False
  res@gsnFrame          = False
  res@gsnAddCyclic      = True
  res@cnFillOn          = True
  cmap = read_colormap_file("gui_default")
  cmap(0:1,:) = 0.0
  res@cnFillPalette     = cmap(1:,:)
  res@cnLinesOn         = False
  res@lbLabelAutoStride = False
  
  res@cnLevelSelectionMode = "ManualLevels"
  res@cnLevelSpacingF      = 200
  res@cnMinLevelValF       = 0
  res@cnMaxLevelValF       = 2000
;  res@vpWidthF             = 0.4
;  res@vpHeightF            = 0.3
;  res@gsnCenterStringFontHeightF = 0.015
;  res@gsnRightStringFontHeightF  = 0.015
  res@gsnRightString       = ""
  res@gsnLeftString        = ""
  res@mpCenterLonF         = 180
  res@mpOutlineOn          = False
;  res@tmYLMode             = "Explicit"
  res@tiMainString         = "(a) Surface height (m)"
;  res@tmYLValues           = ylvalues 
;  res@tmYLLabels           = ispan(10000,2000,2000)
;  res@tmYLMinorOn          = True
;  res@tmYLMinorValues      = ylmvalues
  out_name = "mountain1_pgf_test"
  wks = gsn_open_wks("eps", out_name)
  gsn_define_colormap(wks, "gui_default")  

  plot = gsn_csm_contour_map(wks, zs, res)
  draw(plot)
  frame(wks)

  out_name = "mountain2_pgf_test"
  wks = gsn_open_wks("eps", out_name)
  res1 = True
  res1@gsnDraw              = False
  res1@gsnFrame             = False
  res1@vpWidthF             = 0.6
  res1@vpHeightF            = 0.3
  res1@tmYLMode             = "Explicit"
  res1@tmYLValues           = ispan(0,2000,500) 
  res1@tmYLLabels           = ispan(0,2000,500)
  res1@tmYLMinorOn          = True
  res1@tmYLMinorValues      = ispan(0,2000,100)
  res1@tmXBMode             = "Explicit"
  res1@tmXBValues           = (/0,30,60,90, 120, 150, 180, 210, 240, 270, 300, 330, 359/)
  res1@tmXBLabels           = (/"0", "30E", "60E", "90E", "120E", "150E", "180",\
                               "150W", "120W", "90W", "60W", "30W", "0"/)
  res1@tmXBMinorOn          = True
  res1@tmXBMinorValues      = ispan(0,360,10)
  res1@trYMinF              = 0
  res1@trYMaxF              = 2000
  res1@gsnYRefLine          = 0.0
  res1@gsnAboveYRefLineColor = "Black"
  res1@tiMainString         = "(b) Surface height (m) along equator"
  res1@tiYAxisString        = ""
  res1@tiMainOffsetYF       = -0.02
  plot = gsn_csm_xy(wks, lon, zs(90,:), res1)

  draw(plot)
  frame(wks)
;  system("convert -trim -density 300 " + out_name + ".eps" + " " + out_name + ".png")
end
