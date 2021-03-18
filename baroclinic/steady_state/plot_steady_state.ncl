;*******************************
; plot_pgf_test.ncl
;*******************************

begin

  fi0 = "./ss.360x181.l26.dt60.h0.nc" 
  fi1 = "./ss.360x181.l26.dt60.divdamp.h0.nc" 
  out_name = "steady_state_day5_day30"
  wks = gsn_open_wks("eps", out_name)
;  gsn_define_colormap(wks, "ncl_default")  
  gsn_define_colormap(wks, "gui_default")  
  
  ;*******************************
  ; Panel plot
  ;*******************************
  plot = new(2, graphic)
  
  df0  = addfile(fi0, "r")
  u0     = df0->u(5,:,:,:)
  u0ave = dim_avg_Wrap(u0)
 
  df1  = addfile(fi1, "r")
  u1     = df1->u(30,:,:,:)
  u1ave = dim_avg_Wrap(u1)

  res                   = True
  res@gsnDraw           = False
  res@gsnFrame          = False
;  res@gsnAddCyclic      = True
  res@cnFillOn          = True
  res@cnLinesOn         = False
;  res@lbLabelAutoStride = True
  res@gsnYAxisIrregular2Linear = True 
;  res@cnLevelSelectionMode = "ManualLevels"
;  res@cnLevelSpacingF      = 0.02
  res@cnMinLevelValF       = 0.0
;  res@cnMaxLevelValF       = 0.1
  res@trYReverse           = True  
;  res@vpWidthF             = 0.6
;  res@vpHeightF            = 0.3
;  res@gsnCenterStringFontHeightF = 0.015
;  res@gsnCenterString      = "a) U"
;  res@gsnRightStringFontHeightF  = 0.015
;  res@gsnRightString       = "m/s"
;  res@gsnLeftString        = ""
;  res@tiYAxisString        = "Height (m)" 
;  res@tiXAxisString        = "Longitude"
;
  res@tmYLMode             = "Explicit"
  res@tmYLValues           = fspan(0.1, 0.9, 5) 
  res@tmYLLabels           = sprintf("%3.1f", fspan(0.1, 0.9, 5))
  res@tmYLMinorOn          = True
;  res@tmYLMinorValues      = ilev
  res@tiMainString       = "Day 5"
  res@tiMainOffsetYF     = -0.03
  plot(0) = gsn_csm_contour(wks, u0ave, res)
  res@tiMainString       = " Day 30"
  plot(1) = gsn_csm_contour(wks, u1ave, res)

  ;------------
  resp                            = True
  resp@gsnFrame                   = False
  resp@gsnPanelYWhiteSpacePercent = 5
  resp@gsnPanelBottom             = 0.2
  resp@gsnPanelMainFontHeightF     = 0.02 
  gsn_panel(wks, plot, (/1,2/), resp)
;  draw(plot)  
;  frame(wks)
;  system("convert -trim -density 300 " + out_name + ".eps" + " " + out_name + ".png")
end
