      module pendulummodule
      implicit none

      real(8)::time,dt
      real(8),parameter::Coulant=0.05d0

      real(8)::omega
      data omega / 0.1d0 /
      real(8),parameter::theta_mix=0.1d0
      real(8),dimension(3)::bv ! Bloch Vecter
     !                     ,pv ! Polarization Vector
     !                     ,dpv
      end module pendulummodule

      program pendulum
      use pendulummodule
      implicit none
      integer, parameter::nmax=1000
      integer::nstp

      call Initialize
      time=0.0
      call Output
      do nstp=1,nmax
         call EvalForce
!         write(6,*)dpv(:) ! debug
         dt = Coulant/sqrt(dpv(1)**2+dpv(2)**2+dpv(3)**2)
         pv(1:3)=pv(1:3)+ dt*dpv(1:3)
         time=time+dt
         if( mod(nstp,10) == 0) call Output
      enddo

      stop
      end program

      subroutine Initialize
      use pendulummodule
      implicit none

      bv(1)=sin(2.0*theta_mix)
      bv(2)=0.0d0
      bv(3)=cos(2.0*theta_mix)

      pv(1)=0.0d0
      pv(2)=0.0d0
      pv(3)=1.0d0

      return
      end subroutine Initialize

      subroutine EvalForce
      use pendulummodule
      implicit none

      dpv(1)= omega*(bv(2)*pv(3)-bv(3)*pv(2))
      dpv(2)= omega*(bv(3)*pv(1)-bv(1)*pv(3))
      dpv(3)= omega*(bv(1)*pv(2)-bv(2)*pv(1))

      return
      end subroutine EvalForce

      subroutine Output
      use pendulummodule
      implicit none
      integer,parameter:: unitout=1100
      integer,save :: onum
      data onum / 0 /
      character(40)::outfile
      character(40)::path
      write(outfile,"(a3,i5.5,a4)") 'plv',onum,'.dat'
      path='./data/' // outfile
      open(unitout,file=path,status='replace',form='formatted') 
      write(unitout,'(4(1x,E15.6e3))') time,pv(1),pv(2),pv(3)
      close(unitout)
      onum=onum+1
      return
      end subroutine Output
