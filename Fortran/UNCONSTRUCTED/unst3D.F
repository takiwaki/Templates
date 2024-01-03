! 
! Output hydrodynamic data in unconstructed mesh in Fortran
! Author: Tomoya Takiwaki
!   Date: 2020/03/15
!
! Reference1: http://www.xdmf.org/index.php/XDMF_Model_and_Format
! Reference2: https://www.visitusers.org/index.php?title=Using_XDMF_to_read_HDF5
!
      module stparam
! n1d: number of grids in    radial grid
! n2d: number of grids in     polar grid
! n3d: number of grids in azimuthal grid
      integer::n1d,n2d,n3d
! nfld: number of hydrodynamic variables
      integer::nfld
! x1a: value of the grid in cell edge
! x1b: value of the grid in cell center
      real(8),allocatable,dimension(:):: x1a,x1b,dvl1a
      real(8),allocatable,dimension(:):: x2a,x2b,dvl2a
      real(8),allocatable,dimension(:):: x3a,x3b,dvl3a
      real(8),allocatable,dimension(:,:,:,:):: fld3D

      integer:: tindex
      real(8):: time
      end module stparam

      module unstparam
! Nelements: number of the elemets
! Nodes: Number of the nodes
      integer:: Nelements,Nnodes,Nvar
      integer,allocatable,dimension(:,:):: connectivity
      real(4),allocatable,dimension(:,:):: xyz
      real(4),allocatable,dimension(:,:):: fldun

      integer:: tindexdmp
      real(4):: timedmp
      data timedmp / 0.0 /

! fname: Filenemae "*.hdf5"
! fnxmf: Filenemae "*.xmf"
      character*(80) :: fname,fpath
      character*(80) :: fnxmf,fpxmf

      end module unstparam

      program main
      use stparam, only:tindex
      implicit none

      write(6,*) "program started"

      do tindex=1,10
         call MakingStrData
         call MakingUnstrData
         call OutputHDF5
         call OutputXDMF
      enddo

      stop "program normally finished"
      end program

      subroutine MakingStrData
      use stparam
      implicit none
      integer::nr,nt,np
      real(8)::rmin,rmax,dr
      real(8)::tmin,tmax,dt
      real(8)::pmin,pmax,dp
      
      real(8)::pi
      integer:: i,j,k
      logical,save:: is_inited
      data is_inited / .false. /

      pi=acos(-1.0d0)
