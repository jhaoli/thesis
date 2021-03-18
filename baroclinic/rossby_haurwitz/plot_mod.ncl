;plotting procedure
undef("contour_plot")
procedure contour_plot(wks, data[*][*]:numeric, ci[1]:numeric, \
           cmin[1]:numeric, cmax[1]:numeric, plots[*]:graphic, \
           iplot[1]:numeric, opt:logical)

begin
  ; set up contour levels
  ncontours     = toint((cmax - cmin) / ci) +1
  levels        = ispan(0, ncontours-1, 1)
  flevels       = tofloat(levels)
  flevels       = cmin + flevels *ci
  
  res                          = True
  res@gsnAddCyclic             = True
  res@gsnDraw                  = False
  res@gsnFrame                 = False
  res@cnLinesOn                = True
  res@cnFillOn                 = True
  if (opt .and. isatt(opt, "cnfillpalette")) then
    res@cnFillPalette          = opt@cnfillpalette
  else
    res@cnFillPalette          = "gui_default"
  end if
  res@cnLevels                 = flevels
  res@mpOutlineOn              = False
  res@mpCenterLonF             = 180
  res@gsnMajorLonSpacing       = 60
  res@cnLevelSelectionMode     = "ExplicitLevels"
  res@cnExplicitLegendLabelsOn = True
  res@tmXBLabelFontHeightF     = 0.019
  res@tmYLLabelFontHeightF     = 0.019
  if (opt .and. isatt(opt, "mainstr")) then
    res@tiMainString           = opt@mainstr
    res@tiMainPosition         = "Center"
    res@tiMainOffsetYF         = -0.018
    res@tiMainFontHeightF      = 0.018
    res@tiMainOn               = True
  end if
  if (opt .and. isatt(opt, "leftstr")) then
    res@gsnLeftString          = opt@leftstr
  end if
  if (opt .and. isatt(opt, "rightstr")) then
    res@gsnRightString         = opt@rightstr
  end if
  res@lbLabelFontHeightF       = 0.02
  ; res0@pmLabelBarHeightF     = 0.1
  res@lbTopMarginF             = 0.2
;  res1@lbLabelStrings          = (/"-30","", "-20", "", "-10", "", "0", "", "10", ""/)
  plots(iplot)    =   gsn_csm_contour_map(wks, data, res)
  return(plots)
end

undef("plot_ps_t850")
procedure plot_ps_t850(ps, t850, wks)
begin
  plot = new(2, graphic)

  res              = True
  res@gsnAddCyclic = True
  res@gsnDraw      = False
  res@gsnFrame     = False
  res@cnLinesOn    = True
  res@cnFillOn     = True 
  res@mpOutlineOn  = False 
  res@mpCenterLonF = 180
  res@tmXBLabelFontHeightF = 0.019
  res@tmYLLabelFontHeightF = 0.019
  ps@long_name     = "surface pressure"
  ps@units         = "hPa"
  plot(0)          = gsn_csm_contour_map(wks, ps, res)
  
  t850@long_name   = "temperature at 850hPa"
  t850@units       = "K"
  plot(1)          = gsn_csm_contour_map(wks, t850, res)
  ;****
  ; create panel
  ;****
  resP = True 
  resP@gsnFrame    = False 
  gsn_panel(wks, plot, (/1,2/), resP)
  frame(wks)
end 

undef("plot_h500_omega850")
procedure plot_h500_omega850(h500, omega850, lon, lat, wks)
begin
  plot = new(2, graphic)
  res              = True
  res@gsnAddCyclic = True
  res@gsnDraw      = False
  res@gsnFrame     = False
  res@cnLinesOn    = True
  res@cnFillOn     = True 
  res@mpOutlineOn  = False
  res@mpCenterLonF = 180

  h500@long_name = "geopotential height at 500 hPa"
  h500@units     = "m"
  plot(0) = gsn_csm_contour_map(wks, h500, res)
  
  omega850!0         = "lat"
  omega850!1         = "lon"
  omega850&lat       = lat 
  omega850&lon       = lon
  lat@units          = "degrees_north"
  lon@units          = "degrees_east"
  omega850@long_name = "vertical pressure velocity at 850hPa"
  omega850@units     = "Pa/s"

  plot(1) = gsn_csm_contour_map(wks, omega850, res)
  
  ;****
  ; create panel
  ;****
  resP = True 
  resP@gsnFrame  = False 
  gsn_panel(wks, plot, (/1,2/), resP) 
  frame(wks) 
