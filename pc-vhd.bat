@echo off
cd /d "%~dp0"

REM Verificar si el directorio actual contiene espacios en el path
if NOT "%cd%"=="%cd: =%" (
   echo El directorio actual contiene espacios en el path.
   echo Este comando debe estar en un path que no contenga espacios. 
   rundll32.exe cmdext.dll,MessageBeepStub
   pause
   echo.
   goto :EOF
)

REM Verificar si el script se está ejecutando con privilegios de administrador
if {%1} EQU {[adm]} goto :data
REG QUERY HKU\S-1-5-19\Environment >NUL 2>&1 && goto :data

REM Construir el comando para ejecutar el script con privilegios de administrador
set command="""%~f0""" [adm] %*
setlocal enabledelayedexpansion
set "command=!command:'=''!"

REM Iniciar PowerShell para ejecutar el símbolo del sistema con privilegios de administrador
powershell -NoProfile Start-Process -FilePath '%COMSPEC%' ^
-ArgumentList '/c """!command!"""' -Verb RunAs 2>NUL
goto :EOF

:data
setlocal enabledelayedexpansion

REM Si el primer argumento es [adm], configurar la variable adm
if {%1} EQU {[adm]} (
   set adm=%1
   shift
) ELSE (set adm=)

REM ==============================================
REM CODIGO A EJECUTAR
REM ==============================================
:cuerpo
@echo off
setlocal enabledelayedexpansion
title Montar archivos VHD y ISO
color 02
mode con cols=100 lines=20
cls
REM Extrae el parametro del acceso directo.
REM Comprueba los parametro que se le pasan a este ejecutable. Obligatorio 3 parametros, el 4 indica el ejecutable del juego / programa.
if "%1" == "" (
  echo Error: No se ha seleccionado una opcion.
  echo Ejemplo: %0 -montar / -desmontar / -explorar
  pause
  exit /b 1
)
if "%2" == "" (
  echo Error: No se ha seleccionado un archivo VHD, VHDX.
  echo Ejemplo: %0 -montar {ImagePath} / c:\Juego.VHD
  pause
  exit /b 1
)
if "%3" == "" (
  echo Error: No se ha especificado el nombre del volumen VHD, VHDX.
  echo Ejemplo: %0 -montar {ImagePath} {ImageNameNoExt}/ Juego ETIQUETA del Volumen. Lo optiene del nombre del archivo VHD
  pause
  exit /b 1
)
if "%4" == "" (
  echo Error: No se ha especificado si tiene ISO.
  echo Ejemplo Playnite: %0 -montar {ImagePath} {ImageNameNoExt} -s / -n Juego.exe
  echo.
  echo Ejemplo Otros: %0 -montar  X:\Midisco.vhd NombreDelVolumen -s Juego.exe
  pause
  exit /b 1
)

REM Comprueba si el SEXTO 6 parametro no esta vacio
set "trabajo=%6"
if not "%trabajo%"=="" (
	REM Si no esta vacio ejecuta la comprobacion.
	if not "%trabajo%" == "-p" (
		REM si no es igual a -p continua para comprobar si termina en \
		REM Comprueba si el sexto parámetro termina en "\"
		set "ultimo_caracter=!trabajo:~-1!"
		if not "!ultimo_caracter!"=="\" (
			echo Ultimo caracter detectado: "!ultimo_caracter!"
			echo "El sexto parametro tiene que ser (VACIO)" 
			echo " -p (principal)"  
			echo " RutaCarpeta\ (ruta de carpeta de trabajo terminando en \".
			echo Presiona para salir.
			pause > nul
			goto :salir
		)
	)
)
if "%trabajo%"=="-p" (
	REM Si es igual a -p Lo limpia para que no afecte al funcionamento.
	set "trabajo="
)

REM Obtiene los parámetros a partir del SEXTIMO 7+ y se los pasa a los EXE de juegos.
set "parametrosEXE="
set contador=0
for %%A in (%*) do (
    set /a contador+=1
    if !contador! gtr 6 (
        set "parametrosEXE=!parametrosEXE! %%A"
    )
)
Echo Parametros para los Juegos: %parametrosEXE%
timeout /t 1 > nul