!      write(6,*)"pi=",pi

      nr=100
      rmin=0.0d0
      rmax=1.0d0
      dr  = (rmax-rmin)/nr
      n1d=nr
      if(.not. is_inited) allocate(x1a(1:n1d+1),x1b(1:n1d),dvl1a(1:n1d))
      x1a(1)=rmin
      do i=2,n1d+1
         x1a(i) = x1a(i-1)+dr
      enddo
      do i=1,n1d
           x1b(i) = 0.5d0*(x1a(i+1)   +x1a(i)   )
         dvl1a(i) =       (x1a(i+1)**3-x1a(i)**3)/3
      enddo
      if(.not. is_inited) write(6,*)"check 0=",rmin
      
      nt=100
      tmin=0.0d0
      tmax=pi
      dt  = (tmax-tmin)/nt
      n2d=nt
      if(.not. is_inited) allocate(x2a(1:n2d+1),x2b(1:n2d),dvl2a(1:n2d))
      x2a(1) = tmin
      do j=2,n2d+1
         x2a(j) = x2a(j-1)+dt
      enddo
      do j=1,n2d
           x2b(j) = 0.5d0*(    x2a(j+1) +    x2a(j) )
         dvl2a(j) =    -  (cos(x2a(j+1))-cos(x2a(j)))
      enddo

      if(.not. is_inited) write(6,*)"check 2=",sum(dvl2a(:))

      np=200
      pmin=0.0d0
      pmax=2.0*pi
      dp  = (pmax-pmin)/np
      n3d=np
      if(.not. is_inited) allocate(x3a(1:n3d+1),x3b(1:n3d),dvl3a(1:n3d))
      x3a(1) = pmin
      do k=2,n3d+1
         x3a(k) = x3a(k-1)+dp
      enddo
      do k=1,n3d
           x3b(k) = 0.5d0*(x3a(k+1)+x3a(k))
         dvl3a(k) =       (x3a(k+1)-x3a(k))
      enddo
      if(.not. is_inited) write(6,*)"check 2pi=",sum(dvl3a(:))

      nfld=1
      if(.not. is_inited) allocate(fld3D(n1d,n2d,n3d,nfld))
      time = tindex
      
      do k=1,n3d
      do j=1,n2d
      do i=1,n1d
         fld3D(i,j,k,1) = (exp(-((x1b(i)-0.5)/0.1)**2))
     &                  *(1.0d0+0.2*sin(1.0*x2b(j)))
     &                  *(1.0d0+0.2*cos(4.0*(x3b(k) - 2.0*pi*time/10.0))) 
      enddo
      enddo
      enddo

      is_inited =.true.
      return
      end subroutine MakingStrData

      subroutine MakingUnstrData
      use stparam
      use unstparam
      implicit none
      integer,allocatable,dimension(:,:,:),save::NodeNumber
      integer::i,j,k,m,n
      integer::thenumber
      integer::theelement
      real(8),allocatable,dimension(:),save::ave

      integer,parameter:: notset=-1

      logical,save:: is_inited
      data is_inited / .false. /

      tindexdmp=tindex
      timedmp  =real(time)

      Nvar=nfld
      if(.not. is_inited) allocate(ave(Nvar))
      Nnodes=n1d*n2d*n3d   ! normal node
     &      +    n2d*n3d+1 ! outer and inner radial node
     &      +    2*(n1d+1) ! singular points at theta=0 and pi
      
      if(.not. is_inited) allocate(fldun(0:Nnodes-1,Nvar))
      if(.not. is_inited) allocate(  xyz(3,0:Nnodes-1))

      Nelements=(n1d+1)*(n2d+1)*(n3d) ! for 1d and 2d direction we added 1 mesh
      if(.not. is_inited) allocate(NodeNumber(0:n1d+1,0:n2d+1,0:n3d+1))
      NodeNumber(:,:,:) = notset !  to find a bug
 
      thenumber=0
      do k=1,n3d
      do j=1,n2d
      do i=1,n1d
! Making New Nodes begin
         NodeNumber(i,j,k)= thenumber
         xyz(1,thenumber) = real(x1b(i)*sin(x2b(j))*cos(x3b(k)) )
         xyz(2,thenumber) = real(x1b(i)*sin(x2b(j))*sin(x3b(k)) )
         xyz(3,thenumber) = real(x1b(i)*cos(x2b(j))             )
         fldun(thenumber,1:Nvar) = real( fld3D(i,j,k,1:n1d)     )
         thenumber=thenumber+1
! Making New Nodes end
      enddo
      enddo
      enddo

! outer boundary of the radial mesh
      i=n1d+1
      do k=1,n3d
      do j=1,n2d
! Making New Nodes begin
         NodeNumber(i,j,k)= thenumber
         xyz(1,thenumber) = real(x1a(i)*sin(x2b(j))*cos(x3b(k)) )
         xyz(2,thenumber) = real(x1a(i)*sin(x2b(j))*sin(x3b(k)) )
         xyz(3,thenumber) = real(x1a(i)*cos(x2b(j))             )
         fldun(thenumber,1:Nvar) = real(fld3D(i-1,j,k,1:n1d)    )
         thenumber=thenumber+1
! Making New Nodes end
      enddo
      enddo

! inner boundary of the radial mesh
! Making New Nodes begin
      NodeNumber(0,1:n2d,1:n3d)= thenumber
      xyz(1,thenumber) =  real(0.0d0)
      xyz(2,thenumber) =  real(0.0d0)
      xyz(3,thenumber) =  real(0.0d0)
      do m=1,nfld
         ave(m)=0.0d0
         do k=1,n3d
         do j=1,n2d
            ave(m)=ave(m)+fld3D(1,j,k,m)*dvl2a(j)*dvl3a(k)
         enddo
         enddo
         ave(m) = ave(m)/sum(dvl2a(:))/sum(dvl3a(:))
         fldun(thenumber,m) = real(ave(m))
      enddo
      thenumber=thenumber+1
! Making New Nodes end

! North pole
      do i=1,n1d
