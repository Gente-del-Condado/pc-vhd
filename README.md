# PC-VHD

**Descripción:**

La función pc-vhd permite detectar juegos de PC como ROMs a través de archivos VHD o VHDX, pudiendo montar automáticamente archivos VHD, VHDX e ISO. Diseñado principalmente para su uso en Playnite, se utiliza como un emulador.
1. pc-vhd.bat: Es usado como intermediario, entre playnite y el scrip pc-vhdx.ps1 (usando powershell)
2. pc-vhdx.ps1: Es uso para montar y desmontar los archivos. vhd, vhdx y iso.
3. VhdAttach.bat: Scrip, para montar unsando el programa VhdAttach = https://github.com/medo64/VhdAttach (se necesita tener instalado VhdAttach)

**Instrucciones de Uso:**
1. Colocar el contenido en: Playnite\Emulation\Emulators\PC-VHD (pc-vhd.bat y pc-vhdx.ps1)
2. Asegúrese de tener el script pc-vhdx.ps1 en la misma carpeta que el archivo pc-vhd.bat ("emulador") o pc-vhd.exe.
3. Los discos virtuales en formatos VHD y VHDX deben estar en formato NTFS.
4. La carpeta que contiene el VHD, el nombre del archivo y el nombre del volumen deben ser idénticos, sin acentos ni símbolos. Para espacios, utilice guiones bajos ( _ ).

**Requisitos:**

5. El directorio de instalación en Playnite debe ser la carpeta que contiene el archivo VHD o VHDX. (No es necesario para el "emulador").

6. Si el juego requiere el uso de una ISO, esta debe estar ubicada dentro del VHD/X en la siguiente ruta y con el nombre VHD:\ISO\ISO.iso.

**Uso del Archivo pc-vhd.bat / pc-vhd.exe:**

El archivo pc-vhd.bat se utiliza de la siguiente manera:

- **Primer Parámetro:** Uno de estos 3 (-montar, -desmontar, -explorar).
- **Segundo Parámetro:** Ruta del archivo VHD. En Playnite, use {ImagePath} (agregue el archivo VHD/VHDX como ROM en el juego en Playnite).
- **Tercer Parámetro:** Mismo nombre del volumen que tiene el VHD cuando está montado. En Playnite, use: {ImageNameNoExt} (usa el nombre del archivo VHD/X).
- **Cuarto Parámetro:** Indica si cargará la ISO dentro del VHD-VHDX \ISO\ISO.iso. Use (-s) para sí, (-n) para no.

**Parámetros Adicionales Opcionales:**

- **Quinto Parámetro:** Ejecuta el archivo indicado cuando se utiliza -montar. Use el nombre del archivo con la extensión (Ejemplo: Jugar.exe \Datos\Programa.exe).
- **Sexto Parámetro:** Ruta de trabajo del ejecutable. Use -p (directorio principal del VHD) \Datos\ para indicar la carpeta de trabajo del ejecutable.
- **Sextimo Parámetro:** Son los parametros que se le pueden pasar a los exe de los juegos. (Depende de cada juego *.exe)

*Ejemplos:*

- En Playnite:
  - Básico con ISO: `pc-vhd.bat -montar {ImagePath} {ImageNameNoExt} -s Jugar.bat`
  - Con carpeta de trabajo principal: `pc-vhd.bat -montar {ImagePath} {ImageNameNoExt} -n Jugar.bat -p -noclip`
  - Con otra carpeta de trabajo: `pc-vhd.bat -montar {ImagePath} {ImageNameNoExt} -n Jugar.bat Datos\ -noclip`

- Acceso Directo:
  - `pc-vhd.bat -montar W:\Playnite\Juegos\Mario\Mario.vhd Mario -n Jugar.bat -p -noclip`
  - `pc-vhd.bat -montar W:\Playnite\Juegos\Mario\Mario.vhd Mario -s Jugar.bat \Datos\ -noclip`

**Notas:**

- Se puede usar VHD Attach, el programa, para crear los archivos de discos virtuales.
- Formato recomendado: VHDX (Windows 8.1+).
- Al crear el disco virtual, añadir al menos 250 MB adicionales al tamaño del juego.
- Para juegos antiguos que guardan saves en el mismo directorio, agregar 50 MB extras.
