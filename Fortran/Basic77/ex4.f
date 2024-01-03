      program main
      use resolution
      use variables
      implicit none
      real(8),dimension(:,:),allocatable:: B
      imax=2
      jmax=3 
      allocate(B(imax,jmax))

      call SetA 
      write(6,*)"A[1][1]=",A(1,1)

      call savetempvar(A,B)
      A(:,:) = B (:,:)
      write(6,*)"A[1][1]=",A(1,1)

      call savetempvar(A,B)
      A(:,:) = B (:,:)
      write(6,*)"A[1][1]=",A(1,1)

      end program

      subroutine setA()
      use resolution
      use variables
      implicit none
      integer::i,j
      allocate(A(imax,jmax))
      do j=1,jmax
      do i=1,imax
        A(i,j) = 1.0d0
      enddo
      enddo
      return
      end subroutine setA

      subroutine savetempvar(A,B)
      use resolution, only: imax,jmax
      implicit none
      real(8),dimension(imax,jmax),intent(in):: A
      real(8),dimension(imax,jmax),intent(out):: B
      real(8),dimension(:,:),allocatable,save:: C
      integer::i,j
      logical,save::is_inited
      data is_inited /.false./

      if(.not. is_inited)then
      allocate(C(imax,jmax)) 
      do j=1,jmax
      do i=1,imax
        C(i,j) = 1.0d0
      enddo
      enddo
      is_inited = .true.

      endif

      do j=1,jmax
      do i=1,imax
        B(i,j) =A(i,j) +C(i,j)
      enddo
      enddo

      return
      end subroutine savetempvar