end
undef("plot_z700_t700")
procedure plot_z700_t700(z700, t700, lon, lat, wks)
begin
  plot = new(2, graphic)
  res              = True
  res@gsnAddCyclic = True
  res@gsnDraw      = False
  res@gsnFrame     = False
  res@cnLinesOn    = True
  res@cnFillOn     = True 
  res@mpOutlineOn  = False
  res@mpCenterLonF = 180
  res@cnLevelSelectionMode = "ExplicitLevels"
  res@cnExplicitLegendLabelsOn = True

  res0  = res
  res0@cnLevelSpacingF = 100
  res0@cnMaxLevelValF  = 3300
  res0@cnLevels        = ispan(2500, 3300, 100)
  ; print(ispan(2500, 3300, 100))
  res0@lbLabelStrings  = (/"", "2600", "", "2800", "", "3000", "", "3200", ""/)
  z700!0            = "lat"
  z700!1            = "lon"
  z700&lat          = lat 
  z700&lon          = lon
  lat@units         = "degrees_north"
  lon@units         = "degrees_east"
  z700@long_name = "geopotential height at 700 hPa"
  z700@units     = "m"
  plot(0) = gsn_csm_contour_map(wks, z700, res0)

  res1              = res

  t700!0            = "lat"
  t700!1            = "lon"
  t700&lat          = lat 
  t700&lon          = lon
  lat@units         = "degrees_north"
  lon@units         = "degrees_east"
  t700@long_name    = "temperature at 700hPa"
  t700@units        = "K"
  res1@cnLevelSpacingF = 3
  res1@cnMaxLevelValF  = 300
  res1@cnLevels        = ispan(273, 300, 3)
  ; print(ispan(273, 300, 3))
  res1@lbLabelStrings  = (/"", "276", "", "282", "", "288", "", "294", "", "300"/)

  plot(1) = gsn_csm_contour_map(wks, t700, res1)
  
  ;****
  ; create panel
  ;****
  resP = True 
  resP@gsnFrame  = False 
  gsn_panel(wks, plot, (/1,2/), resP) 
  ; draw(plot)
  frame(wks) 
end

