	SUBROUTINE GWTHR ( sys, np, wtcod, x, y, ixoff, iyoff, iret )
C************************************************************************
C* GWTHR								*
C*									*
C* This subroutine plots weather symbols in any coordinate system.	*
C* The symbols are drawn using attributes defined by GSWTHR.		*
C*									*
C* GWTHR ( SYS, NP, WTCOD, X, Y, IXOFF, IYOFF, IRET )			*
C*									*
C* Input parameters:							*
C*	SYS		CHAR*		Coordinate system		*
C*                                        'S' = screen coordinates      *
C*					  'D' = device coordinates	*
C*					  'N' = normalized coordinates	*
C*					  'V' = view coordinates	*
C*					  'P' = plot coordinates	*
C*					  'M' = map coordinates		*
C*					  'G' = grid coordinates	*
C*	NP		INTEGER		Number of symbols		*
C*	WTCOD (NP)	REAL		Weather symbol codes		*
C*	X     (NP)	REAL		X coordinates / latitudes	*
C*	Y     (NP)	REAL		Y coordinates / longitudes	*
C*	IXOFF (NP)	INTEGER		X offsets in half characters	*
C*	IYOFF (NP)	INTEGER		Y offsets in half characters	*
C*									*
C* Output parameters:							*
C*	IRET		INTEGER		Return code			*
C**									*
C* Log:									*
C* S. Schotz/GSC	 3/90	GEMPLT Version 5.0			*
C* S. Schotz/GSC	 5/90	Changed weather code to real		*
C* L. Williams/EAi	 3/94	Removed blank comments from header	*
C* M. Linda/GSC		 3/96	Changed check for GPLT buffer overflow	*
C* M. Linda/GSC		12/96	Added check for NP negative or 0	*
C* S. Schotz/NCEP        7/97   Update documentation for S coordinate   *
C************************************************************************
	INCLUDE		'FUNCCODE.PRM'
	INCLUDE		'ERROR.PRM'
	INCLUDE		'GEMPRM.PRM'
C*
	CHARACTER*(*)	sys
	REAL		wtcod (*), x (*), y (*)
	INTEGER		ixoff (*), iyoff (*)
C
	INTEGER		isend (4)
C------------------------------------------------------------------------
	iret = NORMAL
C
C*	Check for zero points.
C
	IF ( np .le. 0 ) RETURN
C
C*	Check if GPLT buffer will overflow.
C
	isnd = 2 + ( 2 + ( 5 * np ) )
	ircv = 1 + ( 1 )
	IF  ( ( isnd + ircv ) .gt. IGBSIZ ) THEN
	    iret = NOBUFF
	    RETURN
	END IF
C
C*	Check validity of the coordinate system.
C
	isys = INDEX ( syslo, sys ) + INDEX ( sysup, sys )
	IF  ( isys .eq. 0 ) THEN
	    iret = NOCORD
	    RETURN
	END IF
C
C*	Load input parameters into buffer and write them to the mailbox.
C
	isend (1) = isnd
	isend (2) = FWTHR
	isend (3) = isys
	isend (4) = np
C
	CALL GPUT ( isend, 4, iret )
	IF ( iret .ne. NORMAL ) RETURN
C
	CALL GPUTR ( wtcod, np, iret)
	IF ( iret .ne. NORMAL ) RETURN
C
	CALL GPUTR ( x, np, iret )
	IF ( iret .ne. NORMAL ) RETURN
C
	CALL GPUTR ( y, np, iret )
	IF ( iret .ne. NORMAL ) RETURN
C
	CALL GPUT ( ixoff, np, iret )
	IF ( iret .ne. NORMAL ) RETURN
C
	CALL GPUT ( iyoff, np, iret )
	IF ( iret .ne. NORMAL ) RETURN
C
C*	Get output parameters.
C
	CALL GGET ( iret, 1, ierr )
	IF ( ierr .ne. NORMAL ) iret = ierr
C*
	RETURN
	END
