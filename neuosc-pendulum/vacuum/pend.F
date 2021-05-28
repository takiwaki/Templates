      module pendulummodule
      implicit none

      real(8)::time,dt
      real(8),parameter::Coulant=0.005d0

      real(8)::omega
      data omega / 0.3d0 /
      real(8)::lambda
      data lambda / 0.0d0 /

      real(8),parameter::theta_mix=0.1d0
      real(8),dimension(3)::bv ! Bloch Vecter
     &                     ,pv ! Polarization Vector
     &                     ,dpv
     &                     ,Lv ! matter vector
     &                     ,Hv

      end module pendulummodule

      program pendulum
      use pendulummodule
      implicit none
      integer, parameter::nmax=10000
      integer::nstp
      real(8)::norm

      call Initialize
      time=0.0
      call Output
      do nstp=1,nmax
         if(nstp >= 1000) then
            if(lambda >= 1.1*omega)then
               lambda=0.99d0*lambda
            else if(lambda >= 0.9*omega)then
               lambda=0.9999d0*lambda
            else 
               lambda=0.99d0*lambda
            endif
         endif
         call EvalForce
!         write(6,*)dpv(:) ! debug
         if(nstp==1)then
            dt = Coulant/sqrt(dpv(1)**2+dpv(2)**2+dpv(3)**2)
         endif
         pv(1:3)=pv(1:3)+ dt*dpv(1:3)
         norm=sqrt(pv(1)**2+pv(2)**2+pv(3)**2)
         pv(1:3)=pv(1:3)/norm
         time=time+dt
         if( mod(nstp,20) == 0) call Output
      enddo

      stop
      end program

      subroutine Initialize
      use pendulummodule
      implicit none

      bv(1)=sin(2.0d0*theta_mix)
      bv(2)=0.0d0
      bv(3)=cos(2.0d0*theta_mix)

      Lv(1)=0.0d0
      Lv(2)=0.0d0
      Lv(3)=-1.0d0

      pv(1)=0.0d0
      pv(2)=0.0d0
      pv(3)=1.0d0

      return
      end subroutine Initialize

      subroutine EvalForce
      use pendulummodule
      implicit none

      Hv(1:3)=omega*bv(1:3)+lambda*Lv(1:3)

      dpv(1)= Hv(2)*pv(3)-Hv(3)*pv(2)
      dpv(2)= Hv(3)*pv(1)-Hv(1)*pv(3)
      dpv(3)= Hv(1)*pv(2)-Hv(2)*pv(1)

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
      write(unitout,'(1a,(1x,F10.2))') "#",time
      write(unitout,'(12(1x,E15.6e3))') pv(1),pv(2),pv(3)
     &                                ,Hv(1),Hv(2),Hv(3)
     &                                ,omega*bv(1),omega*bv(2),omega*bv(3)
     &                                ,lambda*Lv(1),lambda*Lv(2),lambda*Lv(3)
      close(unitout)
      onum=onum+1
      return
      end subroutine Output
