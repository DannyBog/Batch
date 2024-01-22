@echo off

SETLOCAL EnableDelayedExpansion

:main
	call :InitBoards
	set /a gridsNum = (%elementsNum% - 1) / 81

	for /l %%g in (0, 1, %gridsNum%) do (
		set /a grid=%%g + 1
		if !grid! LEQ 9 (
			echo Grid 0!grid!
		) else (
			echo Grid !grid!
		)

		set /a offset = %%g * 81
		set /a elementsNum = !offset! + 81
		call :SolveBoards !offset! !elementsNum!

		call :PrintBoards %%g
		set "solved="
	)

	pause

:InitBoards
	set /a linesNum=0
	for /f %%g in (sudoku.txt) do (
		(echo %%g| findstr /v "^Grid [0-9]+$">nul) && (
			set arr[!linesNum!]=%%g
			set /a linesNum+=1
		)
	)

	set /a linesNum=0
	set /a elementsNum=0
	set /a colNum=0
	:while1
		call set str=%%arr[%linesNum%]%%
		if not defined str (goto :eof)

		:while2
			call set boards[%elementsNum%]=%%str:~%colNum%,1%%
			set /a elementsNum+=1
			set /a colNum+=1
			if %colNum% GTR 8 (goto resume_while1)
		goto while2
	
	:resume_while1
		set /a colNum=0
		set /a linesNum+=1
	goto while1

:PrintBoards (int grid)
	set /a start = %1 * 9
	set /a end = %start% + 8
	for /l %%g in (%start%, 1, %end%) do (
		set row=%%g
		for /l %%h in (0, 1, 8) do (
			set col=%%h

			set /a index = !col! + !row! * 9
			call echo|set /p=%%boards[!index!]%%

			if !col! LSS 8 (echo|set /p"=, ")
			if !col! EQU 8 (echo()
		)
	)
	echo(
	exit /b

:SolveBoards (int offset, int elementsNum)
	if defined solved (goto :eof)

	set /a index=%1
	:while
		call set value=%%boards[%index%]%%
		if %value% EQU 0 (goto recursion)
		set /a index+=1
		if %index% GEQ %2 (set solved=true & goto :eof)
	goto while

	:recursion
		for /l %%g in (1, 1, 9) do (
			(call :VerticalCheck %index% %%g) && (call :HorizontalCheck %index% %%g) && (call :RegionCheck %index% %%g) && (
				set boards[%index%]=%%g
				call :SolveBoards %index% %2
				if defined solved (goto :eof)
				set boards[%index%]=0
			)
		)
	
	exit /b

:VerticalCheck (int index, int num)
	set /a col = %1 %% 9
	for /l %%g in (0, 1, 8) do (
		set /a row = %%g + (%1 / 81^) * 9
		set /a pos = %col% + !row! * 9
		call set value=%%boards[!pos!]%%
		if !value! EQU %2 (exit /b -1)
	)

	exit /b 0

:HorizontalCheck (int index, int num)
	set /a row = ((%1 / 9) %% 9) + (%1 / 81) * 9
	for /l %%g in (0, 1, 8) do (
		set col=%%g
		set /a pos = !col! + %row% * 9
		call set value=%%boards[!pos!]%%
		if !value! EQU %2 (exit /b -1)
	)

	exit /b 0

:RegionCheck (int index, int num)
	set /a row = (%1 / 9) %% 9
	set /a col = %1 %% 9

	if %row% LEQ 2 (set /a row = (%1 / 81^) * 9)
	if %row% GEQ 3 if %row% LEQ 5 (set /a row = 3 + (%1 / 81^) * 9)
	if %row% GEQ 6 if %row% LEQ 8 (set /a row= 6 + (%1 / 81^) * 9)

	if %col% LEQ 2 (set col=0)
	if %col% GEQ 3 if %col% LEQ 5 (set col=3)
	if %col% GEQ 6 if %col% LEQ 8 (set col=6)

	for /l %%g in (0, 1, 2) do (
		for /l %%h in (0, 1, 2) do (
			set /a pos = (%col% + %%h^) + (%row% + %%g^) * 9
			call set value=%%boards[!pos!]%%
			if !value! EQU %2 (exit /b -1)
		)
	)

	exit /b 0

ENDLOCAL