! Making New Nodes begin
         NodeNumber(i,0,1:n3d)= thenumber
         xyz(1,thenumber) = real(0.0d0)
         xyz(2,thenumber) = real(0.0d0)
         xyz(3,thenumber) = real(x1b(i))

         do m=1,nfld
         ave(m)=0.0d0
         do k=1,n3d
            ave(m)=ave(m)+fld3D(i,1,k,m)*dvl3a(k)
         enddo
         ave(m) = ave(m)/sum(dvl3a(:))
         fldun(thenumber,m) = real(ave(m))
         enddo
         thenumber=thenumber+1
! Making New Nodes end
      enddo

      NodeNumber(0,    0,1:n3d)=NodeNumber(0,    1,1:n3d)

! Making New Nodes begin
      NodeNumber(n1d+1,    0,1:n3d)=thenumber
      xyz(1,thenumber) =  real(     0.0d0)
      xyz(2,thenumber) =  real(     0.0d0)
      xyz(3,thenumber) =  real(x1a(n1d+1))
      fldun(thenumber,1:Nvar) = real(fldun(NodeNumber(n1d,0,1),1:Nvar))
      thenumber=thenumber+1
! Making New Nodes end

! South pole
      do i=1,n1d
! Making New Nodes begin
         NodeNumber(i,n2d+1,1:n3d)= thenumber
         xyz(1,thenumber) = real(  0.0d0)
         xyz(2,thenumber) = real(  0.0d0)
         xyz(3,thenumber) = real(-x1b(i))
         do m=1,nfld
         ave(m)=0.0d0
         do k=1,n3d
            ave(m)=ave(m)+fld3D(i,n2d,k,m)*dvl3a(k)
         enddo
         ave(m) = ave(m)/sum(dvl3a(:))
         fldun(thenumber,m) = real(ave(m))
         enddo
         thenumber=thenumber+1
! Making New Nodes end
      enddo

      NodeNumber(0,n2d+1,1:n3d)=NodeNumber(0,n2d,1:n3d)

! Making New Nodes begin
      NodeNumber(n1d+1,n2d+1,1:n3d)=thenumber
      xyz(1,thenumber) = 0.0d0
      xyz(2,thenumber) = 0.0d0
      xyz(3,thenumber) = -x1a(n1d+1)
      fldun(thenumber,1:Nvar) = fldun(NodeNumber(n1d,n2d+1,1),1:Nvar)
      thenumber=thenumber+1
! Making New Nodes end

! periodic boundary
      do j=0,n2d+1
      do i=0,n1d+1
         NodeNumber(i,j,0    )=NodeNumber(i,j,n3d)
         NodeNumber(i,j,n3d+1)=NodeNumber(i,j,1) 
      enddo
      enddo

      write(6,*) "Number of Nodes           ",thenumber
      write(6,*) "Number of Nodes (expected)",Nnodes
       
      if(.not. is_inited) allocate(connectivity(8,Nelements))

      tindexdmp = tindex
      theelement=0
      do k=1,n3d
      do j=0,n2d
      do i=0,n1d
         theelement=theelement+1
         connectivity(1,theelement)=NodeNumber(i  ,j  ,k  )
         connectivity(2,theelement)=NodeNumber(i+1,j  ,k  )
         connectivity(3,theelement)=NodeNumber(i+1,j+1,k  )
         connectivity(4,theelement)=NodeNumber(i  ,j+1,k  )
         connectivity(5,theelement)=NodeNumber(i  ,j  ,k+1)
         connectivity(6,theelement)=NodeNumber(i+1,j  ,k+1)
         connectivity(7,theelement)=NodeNumber(i+1,j+1,k+1)
         connectivity(8,theelement)=NodeNumber(i  ,j+1,k+1)
         do m=1,8
         if( connectivity(m,theelement) .eq. notset) then
            write(6,*) "connection not initialized m=",m,"ijk",i,j,k
         endif
         enddo
      enddo
      enddo
      enddo

      write(6,*) "Number of Element          ",theelement
      write(6,*) "Number of Element(expected)",Nelements
       
      is_inited = .true.

      return
      end subroutine MakingUnstrData

      subroutine OutputHDF5
      use unstparam
      use hdf5
      implicit none

      integer(hid_t) :: file_id                   ! file identifier
      integer ::   rank                           ! dataset rank
      integer(hsize_t), dimension(2) :: dims   ! dataset dimensions
      character(80) :: dsetname                   ! dataset name
      integer :: error
      integer unitxmf
      integer,save:: imax,jmax,kmax
      character*(80) :: DIM3D,DIM1D,TIMEEXP
      integer:: i,j,k,n
      logical,save::is_inited
      data is_inited / .false. /

      integer,allocatable,dimension(:,:):: con2

