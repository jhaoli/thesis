program calc_error
  
  use netcdf
  
  implicit none
  
!  character(len=*), parameter :: fin = "./ss.180x91.l26.dt60.div0.005.h0.nc"
  character(len=*), parameter :: fin = "./ss.360x181.l26.dt60.divdamp.h0.nc"

!  integer, parameter :: ntime = 31, nlev=26, nlat = 91, nlon=180
  integer, parameter :: ntime = 31, nlev=26, nlat = 181, nlon=360

  real(8) fenzi, fenmu
 
  integer :: i, j, k, t

  real(8), allocatable :: u(:,:,:,:), &
                          ilev(:), &
                          ilat(:), &
                          time(:), &
                          wgt(:) , &
                          dlev(:) 
  real(8), allocatable :: l2_1(:), l2_2(:)
  real(8), allocatable :: u_zonal_mean(:,:,:)

  allocate(u_zonal_mean(nlat, nlev, ntime))

  allocate(u(nlon, nlat, nlev, ntime))
  allocate(ilat(nlat-1))
  allocate(ilev(nlev+1))
  allocate(time(ntime))
  allocate(wgt(nlat-2))
  allocate(dlev(nlev))
  
  allocate(l2_1(ntime))
  allocate(l2_2(ntime))

  call read_netcdf()

  do j = 2, nlat-2
    wgt(j) = abs(sin(ilat(j)) - sin(ilat(j-1)))
  end do
  do k = 1, nlev
    dlev(k) = ilev(k+1) - ilev(k)
  end do
  
  u_zonal_mean = sum(u, dim=1) / nlon

!  do t = 1, ntime
!    fenzi = 0
!    fenmu = 0
!    do k = 1, nlev
!      do j = 2, nlat-2
!        do i = 1, nlon
!          fenzi = fenzi + (u(i,j,k,t) - u_zonal_mean(j,k,t))**2 * wgt(j) * dlev(k)
!          fenmu = fenmu + wgt(j) * dlev(k)
!        end do
!      end do
!    end do
!    l2_1(t) = sqrt(fenzi / fenmu)
!  end do
!  print*, l2_1
!
!  do t = 1, ntime
!    fenzi = 0
!    fenmu = 0
!    do k = 1, nlev
!      do j = 2, nlat-2
!        fenzi = fenzi + (u_zonal_mean(j,k,t) - u_zonal_mean(j,k,1))**2 * wgt(j) * dlev(k)
!        fenmu = fenmu + wgt(j) * dlev(k)
!      end do
!    end do
!    l2_2(t) = sqrt(fenzi / fenmu)
!  end do
!  print*, l2_2
!
!  deallocate(u_zonal_mean)
  call calc_l2_1_l2_2()

  print*, l2_1
  print*, l2_2

  call output()

contains 
  
  subroutine calc_l2_1_l2_2()
  
!  real(8), intent(in) :: u(nlon, nlat, nlev, ntime)
!  real(8), intent(inout) :: l2_1(ntime), l2_2(ntime)
  real(8) fenzi, fenmu
  integer i, j, k, t
  real(8), allocatable :: u_zonal_mean(:,:,:)

  allocate(u_zonal_mean(nlat, nlev, ntime))

  u_zonal_mean = sum(u, dim=1) / nlon

  do t = 1, ntime
    fenzi = 0
    fenmu = 0
    do k = 1, nlev
      do j = 2, nlat-2
        do i = 1, nlon
          fenzi = fenzi + (u(i,j,k,t) - u_zonal_mean(j,k,t))**2 * wgt(j) * dlev(k)
          fenmu = fenmu + wgt(j) * dlev(k)
        end do
      end do
    end do
    l2_1(t) = sqrt(fenzi / fenmu)
  end do

  do t = 1, ntime
    fenzi = 0
    fenmu = 0
    do k = 1, nlev
      do j = 2, nlat-2
        fenzi = fenzi + (u_zonal_mean(j,k,t) - u_zonal_mean(j,k,1))**2 * wgt(j) * dlev(k)
        fenmu = fenmu + wgt(j) * dlev(k)
      end do
    end do
    l2_2(t) = sqrt(fenzi / fenmu)
  end do
  deallocate(u_zonal_mean)

  end subroutine calc_l2_1_l2_2

  subroutine read_netcdf()
    integer :: ncid
    integer :: ilat_varid, ilev_varid, time_varid, u_varid

  call check(nf90_open(fin, nf90_nowrite, ncid))

  call check(nf90_inq_varid(ncid, "ilat", ilat_varid))
  call check(nf90_inq_varid(ncid, "ilev", ilev_varid))
  call check(nf90_inq_varid(ncid, "time", time_varid))
  
  call check(nf90_get_var(ncid, ilat_varid, ilat))
  call check(nf90_get_var(ncid, ilev_varid, ilev))
  call check(nf90_get_var(ncid, time_varid, time))
 
  call check(nf90_inq_varid(ncid, "u", u_varid))
  call check(nf90_get_var(ncid, u_varid, u))

  end subroutine read_netcdf

  subroutine output()

    character(30) file_name
    integer ncid, ierr
    integer time_dimid, time_varid
    integer l1_varid, l2_varid

    file_name = 'error_norms_1p0.nc'

    ierr = NF90_CREATE(file_name, NF90_CLOBBER, ncid)
!    ierr = NF90_PUT_ATT(ncid, NF90_GLOBAL, 'scheme', 'Semi-Lagrangian')

    ierr = NF90_DEF_DIM(ncid, 'time', NF90_UNLIMITED, time_dimid)
    ierr = NF90_DEF_VAR(ncid, 'time', NF90_INT, [time_dimid], time_varid)
    ierr = NF90_DEF_VAR(ncid, 'l2_1', NF90_FLOAT, [time_dimid], l1_varid)
    ierr = NF90_DEF_VAR(ncid, 'l2_2', NF90_FLOAT, [time_dimid], l2_varid)


    ierr = NF90_ENDDEF(ncid)

    ierr = NF90_PUT_VAR(ncid, time_varid, time)
    ierr = NF90_PUT_VAR(ncid, l1_varid, l2_1(1:ntime))
    ierr = NF90_PUT_VAR(ncid, l2_varid, l2_2(1:ntime))

    ierr = NF90_CLOSE(ncid)

  end subroutine output

  subroutine check(status)

    integer, intent(in) :: status

    if(status /= nf90_noerr) then
     print*, trim(nf90_strerror(status))
     stop "Stopped"
    endif

  end subroutine check

end program calc_error
