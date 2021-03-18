
begin
  fname0 = "./bw.360x181.l26.dt60.coef0.003.h0.nc"
  fname1 = "../steady_state/ss.360x181.l26.dt60.div0.005.h0.nc"

  fi0 = addfile(fname0, "r")
  fi1 = addfile(fname1, "r")

  lon   = fi0->lon 
  lat   = fi0->lat
  ilon   = fi0->ilon 
  ilat   = fi0->ilat
  
  u0    = fi0->u(0,0,:,:)
  vor0  = fi0->vor(0,0,:,:)
  div0  = fi0->div(0,0,:,:)
  
  u1    = fi1->u(0,0,:,:)
  vor1  = fi1->vor(0,0,:,:)
  div1  = fi1->div(0,0,:,:)

  nlat = dimsizes(lat)
  nlon = dimsizes(lon)
  
  u = u0 - u1
  u!0 = "lat"
  u&lat = lat
  u!1 = "lon"
  u&lon = lon

  vor = (vor0 - vor1) * 1.0e06
  vor!0 = "ilat"
  vor&ilat = ilat
  vor!1 = "ilon"
  vor&ilon = ilon

  vor@long_name  = "vorticity"
  vor@units      = "10~S~-5~N~ 1/s"

  div = (div0 - div1) * 1.0e6
  div!0 = "lat"
  div&lat = lat
  div!1 = "lon"
  div&lon = lon
  
  fo = "perturbation_bw_gmcore"
  wks = gsn_open_wks("ps", fo)
  plots = new(3, graphic)
  
  res                    = True
  res@cnFillPalette      = "gui_default"
  res@gsnAddCyclic       = True
  res@gsnDraw            = False
  res@gsnFrame           = False
  res@cnLinesOn          = False
  res@cnLineLabelsOn     = False
  res@cnFillOn           = True
  res@mpOutlineOn        = False
  res@mpCenterLonF       = 20
  res@mpMinLatF          = 20
  res@mpMaxLatF          = 60
  res@mpMinLonF          = 0
  res@mpMaxLonF          = 40
  res@gsnRightString     = ""
  res@gsnStringFontHeightF = 0.03
  res@cnLevelSelectionMode = "ExplicitLevels"

  res0 = res
  res0@cnFillPalette      = "WhBlGrYeRe"
  res0@gsnLeftString      = "(a) zonal wind (m s~S~-1~N~)"
  res0@cnMinLevelValF     = 0
  res0@cnMaxLevelValF     = 1
  res0@cnLevelSpacingF    = 0.1
  cmax0 = 1
  cmin0 = 0
  ci0 = 0.1
  ncontours0               = toint((cmax0 - cmin0) / ci0) +1
  levels0                  = ispan(0, ncontours0-1, 1)
  flevels0                 = tofloat(levels0)
  flevels0                 = cmin0 + flevels0 *ci0
  res0@cnLevels           = flevels0 
  plots(0) = gsn_csm_contour_map(wks, u, res0)
   
  res1 = res
  res1@gsnLeftString      = "(b) relative vorticity (10~S~-6~N~ s~S~-1~N~)"
  res1@cnFillPalette      = "ViBlGrWhYeOrRe"
;  res1@cnMinLevelValF     = 0.2
;  res1@cnMaxLevelValF     = -1.6
;  res1@cnLevelSpacingF    = 1.6
  cmax = 1.6
  cmin = -1.6
  ci = 0.2
  ncontours               = toint((cmax - cmin) / ci) +1
  levels                  = ispan(0, ncontours-1, 1)
  flevels                 = tofloat(levels)
  flevels                 = cmin + flevels *ci
  res1@cnLevels           = flevels 
  plots(1) = gsn_csm_contour_map(wks, vor, res1)

  res1@gsnLeftString     = "(c) divergence (10~S~-6~N~ s~S~-1~N~)"
  plots(2) = gsn_csm_contour_map(wks, div, res1)

  resp = True
  resp@gsnPanelYWhiteSpacePercent = 10
  resp@gsnPanelXWhiteSpacePercent = 5
  gsn_panel(wks, plots, (/1,3/), resp)
;====================================
;  cmd= "convert -trim -density 300 "+ fo + " " + fo +".png"
;  system(cmd)
end