! Determine the output filename
      write(fname,"(a4,i3.3,a5)") "test",tindexdmp,".hdf5"
      fpath = "./"//fname

! Determine the XDMF filename
      write(fnxmf,"(a4,i3.3,a4)") "test",tindexdmp,".xmf"
      fpxmf = "./"//fnxmf

! Open HDF5
      CALL h5open_f (error)
! Note:
! H5F_ACC_TRUNC_F: delete the file if that is exist
! H5F_ACC_EXCL_F : fail writing to the file if that  is exist
      CALL h5fcreate_f(fpath, H5F_ACC_TRUNC_F, file_id, error)
      write(6,*) "opening ",trim(fpath)
! connectivity data
      dims(:) = 0
      rank = 2
      dims(1) = 8
      dims(2) = Nelements

      dsetname="/Hexahedrons"
      call  hdf5OUTINT(file_id,rank,dims,dsetname,connectivity)

! xyz data
      dims(:) = 0
      rank = 2
!      dims(1) = Nnodes
!      dims(2) = 3
      dims(1) = 3
      dims(2) = Nnodes
      dsetname="/xyz"
      call  hdf5OUT(file_id,rank,dims,dsetname,xyz)

! fld data
      dims(:) = 0
      rank = 1
      dims(1) = Nnodes
      dsetname="/var1"
      call  hdf5OUT(file_id,rank,dims,dsetname,fldun(:,1))

      call  h5Fclose_f(file_id,error)

      return
      end subroutine OutputHDF5
      
      subroutine hdf5OUTINT(file_id,rank,dims,dsetname,dset)
      use hdf5
      implicit none
      integer(hid_t),intent(in) :: file_id                    ! file identifier
      integer,intent(in)  :: rank                             ! dataset rank
      integer(hsize_t), dimension(rank),intent(in)  :: dims   ! dataset dimensions
      character(80),intent(in):: dsetname                     ! dataset name
      integer,intent(in) :: dset
c
      integer(hid_t) :: dset_id       ! dataset identifier
      integer(hid_t) :: dspace_id     ! dataspace identifier
      integer :: error
! Create the data space for the data set
      call h5Screate_simple_f(rank, dims, dspace_id, error)
! Get dset_id for data set
      call h5Dcreate_f(file_id,dsetname,h5t_native_integer,dspace_id,
     .                 dset_id,error)
! Write the data
      call h5Dwrite_f(dset_id, h5t_native_integer, dset, dims, error)
! Close the data id
      call h5Dclose_f(dset_id, error)
! Close the data space
      call h5Sclose_f(dspace_id, error)
c
      return
      end subroutine hdf5outint

      subroutine hdf5OUT(file_id,rank,dims,dsetname,dset)
      use hdf5
      implicit none
      integer(hid_t),intent(in) :: file_id                    ! file identifier
      integer,intent(in)  :: rank                             ! dataset rank
      integer(hsize_t), dimension(rank),intent(in)  :: dims   ! dataset dimensions
      character(80),intent(in):: dsetname                     ! dataset name
      real(4),intent(in) :: dset
c
      integer(hid_t) :: dset_id       ! dataset identifier
      integer(hid_t) :: dspace_id     ! dataspace identifier
      integer :: error
! Create the data space for the data set
      call h5Screate_simple_f(rank, dims, dspace_id, error)
! Get dset_id for data set
      call h5Dcreate_f(file_id,dsetname,h5t_native_real,dspace_id,
     .                 dset_id,error)
! Write the data
      call h5Dwrite_f(dset_id, h5t_native_real, dset, dims, error)
! Close the data id
      call h5Dclose_f(dset_id, error)
! Close the data space
      call h5Sclose_f(dspace_id, error)
