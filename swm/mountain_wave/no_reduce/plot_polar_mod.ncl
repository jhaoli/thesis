;plot contour polar projection

undef("polar_contour_plot")
procedure polar_contour_plot(wks, data[*][*]:numeric, cinterval[1]:numeric, \
                            cmin[1]:numeric, cmax[1]:numeric, plots[*]:graphic, \
                            iplot[1]:numeric)
begin
  ; set up contour levels
  ncontours = toint((cmax - cmin) / cinterval) + 1
  levels    = ispan(0, ncontours-1, 1)
  flevels   = tofloat(levels)
  flevels   = cmin + flevels * cinterval

  res                          = True
  res@gsnAddCyclic             = True
  res@gsnDraw                  = False
  res@gsnFrame                 = False
  res@gsnPolar                 = "NH"
  res@cnLinesOn                = True
  res@cnInfoLabelOn            = False
  res@cnFillOn                 = True 
  res@cnLevels                 = flevels
  res@cnLevelSelectionMode     = "ExplicitLevels"
  res@cnExplicitLegendLabelsOn = False
  res@cnExplicitLineLabelsOn   = True
  res@cnLineLabelDensityF      = 2
  res@cnLineLabelBackgroundColor = "white"
  res@gsnContourNegLineDashPattern = 1
  res@gsnLeftString            = ""
  res@gsnRightString           = ""
  res@tmXBLabelFontHeightF     = 0.019
  res@tmYLLabelFontHeightF     = 0.019
  res@lbLabelBarOn             = False
  res@lbLabelFontHeightF       = 0.02
  res@lbTopMarginF             = 0.2
  res@mpGridAndLimbOn          = True
  res@mpGridLineColor          = 1
  res@mpPerimOn                = True
  res@mpMinLatF                = 60
  res@mpOutlineOn              = False
  res@mpFillOn                 = False
  res@gsnPolarLabelFontHeightF = 0.016

  plots(iplot)                 = gsn_csm_contour_map_polar(wks, data, res)
  return(plots)
end
