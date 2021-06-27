      program main
      use resolution
      use variables
      implicit none
      real(8),dimension(:,:),allocatable:: B
      imax=2
      jmax=3
      allocate(A(imax,jmax)) 
      call SetA
      write(6,*)"A[1][1]=",A(1,1)
      allocate(B(imax,jmax)) 
      B(:,:) = A (:,:)
      write(6,*)"B[1][1]=",B(1,1)
      call changeB(B)
      write(6,*)"B[1][1]=",B(1,1)
      end program

      subroutine setA()
      use resolution
      use variables
      implicit none
      integer::i,j
      do j=1,jmax
      do i=1,imax
        A(i,j) = 1.0d0
      enddo
      enddo
      return
      end subroutine setA

      subroutine changeB(B)
      use resolution
      implicit none
      real(8),dimension(imax,jmax),intent(inout):: B
      integer::i,j
      do j=1,jmax
      do i=1,imax
        B(i,j) = 2.0d0
      enddo
      enddo
      return
      end subroutine changeB