undef("plot_uv850_ps_t850_h500_omega850")
procedure plot_uv850_ps_t850_h500_omega850(u850, v850, ps, t850, h500, omega850, lon, lat, wks)
begin
  plot = new(6, graphic)
  res              = True
  res@gsnAddCyclic = True
  res@gsnDraw      = False
  res@gsnFrame     = False
  res@cnLinesOn    = True
  res@cnFillOn     = True 
  res@mpOutlineOn  = False
  res@mpCenterLonF = 180
  ; res@lbLabelFontHeightF = 0.02

  u850@long_name = "zonal wind at 850hPa"
  u850@units     = "m/s"
  res@cnLevelSelectionMode = "ExplicitLevels"
  res@cnLevelSpacingF = 2
  res@cnMaxLevelValF  = 24
  res@lbLabelBarOn    = True
  res@cnLevels        = ispan(0,24,2)
  res@lbLabelStrings = (/"0","", "4","", "8","", "12","", "16", "", "20","", "24"/)
  plot(0) = gsn_csm_contour_map(wks, u850, res)
  delete(res@cnLevels)
  delete(res@cnLevelSpacingF)
  delete(res@cnMaxLevelValF)
  delete(res@lbLabelStrings)


  v850@long_name  = "meridional wind at 850hPa"
  v850@units      = "m/s"
  res@cnLevelSpacingF = 2
  res@cnMaxLevelValF  = 12
  res@cnLevels        = ispan(-14, 14, 2)
  res@lbLabelBarOn    = True
  res@lbLabelStrings = (/ "", "-12", "", "-8","", "-4","", "0","", "4", "", "8", "", "12"/)
  plot(1) = gsn_csm_contour_map(wks, v850, res)
  delete(res@cnLevelSpacingF)
  delete(res@cnMaxLevelValF)
  delete(res@lbLabelStrings)
  delete(res@cnLevels)

  ps@long_name     = "surface pressure"
  ps@units         = "hPa"
  res@cnLevelSpacingF = 5
  res@cnMaxLevelValF  = 1025
  res@lbLabelStrings = (/"955", "","", "970","","", "985","","", "1000","", "", "1015","",""/)
  plot(2)          = gsn_csm_contour_map(wks, ps, res)
  delete(res@cnLevelSpacingF)
  delete(res@cnMaxLevelValF)
  delete(res@lbLabelStrings)
  ; delete(res@cnLevels)

  t850@long_name   = "temperature at 850hPa"
  t850@units       = "K"
  res@cnLevelSpacingF = 0.04
  res@cnMaxLevelValF  = 281.96
  res@cnLevels        = fspan(281.48, 281.96, 13)
  res@lbLabelStrings = (/"","281.48", "","", "281.6","","", "281.72","","", "281.84","", ""/)
  plot(3)          = gsn_csm_contour_map(wks, t850, res)
  delete(res@cnLevelSpacingF)
  delete(res@cnMaxLevelValF)
  delete(res@lbLabelStrings)
  delete(res@cnLevels)

  h500@long_name = "geopotential height at 500 hPa"
  h500@units     = "m"
  ; res@cnLevelSelectionMode = "ManualLevels"
  res@cnLevelSpacingF = 40
  res@cnMaxLevelValF  = 5760
  res@cnLevels        = ispan(5160, 5760, 40)
  ; print(ispan(5160, 6400, 40))
  res@lbLabelStrings  = (/"", "5200", "","", "5320", "", "", "5440", "", "", "5560", "", "", "5680", "",""/)
  plot(4) = gsn_csm_contour_map(wks, h500, res)
  delete(res@cnLevelSpacingF)
  delete(res@cnMaxLevelValF)
  delete(res@lbLabelStrings)
  delete(res@cnLevels)

  omega850!0         = "lat"
  omega850!1         = "lon"
  omega850&lat       = lat 
  omega850&lon       = lon
  lat@units          = "degrees_north"
  lon@units          = "degrees_east"
  omega850@long_name = "vertical pressure velocity at 850hPa"
  omega850@units     = "Pa/s"
  res@cnLevelSelectionMode = "ExplicitLevels"
  ; res@cnMinLevelValF  = -0.02
  ; res@cnLevelSpacingF = 0.0025
  ; res@cnMaxLevelValF  = 0.015
  ; res@cnLevels        = ispan(-175,150,25)/10000.0 ; or
  res@cnLevels        = fspan(-0.0175,0.015,14)
  ; res@cnExplicitLegendLabelsOn = True
  ; res@lbLabelFontHeightF = 0.034
  ; res@lbLabelStride  = 2
  res@lbLabelStrings  = (/"","-0.015","","", "-0.0075", "", "", "0", "", "", "0.0075", "", "", "0.015",""/)
  plot(5) = gsn_csm_contour_map(wks, omega850, res)
  ; delete(res@cnLevelSpacingF)
  ; delete(res@cnMaxLevelValF)
  ; delete(res@lbLabelStrings)
  ;****
  ; create panel
  ;****
  resP = True 
  resP@gsnFrame  = False 
  resP@gsnPanelMainString = "GMCORE at day 15"
  gsn_panel(wks, plot, (/3,2/), resP) 
  frame(wks)
end