c
      return
      end subroutine hdf5out

      subroutine OutputXDMF
      use unstparam
      implicit none
      integer unitxmf
      character*(80) :: NUMTEXT,TIMEEXP
      character(80) :: dsetname                   ! dataset name
      integer::n

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Writing XDMF file
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Determine the output filename
! FileOpen
      unitxmf=1221
      open(unitxmf,file=fpxmf,status='unknown',form='formatted')
      write(6,*) "opening ",trim(fpxmf)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Header
      write(unitxmf,'(a)')'<?xml version="1.0" ?>'
      write(unitxmf,'(a)')'<!DOCTYPE Xdmf SYSTEM "Xdmf.dtd" []>'
      write(unitxmf,'(a)')'<Xdmf Version="2.0">'
      write(unitxmf,'(a)')'  <Domain>'
      write(unitxmf,'(a)')'    <Grid Name="3D Unstructured Mesh">'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Time
      write(TIMEEXP,"(I0)") int(timedmp)
      write(unitxmf,'(a)')'      <Time Value="'//trim(TIMEEXP)//'"/>'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Coordinate
      write(NUMTEXT,"(I0)") Nelements
      write(unitxmf,'(a)')'      <Topology'
     &               //' TopologyType="Hexahedron" NumberOfElements="'
     &               //trim(NUMTEXT)//'" >'

#ifndef debugXDMF
      write(NUMTEXT,"(I0)") Nelements*8
      write(unitxmf,'(a)')'      <DataItem'
     &               //' Dimensions="'//trim(NUMTEXT)//'" Format="HDF">'
      write(unitxmf,'(a)')'	  ' // trim(fname) //":/Hexahedrons"
      write(unitxmf,'(a)')'      </DataItem>'
#else
      write(NUMTEXT,"(I0,1x,I0)") Nelements,8
      write(unitxmf,'(a)')'      <DataItem'
     &               //' Dimensions="'//trim(NUMTEXT)//'"'
     &               //' Format="XML" DataType="Int" >'
      do n=1,Nelements
         write(unitxmf,'(8(1x,I0))') connectivity(1,n),connectivity(2,n),connectivity(3,n),connectivity(4,n)
     &                              ,connectivity(5,n),connectivity(6,n),connectivity(7,n),connectivity(8,n)
      enddo
      write(unitxmf,'(a)')'      </DataItem>'
#endif
      write(unitxmf,'(a)')'      </Topology>'
      write(unitxmf,'(a)')'      <Geometry GeometryType="XYZ">'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! xyz coordinate

#ifndef debugXDMF
      write(NUMTEXT,"(I0)") Nnodes*3
      dsetname = "xyz"
      write(unitxmf,'(a)')
     &                '        <DataItem Dimensions="' // trim(NUMTEXT)
     &              //'" Name="' // trim(dsetname) // '"'
      write(unitxmf,'(a)') '          ' //
     &               'NumberType="Float" Precision="4" Format="HDF">'
      write(unitxmf,'(a)')'	  ' // trim(fname) //":/xyz"
      write(unitxmf,'(a)')'        </DataItem>'
#else
      write(NUMTEXT,"(I0,1x,I0)") Nnodes,3
      dsetname = "xyz"
      write(unitxmf,'(a)')
     &                '        <DataItem Dimensions="' // trim(NUMTEXT)//'"'
      write(unitxmf,'(a)') '     Format="XML">'
      do n=0,Nnodes-1
         write(unitxmf,'(3(1x,f6.2))') xyz(1,n),xyz(2,n),xyz(3,n)
      enddo
      write(unitxmf,'(a)')'        </DataItem>'
#endif

      write(unitxmf,'(a)')'      </Geometry>'

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Var1
#ifndef debugXDMF
      dsetname="var1"
      write(unitxmf,'(a)')'      <Attribute Name="'//trim(dsetname)
     &              //'" AttributeType="Scalar" Center="Node">'
      write(NUMTEXT,"(I0)") Nnodes
      write(unitxmf,'(a)')'        '
     &                    //'<DataItem Dimensions="'//trim(NUMTEXT)//'"'
      write(unitxmf,'(a)')'          ' //
     &                'NumberType="Float" Precision="4" Format="HDF">'
      write(unitxmf,'(a)')'	  '//trim(fname)//":/var1"
      write(unitxmf,'(a)')'        </DataItem>'
      write(unitxmf,'(a)')'      </Attribute>'
#endif
! Footer
      write(unitxmf,'(a)')'    </Grid>'
      write(unitxmf,'(a)')'  </Domain>'
      write(unitxmf,'(a)')'</Xdmf>'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      close(unitxmf)

      return
      end subroutine OutputXDMF
      