rem Variables asignadas para parametros.
set "accion=%1"
set "vhdPath="%2"
set "vhdvolumen=%3"
set "iso=%4"
set "exejuego=%5"
set "trabajo=%trabajo%"
rem Compartidas para ejecutar o instalar vhdattach.
set "power=powershell.exe -ExecutionPolicy Bypass -File"
set "programPath=.\pc-vhdx.ps1"
set "script=%power% %programPath%"
set "vhdattachinstallar=.\requisitos\pc-vhdx.ps1"
REM Montar o Desmontar VHD.
set "vhdmontar=/attach /rompacht"
set "vhddesmontar=/detach /rompacht"
REM ISO MONTAR / Desmontar
set "isomontar=/attach /rompacht"
set "isoDesmontar=/detach /rompacht"


rem Comprueba si pc-vhdx.ps1 esta en el sistema.
:requisitos
if exist "%programPath%" (
    echo pc-vhdx.ps1 encontrado.
    rem Continua con el resto
    goto accionX
) else (
    echo pc-vhdx.ps1 no se ha encontrado.
    echo.
    echo No se puede continuar. Se necesita pc-vhdx.ps1 para continuar.
    echo.
    echo Presione Y para instalar pc-vhdx.ps1 o cualquier otra tecla para salir.
    echo.
    choice /c YN /M "Respuesta:"
    if errorlevel 2 (
        echo Ha elegido salir. El programa se cerrará.
        goto salir
    ) else (
        set "instalary=y"
        goto instalar
    )
)



:instalar
if exist "%vhdattachinstallar%" (
    if "%instalary%"=="y" (
        echo %vhdattachinstallar%
        copy /Y "%vhdattachinstaller%" .\
		pause
        goto requisitos
    )
) else (
    if "%instalary%"=="y" (
        echo El archivo de scrip de pc-vhdx.ps1 no existe.
        echo Abriendo la pagina de descarga...
		timeout /t 3 >nul
        start "" "https://github.com/Gente-del-Condado/pc-vhd/blob/b46ecc18bae4a98bfe053b8c130759ff45a445f3/pc-vhdx.ps1"
		pause
		cls
    )
    goto requisitos
)

:accionX
if "%accion%"=="-montar" (
	cls
	set "aa=!script! !vhdmontar! !vhdPath!"
	echo Montando !vhdPath!, espere...		
	call !aa!
	rem Salta a obtenerletra, para ejecutar el codigo que busca la letra de la unidad por el nombre del Volumen.
	goto :obtenerletra
	:continuar
	rem Echo la letra de la unidad es %Letra%
	set "isoPath=%Letra%:\ISO\ISO.iso"
	set "exejuegoX=%Letra%:\%exejuego%"
	set "ruta_trabajo=%Letra%:\%trabajo%
	cls
    if "%iso%"=="-s" (
        set "ab=!script! !isomontar! !isoPath!"
        echo Montando archivo ISO !isoPath!, espere...
        call !ab!
		cls
        echo "Ejecutando %exejuegoX%..."
        start /wait "" /D "%ruta_trabajo%" "%exejuegoX%" %parametrosEXE%
        set "accion=-desmontar"
        goto accionX
    ) else if "%iso%"=="-n" (
        echo "Ejecutando %exejuegoX%..."
        start /wait "" /D "%ruta_trabajo%" "%exejuegoX%" %parametrosEXE%
        set "accion=-desmontar"
        goto accionX
    )
REM Accion Abrir Explorador.
) else if "%accion%"=="-explorar" (
	set "ca=!script! !vhdmontar! !vhdPath!"
	echo Montando !vhdPath!, espere...		
	call !ca!
	cls
	echo Obteniendo la letra de la unidad...
	rem Salta a obtenerletra, para ejecutar el codigo que busca la letra de la unidad por el nombre del Volumen.
	goto :obtenerletraX
	:continuarX
	rem Echo la letra de la unidad es %Letra%
	set "isoPath=%Letra%:\ISO\ISO.iso"
	cls
    if "%iso%"=="-s" (
        set "cb=!script! !isomontar! !isoPath!"
        echo Montando archivo ISO !isoPath!, espere...
        call !cb!
		cls
        echo "Abriendo %Letra%:\..."
        start /wait "" explorer "%Letra%:\"
        echo ---No cierre esta ventana directamente---
		echo.
		echo Presiona enter, para desmontar/explusar el juego, y cerrar.
        pause > nul
        set "accion=-desmontar"
        goto accionX
    ) else if "%iso%"=="-n" (
		cls
        echo "Abriendo carpeta %Letra%..."
        start /wait "" explorer "%Letra%:\"
        echo ---No cierre esta ventana directamente---
        echo.
        echo Presiona enter, para desmontar/explusar el juego, y cerrar.
		pause > nul
        set "accion=-desmontar"
        goto accionX
    )
REM Accion desmontar
) else if "%accion%"=="-desmontar" (
    if "%iso%"=="-s" (
		cls
        set "ba=!script! !isoDesmontar! !isoPath!"
        echo Desmontando archivo ISO !isoPath!, espere...
        call !ba!
		cls
		echo Guardando Datos en !vhdPath!, espere...
		timeout /t 2 > nul
        set "bb=!script! !vhddesmontar! !vhdPath!"
        echo Desmontando !vhdPath!, espere...
        call !bb!
        timeout /t 2 > nul
        goto salir
    ) else if "%iso%"=="-n" (
		cls
		echo Guardando Datos en !vhdPath!, espere...
		timeout /t 2 > nul
        set "bc=!script! !vhddesmontar! !vhdPath!"
        echo Desmontando !vhdPath!, espere...
        call !bc!
        timeout /t 2 > nul
		cls
        goto salir
    )
)
:obtenerletra
rem Fratmento del codigo para optener la letra del volumen
for /f "delims=" %%a in ('powershell -Command "foreach ($volume in (Get-Volume)) { if ($volume.FileSystemLabel -eq '%vhdvolumen%') { $volume.DriveLetter } }"') do set "Letra=%%a"
rem Ajusta la letra de la iso tambien.
REM Comprueba si se ha optenido una Letra de unidad asignada al nombre del volumen.
if "%Letra%"=="" (
	Rem Si la letra de unidad es vacia. Seguramente el nombre con el que busca el volumen, no sea el mismo que el nombre del volumen.
	cls
	echo No se a podido econtrar la letra de la unidad.
	echo Se ha buscado el Volumen con 
	echo.
	echo Nombre: *** %vhdvolumen% ***
	echo.
	echo Cambie el nombre del volumen o del archivo VHD 
	echo "El archivo VHD si usa: {InstallDirName} En playnite."
	echo.
	echo Presione Y para Abrir el administrador de Discos o cualquier otra tecla para salir.
	echo.
	choice /c YN /M "Respuesta:"
	cls
    if errorlevel 2 (
        echo Ha elegido salir. El programa se cerrará.
		set "accion=-desmontar"
        goto accionX
    ) else (
        start diskmgmt.msc
        :esperarCierre
		echo Nombre: *** %vhdvolumen% ***
        timeout /t 2 > nul
        tasklist /fi "imagename eq mmc.exe" | findstr /i "mmc.exe" > nul
        if errorlevel 1 (
            rem El proceso mmc.exe no está en ejecución, continuar
			cls
            goto obtenerletra
        ) else (
            rem El proceso mmc.exe sigue en ejecución, esperar
			cls
            goto esperarCierre
        )
    )
)

