# pc-vhd
Función para detectar juegos de pc como roms, por medio de archivos vhd o vhdx. Puede montar automáticamente archivos vhd, vhdx y iso. El uso principal es en playnite.  Se usa como si fuera un emulador.


---------------
Para poder usar el archivo pc-vhd.bat (“emulador”) / pc-vhd.exe
0º necesita tener el scrip. pc-vhdx.ps1 en la misma carpeta.
1º Los formatos de los Discos virtuales, VHD,VHDX tienen que ser en formatos NTFS
2º El nombre de la CARPETA que contiene el VHD, el nombre del archivo y el Nombre del VOLUMEN del disco tienen que ser Exactamente Iguales. No usar acentos ni símbolos. Para espacios poner ( _ ).

4º El directorio de instalación en Playnite Tiene que ser la carpeta donde se encuentra el archivo VHD,VHDX. (NO NECESARIO PARA El “emulador”

5º Si el Juego Requiere usar una ISO, esta tiene que estar dentro del VHD/X en la siguiente Ubicación y nombre VHD:\ISO\ISO.iso

El bat Funciona de la siguiente Manera.

El Primer Parámetro. Tiene que ser uno de estos 3 (-montar -desmontar -explorar)

El Segundo Parámetro. Tiene que ser la Ruta del archivo VHD. Si lo usas en playnite. usar {ImagePath} (tiene que agregar el archivo VHD/VHDX como ROM en el juego en playnite)

El Tercer Parámetro. Tiene que ser El Mismo Nombre del Volumen que tiene el VHD cuando esta montado. En playnite usar: {ImageNameNoExt} ((USA EL NOMBRE DEL ROM-ARCHIVO VHD/X))

El Cuarto Parámetro. Es para decir si cargara la ISO que esta dentro del VHD-VHDX \ISO\ISO.iso. Usa (-s) Para si (-n) Para No
----
El Quinto parámetro es Opcional. Pero es para ejecutar el archivo Indicado, cuando se usa -montar. Usar el nombre del archivo con la extensión: Jugar.exe \Datos\Programa.exe

El Sexto parámetro, es para indicar la ruta de trabajo del ejecutable: -p (directorio Principal del VHD) \Datos\ (para indicar que trabaje el ejecutable en la carpeta \Datos\)
	El sexto parámetro puede estar vació si no se van a agregar mas, si deseas agregar un parámetro al ejecutable del juego Es OBLIGATORIO poner -p 'o' CarpetaTrabajo\

El Séptimo Parámetro, a partir del séptimo parámetro, y todos los siguientes, serán pasados al ejecutable del Juego.

Ejemplos:
	En playnite
El mas básico, cuando no se requiere indicar una carpeta de trabajo ni pasar ningún parámetro. Por defecto usa la carpeta de trabajo principal del VHD:\
W:\Playnite\Emulation\Emulators\PC-VHD\pc-vhd.bat -montar {ImagePath} {ImageNameNoExt} -s Jugar.bat

Ejecuta el Archivo Jugar.bat en el directorio principal VHD:\ (-P)  y le pasa el parametro -noclip (al ejecutable Jugar.bat)
W:\Playnite\Emulation\Emulators\PC-VHD\pc-vhd.bat -montar {ImagePath} {ImageNameNoExt} -s Jugar.bat -p -noclip

Ejecuta el Archivo Jugar.bat en el directorio principal H:\Datos\ (Datos\)  y le pasa el parámetro -noclip (al ejecutable Jugar.bat)
W:\Playnite\Emulation\Emulators\PC-VHD\pc-vhd.bat -montar {ImagePath} {ImageNameNoExt} -s Jugar.bat Datos\ -noclip


En un Acceso Directo al archivo  pc-vhd.bat

W:\Playnite\Emulation\Emulators\PC-VHD\pc-vhd.bat -montar W:\Playnite\Juegos\Mario\Mario.vhd Mario -s Jugar.bat -p -noclip
		
W:\Playnite\Emulation\Emulators\PC-VHD\pc-vhd.bat -montar W:\Playnite\Juegos\Mario\Mario .vhd Mario -s Jugar.bat \Datos\ -noclip

*NOTAS*
Puede usar VHD Attacht el programa, para crear los archivos de discos virtuales.
	Formato recomendable: VHDX (windows 8.1+)
	Al crear el disco virtual, agregar unos minimo 250mb mas al tamaño del juego.
	Si el juego, para juegos antiguos, que guardan los save en el mismo directorio, del juego
		agregar otros 50mb extras.
	
