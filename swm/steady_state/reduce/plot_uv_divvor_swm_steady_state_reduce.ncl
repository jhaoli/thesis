
begin
  file0 = "./ss.swm.360x181.reduce.dt120.day180.h0.nc"
  f = addfile(file0, "r")
  u   = f->u(112,:,:)
  v   = f->v(90,:,:)
  div = f->div(90,:,:)
  vor = f->vor(99,:,:)

; create plots
  out_name = "uv_divvor_steady_state_reduce"
  wks = gsn_open_wks("eps", out_name)
  gsn_define_colormap(wks, "GMT_panoply")

  plots = new(4, graphic)

  res = True
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@cnLinesOn       = False
  res@cnFillOn        = True
  res@cnFillMode      = "CellFill"
  res@mpOutlineOn     = False
  res@gsnPolar        = "NH"
  res@mpMinLatF       = 60
  res@lbLabelBarOn    = True

  res@tiMainOffsetYF  = -0.02
  res@tiMainFontHeightF = 0.02
  res@tiMainFontThicknessF = 0.01
  res@gsnStringFontHeightF = 0.02

  res@tiMainString    = "Day 112" 
  plots(0) = gsn_csm_contour_map(wks, u, res)
  res@tiMainString    = "Day 90"
  plots(1) = gsn_csm_contour_map(wks, v, res)
  res@tiMainString    = "Day 90"
  plots(2) = gsn_csm_contour_map(wks, div, res)
  res@tiMainString    = "Day 99"
  plots(3) = gsn_csm_contour_map(wks, vor, res)
  
  res_panel = True
  gsn_panel(wks, plots, (/2,2/), res_panel)
end 