goto continuar
:obtenerletraX
rem Fratmento del codigo para optener la letra del volumen Explorar
for /f "delims=" %%a in ('powershell -Command "foreach ($volume in (Get-Volume)) { if ($volume.FileSystemLabel -eq '%vhdvolumen%') { $volume.DriveLetter } }"') do set "Letra=%%a"
rem Ajusta la letra de la iso tambien.
REM Comprueba si se ha optenido una Letra de unidad asignada al nombre del volumen.
if "%Letra%"=="" (
	Rem Si la letra de unidad es vacia. Seguramente el nombre con el que busca el volumen, no sea el mismo que el nombre del volumen.
	cls
	echo No se a podido econtrar la letra de la unidad.
	echo Se ha buscado el Volumen con 
	echo Nombre: *** %vhdvolumen% ***
	echo Cambie el nombre del volumen o del archivo. Tienen que ser iguales. Un usar espacios.
	echo "Archivo VHD si usa: {ImageNameNoExt} En playnite."
	echo.
	echo Presione Y para Abrir el administrador de Discos o cualquier otra tecla para salir.
	echo.
	choice /c YN /M "Respuesta:"
	cls
    if errorlevel 2 (
        echo Ha elegido salir. El programa se cerrará.
		set "accion=-desmontar"
        goto accionX
    ) else (
        start diskmgmt.msc
        :esperarCierreX
		echo Nombre: *** %vhdvolumen% ***
        timeout /t 2 > nul
        tasklist /fi "imagename eq mmc.exe" | findstr /i "mmc.exe" > nul
        if errorlevel 1 (
			cls
            rem El proceso mmc.exe no está en ejecución, continuar
            goto obtenerletraX
        ) else (
			cls
            rem El proceso mmc.exe sigue en ejecución, esperar
            goto esperarCierreX
        )
    )
)
goto continuarX
:salir
echo Saliendo...
timeout /t 2 > nul
exit
