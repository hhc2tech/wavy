!
! wavy - A spectral ocean wave modeling and development framework
! Copyright (c) 2017, Wavebit Scientific LLC
! All rights reserved.
!
! Licensed under the BSD-3 clause license. See LICENSE for details.
!
program test_pierson_moskowitz

use mod_precision,only:rk => realkind
use mod_spectrum,only:spectrum_type
use mod_spectral_shapes,only:piersonMoskowitz
use mod_utility,only:range

implicit none

type(spectrum_type) :: spec
real(kind=rk),dimension(:),allocatable :: wspd
real(kind=rk),parameter :: grav = 9.8_rk
integer :: n

write(*,*)
write(*,*)'Test omnidirectional spectrum with Pierson-Moskowitz shape;'
write(*,*)'Vary wind speed from 5 to 60 m/s with 5 m/s increments.'
write(*,*)

! Initialize spectrum
spec = spectrum_type(fmin=0.0313_rk,fmax=2._rk,df=1.1_rk,ndirs=1,depth=1e3_rk)

! Set array of wind speed values
wspd = range(5,60,5)

write(*,fmt='(a)')'   wspd      Hs      Tp       Tm1      Tm2      mss      m0(f)'&
                //'    m1(f)    m2(f)'
write(*,fmt='(a)')'----------------------------------------------------------'&
                //'----------------------'
do n = 1,size(wspd)
  ! Set the spectrum field to Pierson-Moskowitz parametric shape
  call spec % setSpectrum(piersonMoskowitz(spec % getFrequency(),wspd=wspd(n),&
                                           grav=grav))
  write(*,fmt='(9(f8.4,1x))')wspd(n),spec % significantWaveHeight(),&
    1./spec % peakFrequency(),spec % meanPeriod(),&
    spec % meanPeriodZeroCrossing(),spec % meanSquareSlope(),&
    spec % frequencyMoment(0),spec % frequencyMoment(1),&
    spec % frequencyMoment(2)
enddo

endprogram test_pierson_moskowitz
