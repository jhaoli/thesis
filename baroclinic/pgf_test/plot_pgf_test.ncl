;*:q
;******************************
; plot_pgf_test.ncl
;*******************************

begin

  fi0 = "./pgf_test.dt60.360x181.l15.upwind.divdamp2.0.007.lin97.h0.nc"
  fi1 = "./pgf_test.dt60.360x181.l30.upwind.divdamp2.0.007.lin97.h0.nc"
  out_name = "pgf_test_lin97"
  wks = gsn_open_wks("eps", out_name)
  gsn_define_colormap(wks, "gui_default")  
  
  ;*******************************
  ; Panel plot
  ;*******************************
  plot = new(4, graphic)
  
  df0    = addfile(fi0, "r")
  u0     = df0->u(6,:,90,:)
  omega0 = df0->wp(6,:,90,:)

  df1    = addfile(fi1, "r")
  u1     = df1->u(6,:,90,:)
  omega1 = df1->wp(6,:,90,:)

  ilev0 = df0->ilev
  lev0  = df0->lev
  ilev1 = df1->ilev

  res_u                   = True
  res_u@gsnDraw           = False
  res_u@gsnFrame          = False
  res_u@gsnAddCyclic      = True
  res_u@cnFillOn          = True
  res_u@cnLinesOn         = False
  res_u@lbLabelAutoStride = True
  
  res_u@cnLevelSelectionMode = "ManualLevels"
  res_u@cnLevelSpacingF      = 0.02
  res_u@cnMinLevelValF       = -0.1
  res_u@cnMaxLevelValF       = 0.1
  res_u@trYReverse           = True  
  res_u@vpWidthF             = 0.6
  res_u@vpHeightF            = 0.3
  res_u@gsnCenterStringFontHeightF = 0.015
  res_u@gsnCenterString      = "a) U"
  res_u@gsnRightStringFontHeightF  = 0.015
  res_u@gsnRightString       = "m/s"
  res_u@gsnLeftString        = ""
  res_u@tiYAxisString        = "Height (m)" 
  res_u@tiXAxisString        = "Longitude"

  res_u@tmYLMode             = "Explicit"

  res_u0 = res_u
  ylvalues                   = (/lev0(2), ilev0(5), lev0(7), ilev0(10), lev0(12)/)
  res_u0@tmYLValues           = ylvalues 
  res_u0@tmYLLabels           = ispan(10000,2000,2000)
  res_u0@tmYLMinorOn          = True
  ylmvalues = new(31, typeof(ilev0))
  ylmvalues(0:5)   = fspan(ilev0(0),lev0(2), 6)
  ylmvalues(5:10)  = fspan(lev0(2), ilev0(5), 6)
  ylmvalues(10:15) = fspan(ilev0(5), lev0(7), 6)
  ylmvalues(15:20) = fspan(lev0(7), ilev0(10), 6)
  ylmvalues(20:25) = fspan(ilev0(10), lev0(12), 6)
  ylmvalues(25:30) = fspan(lev0(12), ilev0(15), 6)
  res_u0@tmYLMinorValues      = ylmvalues

  plot(0) = gsn_csm_contour(wks, u0, res_u0)

  res_u1 = res_u
  res_u1@tmYLValues           = ilev1(5:25:5) 
  res_u1@tmYLLabels           = ispan(10000,2000,2000)
  res_u1@tmYLMinorOn          = True
  res_u1@tmYLMinorValues      = ilev1
  plot(1) = gsn_csm_contour(wks, u1, res_u1)
  
;  res_zs  = True
;  res_zs@trYMinF   = 0
;  res_zs@trYMaxF   = 12000
;  res_zs@gsnYRefLine = 0.0
;  res_zs@gsnAboveYRefLineColor = "White"
;  plot = gsn_csm_xy(wks, lon, zs(0,90,:), res_zs)
;  overlay(plot(0), plot)
;  draw(plot(0))
  ;------------

  res_omega                   = True
  res_omega@gsnDraw           = False
  res_omega@gsnFrame          = False
  res_omega@gsnAddCyclic      = True
  res_omega@cnFillOn          = True
  res_omega@cnLinesOn         = False
  res_omega@lbLabelAutoStride = True

  res_omega@cnLevelSelectionMode = "ManualLevels"
  res_omega@cnLevelSpacingF      =  0.0001
  res_omega@cnMinLevelValF       = -0.0003
  res_omega@cnMaxLevelValF       =  0.0003
  res_omega@trYReverse           = True
  res_omega@vpWidthF             = 0.6
  res_omega@vpHeightF            = 0.3
  res_omega@gsnCenterStringFontHeightF = 0.015
  res_omega@gsnCenterString      = "b) OMEGA"
  res_omega@gsnRightStringFontHeightF  = 0.015
  res_omega@gsnRightString       = "Pa/s"
  res_omega@gsnLeftString        = ""
  res_omega@tiYAxisString        = "Height (m)"
  res_omega@tiXAxisString        = "Longitude"
  
  res_omega@tmYLMode             = "Explicit"
  res_omega0 = res_omega
  res_omega0@tmYLValues          = ylvalues
  res_omega0@tmYLLabels          = ispan(10000,2000,2000)
  res_omega0@tmYLMinorOn         = True
  res_omega0@tmYLMinorValues     = ylmvalues

  plot(2) = gsn_csm_contour(wks, omega0, res_omega0)

  res_omega1 = res_omega
  res_omega1@tmYLValues           = ilev1(5:25:5)
  res_omega1@tmYLLabels           = ispan(10000,2000,2000)
  res_omega1@tmYLMinorOn          = True
  res_omega1@tmYLMinorValues      = ilev1
  plot(3) = gsn_csm_contour(wks, omega1, res_omega1)
;
  txres = True
  txres@txFontHeightF = 0.018
  gsn_text_ndc(wks, "Test 200, t = 6 days, 15 level", 0.3, 0.86, txres)
  gsn_text_ndc(wks, "Test 200, t = 6 days, 30 level", 0.8, 0.86, txres)
  ;------------
  res                            = True
  res@gsnFrame                   = False
;  res@gsnPanelYWhiteSpacePercent = 5
;  res@gsnPanelBottom             = 0.2
;  res@gsnPanelMainFontHeightF     = 0.02 
;  res@gsnPanelMainString         = "Test 200, t = 6 days, 30 level"
  gsn_panel(wks, plot, (/2,2/), res)
  frame(wks)
;  system("convert -trim -density 300 " + out_name + ".eps" + " " + out_name + ".png")
end
