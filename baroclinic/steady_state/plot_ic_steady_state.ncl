;*******************************
; plot_pgf_test.ncl
;*******************************

begin

  fi = "./ss.360x181.l26.dt60.h0.nc" 
  out_name = "ic_steady_state"
  wks = gsn_open_wks("eps", out_name)
;  gsn_define_colormap(wks, "ncl_default")  
  gsn_define_colormap(wks, "gui_default")  
  
  ;*******************************
  ; Panel plot
  ;*******************************
  plot = new(4, graphic)
  
  df   = addfile(fi, "r")
  u    = df->u(0,:,:,:)
;  uave = dim_avg_Wrap(u)
  t    = df->t(0,:,:,:) 
  vor  = df->vor(0,:,:,:)
  vor  = vor * 1.0e5
  vor@long_name = "relative vorticity"
  vor@units     = "10~S~-5~N~ s~S~-1~N~"
  zs   = df->zs(0,:,:)
  zs   = zs * 9.80616
  zs@long_name = "surface geopotential"
  zs@units     = "m~S~2~N~ s~S~-2~N~"
  lat  = df->lat

  res                   = True
  res@gsnDraw           = False
  res@gsnFrame          = False
  res@cnFillOn          = True
  res@cnLinesOn         = True
;  res@lbLabelAutoStride = True
  res@gsnYAxisIrregular2Linear = True 
  res@cnMinLevelValF       = 0.0
;  res@cnMaxLevelValF       = 0.1
  res@trYReverse           = True  
  res@vpWidthF             = 0.5
  res@vpHeightF            = 0.4
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
;  res@tiMainString       = "Day 8"
  res@tiMainOffsetYF     = -0.03
  res@gsnStringFontHeightF  = 0.02
  res@gsnRightString       = ""

  res@gsnLeftString      = "(a) u wind component (m s~S~-1~N~)"
  plot(0) = gsn_csm_contour(wks, u(:,:,0), res)
  
  res@gsnLeftString      = "(b) temperature (K)"
  plot(1) = gsn_csm_contour(wks, t(:,:,0), res)
  res@gsnLeftString      = "(c) relative vorticity (10~S~-5~N~ s~S~-1~N~)"
  plot(2) = gsn_csm_contour(wks, vor(:,:,0), res)


  res3                    = True
  res3@gsnDraw            = False
  res3@gsnFrame           = False
  res3@vpWidthF           = 0.5
  res3@vpHeightF          = 0.4
  res3@tmYLValues         = ispan(-4000, 2000, 1000)
  res3@tmYLLabels         = ispan(-4000, 2000, 1000)
  res3@tmYLMinorOn        = True
  res3@tiYAxisString      = "" 
  res3@xyLineThicknessF   = 2.0
  res3@xyLineColor        = "Blue"
  res3@gsnLeftString      = "(d) surface geopotential (m~S~2~N~ s~S~-2~N~)"
  res3@gsnStringFontHeightF = 0.02
  plot(3) = gsn_csm_xy(wks, lat, zs(:,0), res3)
  ;------------
  resp                            = True
  resp@gsnFrame                   = False
  resp@gsnPanelYWhiteSpacePercent = 2
  resp@gsnPanelBottom             = 0.2
  resp@gsnPanelMainFontHeightF     = 0.02 
  gsn_panel(wks, plot, (/2,2/), resp)
  frame(wks)
;  system("convert -trim -density 300 " + out_name + ".eps" + " " + out_name + ".png")
end
