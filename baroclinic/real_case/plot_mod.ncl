;plotting procedure
undef("contour_plot")
procedure contour_plot(wks, data[*][*]:numeric, ci[1]:numeric, \
           cmin[1]:numeric, cmax[1]:numeric, plots[*]:graphic, \
           iplot[1]:numeric, opt:logical, labelon:logical)

begin
  ; set up contour levels
  ncontours     = toint((cmax - cmin) / ci) +1
  levels        = ispan(0, ncontours-1, 1)
  flevels       = tofloat(levels)
  flevels       = cmin + flevels *ci
  
  res                          = True
  res@vpHeightF                = 0.4
  res@vpWidthF                 = 0.8
  res@gsnAddCyclic             = True
  res@gsnDraw                  = False
  res@gsnFrame                 = False
  res@cnLinesOn                = False
  res@cnFillOn                 = True
  res@cnFillMode               = "CellFill" ;"AreaFill" ;"CellFill" ;"RasterFill"
  if (opt .and. isatt(opt, "cnfillpalette")) then
    res@cnFillPalette          = opt@cnfillpalette
  else
    res@cnFillPalette          = "gui_default"
  end if
  res@cnLineLabelsOn           = False
  res@cnLevels                 = flevels
  res@mpOutlineOn              = True
  res@mpCenterLonF             = 180
  res@gsnMajorLonSpacing       = 60
  res@cnLevelSelectionMode     = "ExplicitLevels"
  res@cnExplicitLegendLabelsOn = True
  res@tmXBLabelFontHeightF     = 0.019
  res@tmYLLabelFontHeightF     = 0.019
  if (opt .and. isatt(opt, "mainstr")) then
    res@tiMainString             = opt@mainstr
  end if
  if (opt .and. isatt(opt, "leftstr")) then
    res@gsnLeftString            = opt@leftstr
  end if
  if (opt .and. isatt(opt, "rightstr")) then
    res@gsnRightString           = opt@rightstr
  end if
  res@tiMainPosition           = "Center"
  res@tiMainOffsetYF           = -0.04
  res@tiMainFontHeightF        = 0.03
  res@tiMainFontThicknessF     = 0.05
  if (labelon) then
    res@lbLabelBarOn             = True
    res@lbLabelFontHeightF       = 0.025
    res@lbTopMarginF             = 0.2
  else
    res@lbLabelBarOn           = False
  end if
;  res1@lbLabelStrings          = (/"-30","", "-20", "", "-10", "", "0", "", "10", ""/)
  plots(iplot)    =   gsn_csm_contour_map(wks, data, res)
  return(plots)
end
