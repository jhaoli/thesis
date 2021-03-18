;plotting procedure
undef("contour_zm_linearp")
procedure contour_zm_linearp(wks, data[*][*]:numeric, ci[1]:numeric, \
         cmin[1]:numeric, cmax[1]:numeric, plots[*]:graphic, \
         iplot[1]:numeric, ylabelon[1]:logical, xlabelon[1]:logical, opt:logical)

begin
  ; set up contour levels
  ncontours = toint((cmax-cmin) / ci) +1
  levels = ispan(0, ncontours-1, 1)
  flevels = tofloat(levels)
  flevels = cmin + flevels * ci

  ; place line at every second contour, exclude zero
;  lconts = new(ncontours, string)
;  lconts(:) = "Noline"
;  izero = ncontours / 2
;  lconts(izero::2) = "LineAndLabel"
;  lconts(izero:0:-2) = "LineAndLabel"

  ; set up plotting resources
  res                            = True
  res@gsnDraw                    = False
  res@gsnFrame                   = False
  res@trYReverse                 = True
  res@sfYArray                   = data&pfull
  res@gsnYAxisIrregular2Linear   = True
  res@cnFillOn                   = True
  cmap = read_colormap_file("gui_default")
  res@cnFillPalette              = cmap(1:,:)
;  res@gsnSpreadColors = True
  res@cnLevelSelectionMode       = "ExplicitLevels"
  res@cnLevels                   = flevels
  res@cnLineLabelFontHeightF     = 0.015
  res@cnLineLabelBackgroundColor = -1
  res@cnInfoLabelOn              = False
  ; contour every second line
  res@cnMonoLevelFlag            = False
;  res@cnLevelFlags  = lconts
  res@gsnContourZeroLineThicknessF  = 0.0
  res@gsnContourNegLineDashPattern  = 2
  res@cnLineThicknesses             = 2.
  if (opt .and. isatt(opt, "leftstr")) then
    res@gsnLeftString               = opt@leftstr
  end if
  if (opt .and. isatt(opt, "rightstr")) then
    res@gsnRightString              = opt@rightstr
  end if
  res@gsnLeftStringFontHeightF      = 0.025
  res@gsnRightStringFontHeightF     = 0.025
  ; contour labelling
  res@cnLineLabelsOn                = False
  res@cnExplicitLineLabelsOn        = False
  res@cnLineLabelDensityF           = 4
  ; controlling label bar
  res@lbLabelBarOn          = True
;  res@lbLabelAutoStride     = False
  res@lbBoxLinesOn          = True
  res@lbTitlePosition       = "Bottom"
;  res@lbTitleFontThicknessF = 0.02
;  res@lbLabelFontHeightF    = 0.015
;  res@pmLabelBarHeightF     = 0.1
;  res@lbBoxMinorExtentF     = 0.2
;  res@lbBoxSeparatorLinesOn = False
  ; ticklabels
  res@tmYLMode         = "Explicit"
  res@tmYLValues       = fspan(100, 900, 5)
  res@tmYLLabels       = sprintf("%3.1f", fspan(0.1, 0.9, 5))
;  res@tmYLMinorOn      = True
;  res@tmYLTickStartF   = 0.1
;  res@tmYLTickSpacingF = 0.2
;  res@tmYLPrecision    = 2
  res@tiYAxisString    = ""
  res@tmYLLabelsOn     = ylabelon 
  res@tmYLLabelFontHeightF = 0.02
  res@tmXBLabelsOn     = xlabelon
  res@tmXBLabelFontHeightF = 0.02
  res@tmXBValues       = (/-90, -60, -30, 0, 30, 60, 90/)
  res@tmXBLabels       = (/"90S", "60S", "30S", "0", "30N", "60N", "90N"/)
  ;
  plots(iplot) = gsn_csm_contour(wks, data, res)
  return(plots)
end
