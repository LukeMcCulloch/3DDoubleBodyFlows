MODULE A

  USE precise, ONLY : defaultp
  USE io
  USE fourthconst

!! variable declarations

  IMPLICIT NONE    ! makes sure the compiler complains about 
                   ! undeclared variables
  INTEGER, PARAMETER, PRIVATE :: WP=defaultp

CONTAINS

  FUNCTION panelinfluence( fieldpoint, center, area) RESULT (vel)
    !
    ! Function to compute the del dot phi
    ! It will return a 3D velocity vector
    ! Equivlent to the far approximation
    ! of the velocity induced by a panel
    ! source q on a point p.
    INTEGER :: i,j
    REAL(wp), DIMENSION(3) :: vel
    REAL(wp), DIMENSION(3) :: fieldpoint
    REAL(wp), DIMENSION(3) :: center
    REAL(wp) :: area

    vel(1) = (1./(4*pi))*( fieldpoint(1)-center(1) )/&
           ( ( (fieldpoint(1)-center(1))**2.+&
           (fieldpoint(2)-center(2))**2.+&
           (fieldpoint(3)-center(3))**2. )**(3./2.))

    vel(2) = (1./(4*pi))*( fieldpoint(2)-center(2) )&
         / ( ( (fieldpoint(1)-center(1))**2.&
         +(fieldpoint(2)-center(2))**2.&
         +(fieldpoint(3)-center(3))**2. )**(3./2.))

    vel(3) = (1./(4*pi))*( fieldpoint(3)-center(3) )&
         / ( ( (fieldpoint(1)-center(1))**2.&
         +(fieldpoint(2)-center(2))**2.&
         +(fieldpoint(3)-center(3))**2. )**(3./2.))

    vel=area*vel
    !vel(1)=vel(1)*area(i)
    !vel(2)=vel(2)*area(i)
    !vel(3)=vel(3)*area(i)

  END FUNCTION panelinfluence

END MODULE A
