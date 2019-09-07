MODULE A

  USE precise, ONLY : defaultp
  USE io
  USE fourthconst
  USE fifthpanel

!! variable declarations

  IMPLICIT NONE    ! makes sure the compiler complains about 
                   ! undeclared variables
  INTEGER, PARAMETER, PRIVATE :: WP=defaultp

CONTAINS

  FUNCTION panelinfluence( fieldpoint, center, area, coordsys, cornerslocal) RESULT (vel)
    !
    ! Function to compute the del dot phi
    ! It will return a 3D velocity vector
    ! Equivlent to the far approximation
    ! of the velocity induced by a panel
    ! source q on a point p.
    INTEGER :: i,j,k
    REAL(wp), DIMENSION(3) :: vel
    REAL(wp), DIMENSION(3) :: dphi           ! Page 3 of the notes
    REAL(wp), DIMENSION(3,3) :: ddphi
    REAL(wp), DIMENSION(3) :: fieldpoint
    REAL(wp), DIMENSION(3) :: center
    REAL(wp) :: area
    REAL(wp), DIMENSION(3,3) :: coordsys     ! local coordinate system
    REAL(wp), DIMENSION(2,4) :: cornerslocal ! quad corners in local coordinate system
    REAL(wp), DIMENSION(3) :: plocal         ! fieldpoint "p" in local coordinate system
    REAL(wp), DIMENSION(3) :: vellocal

    REAL(wp), DIMENSION(4) :: d,e,h,m,r

    integer, dimension(4) :: ip1 = (/ 2, 3, 4, 1 /)
    plocal = MATMUL((TRANSPOSE(coordsys)),fieldpoint-center)
    
    !write(6,*) 'center', center
    !write(6,*) 'plocal', plocal 


    dphi(1)=0.
    dphi(2)=0.
    dphi(3)=0.


    Do, k=1,4     
      
       !write(6,*)'cornerslocal', cornerslocal(:,k)      
       d(k) = sqrt((cornerslocal(1,ip1(k))-cornerslocal(1,k))**2.+(cornerslocal(2,ip1(k))-cornerslocal(2,k))**2.)
       e(k) = (plocal(1)-cornerslocal(1,k))**2. + plocal(3)**2.
       h(k) = ((plocal(1)-cornerslocal(1,k))*(plocal(2)-cornerslocal(2,k)))
       m(k) = (((cornerslocal(2,ip1(k)))-(cornerslocal(2,k))) /(cornerslocal(1,ip1(k))-(cornerslocal(1,k))))
       r(k) = sqrt(((plocal(1))-(cornerslocal(1,k)))**2.+((plocal(2))-(cornerslocal(2,k)))**2.+(plocal(3))**2.)


       !write(6,*) 'd(k)', d(k)
       !write(6,*) 'e(k)', e(k)
       !write(6,*) 'h(k)', h(k)
       !write(6,*) 'm(k)', m(k)
       !write(6,*) 'r(k)', r(k)

     end do


     do, k=1,4
   
       If (abs(d(k))> 0.000001) then
       
          dphi(1) = dphi(1)+((((cornerslocal(2,ip1(k)))-(cornerslocal(2,k)))/d(k))*log((r(k)+r(ip1(k))-d(k))/(r(k)+r(ip1(k))+d(k))))

          dphi(2) = dphi(2)-(cornerslocal(1,ip1(k))-(cornerslocal(1,k)))/d(k)*log((r(k)+r(ip1(k))-d(k))/(r(k)+r(ip1(k))+d(k)))

          dphi(3) = dphi(3)+(atan((m(k)*e(k)-h(k))/(plocal(3)*r(k)))- atan((m(k)*e(ip1(k))-h(ip1(k)))/(plocal(3)*r(ip1(k)))))

          !!
          !! NOW TEST THE SECOND DERIVATIVES ( these will be needed for phase III )
          ddphi(1,1) =ddphi(1,1) + (2.*(cornerslocal(2,ip1(k)) - cornerslocal(2,k))/( (r(k)+r(ip1(K)))**2 - d(k)**2) *&
               ((plocal(1)-cornerslocal(1,k))/r(k)+(plocal(1)-cornerslocal(1,ip1(k)))/r(ip1(K)) ))

          ddphi(1,2) =ddphi(1,2)+ (-2.*(cornerslocal(1,ip1(k)) - cornerslocal(1,k))/( (r(k)+r(ip1(K)))**2 - d(k)**2) *&
               ((plocal(1)-cornerslocal(1,k))/r(k)+(plocal(1)-cornerslocal(1,ip1(k)))/r(ip1(K)) ))

          ddphi(1,3) =ddphi(1,3)+( plocal(3) * (cornerslocal(2,ip1(k)) - cornerslocal(2,k)) * (r(k) - r(ip1(k)))  /&
               ((r(k)*r(ip1(k)))* ( r(k)*r(ip1(k)) + ((plocal(1)-cornerslocal(1,k))*(plocal(1)*cornerslocal(1,ip1(K)))) &
               +((plocal(2)-cornerslocal(2,k))*(plocal(2)-cornerslocal(2,ip1(k))))  + (plocal(3)**2)    )))





          ddphi(2,1) = ddphi(2,1)+(2.*(cornerslocal(2,ip1(k)) - cornerslocal(2,k))/( (r(k)+r(ip1(K)))**2 - d(k)**2) *&
               ((plocal(2)-cornerslocal(2,k))/r(k)+(plocal(2)-cornerslocal(2,ip1(k)))/r(ip1(K)) ))

          ddphi(2,2) =ddphi(2,2)+(-2.*(cornerslocal(1,ip1(k)) - cornerslocal(1,k))/( (r(k)+r(ip1(K)))**2 - d(k)**2) *&
               ((plocal(2)-cornerslocal(2,k))/r(k)+(plocal(2)-cornerslocal(2,ip1(k)))/r(ip1(K)) ))

          ddphi(2,3) =ddphi(2,3)+(-plocal(3) * (cornerslocal(1,ip1(k)) - cornerslocal(1,k)) * (r(k) - r(ip1(k)))  /&
               ((r(k)*r(ip1(k)))* ( r(k)*r(ip1(k)) + ((plocal(1)-cornerslocal(1,k))*(plocal(1)*cornerslocal(1,ip1(K)))) &
               +((plocal(2)-cornerslocal(2,k))*(plocal(2)-cornerslocal(2,ip1(k))))  + (plocal(3)**2)    )))




          ddphi(3,1) =ddphi(3,1)+( 2.*(cornerslocal(2,ip1(k)) - cornerslocal(2,k))/( (r(k)+r(ip1(K)))**2 - d(k)**2) *&
               (   plocal(3)/r(k) + plocal(3)/r(ip1(k))  ))

          ddphi(3,2) =ddphi(3,2)+(-2.*(cornerslocal(1,ip1(k)) - cornerslocal(1,k))/( (r(k)+r(ip1(K)))**2 - d(k)**2) *&
               (   plocal(3)/r(k) + plocal(3)/r(ip1(k))  ))

          ddphi(3,3) =ddphi(3,3)+((((plocal(1)-cornerslocal(1,k))*(plocal(2)-cornerslocal(2,ip1(k)))) &
               - ((plocal(1)-cornerslocal(1,ip1(k)))*(plocal(2)-cornerslocal(2,k))))*(r(k)-r(ip1(k)))/&
               ((r(k)*r(ip1(k)))*   (  r(k)*r(ip1(k))  +((plocal(1)-cornerslocal(1,k))*(plocal(1)*cornerslocal(1,ip1(K)))) &
               +(plocal(2)-cornerslocal(2,k))*(plocal(2)-cornerslocal(2,ip1(k)))  + (plocal(3)**2)    )))


       End if

    End do

    ddphi = -1./(4.*pi) * ddphi

    dphi(1)=-1./(4.*pi)*dphi(1)
    dphi(2)=-1./(4.*pi)*dphi(2)
    dphi(3)=-1./(4.*pi)*dphi(3)
     

    !write(6,*) 'dphi(1)', dphi(1)
    !write(6,*) 'dphi(2)', dphi(2)
    !write(6,*) 'dphi(3)', dphi(3)
!!$    write(6,*) 'ddphi(1,2)', ddphi(1,2)
!!$    write(6,*) 'ddphi(2,1)', ddphi(2,1)
!!$    write(6,*) ''
!!$    write(6,*) 'ddphi(1,3)', ddphi(1,3)
!!$    write(6,*) 'ddphi(3,1)', ddphi(3,1)
!!$    write(6,*) ''
!!$    write(6,*) 'ddphi(2,3)', ddphi(2,3)
!!$    write(6,*) 'ddphi(3,2)', ddphi(3,2)



    vellocal=(/ dphi(1),dphi(2),dphi(3) /)
    !write(6,*) 'vellocal'
    !write(6,'(3D16.8)')  vellocal

     vel=MATMUL(coordsys,vellocal)
     !if ( (sum(vel(:)**2)) > 9999.) then
     !   vel = (/0.,0.,0./)
     !end if

     !write(6,*) 'vel'
     !write (6,'(3D16.8)') vel
     !write(6,*) ''

   END FUNCTION panelinfluence

END MODULE A
