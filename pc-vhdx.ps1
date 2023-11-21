param (
    [string]$action,
    [string]$parameter,
    [string]$filePath
)
# Al MONTAR Función para detectar si es ISO o vhd, vhdx.
function Attach-Image {
    param (
        [string]$filePath
    )

    # Extraer la extensión del archivo y convertir en minuscula.
	$fileExtension = [System.IO.Path]::GetExtension($filePath).ToLower()
    
    if ($fileExtension -eq ".vhd" -or $fileExtension -eq ".vhdx") {
    	# Si la extensión de los archivos son vhd o vhdx.
        Attach-VHD -filePath $filePath
    }
    elseif ($fileExtension -eq ".iso") {
    	# Si la extensión de los archivos son ISO
        Attach-ISO -filePath $filePath
    }
    else {
        Write-Host "Error: Extensión de archivo no admitida."
    }
}
# Al DESMONTAR Función para detectar si es ISO o vhd, vhdx.
function Detach-Image {
    param (
        [string]$filePath
    )

    # Extraer la extensión del archivo y convertir en minuscula.
    $fileExtension = [System.IO.Path]::GetExtension($filePath).ToLower()

    if ($fileExtension -eq ".vhd" -or $fileExtension -eq ".vhdx") {
    	# Si la extensión de los archivos son vhd o vhdx.
        Detach-VHD -filePath $filePath
    }
    elseif ($fileExtension -eq ".iso") {
    	# Si la extensión de los archivos son ISO
        Detach-ISO -filePath $filePath
    }
    else {
        Write-Host "Error: Extensión de archivo no admitida."
    }
}
# Función para montar VHX o VHDX.
function Attach-VHD {
    param (
        [string]$filePath
    )

    # Extraer el nombre del archivo (sin la extensión) de la ruta
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($filePath)

    # Montar la imagen del disco y esperar un momento para asegurarse de que Windows reconozca el disco
    Mount-DiskImage -ImagePath $filePath -PassThru | Out-Null
    Start-Sleep -Seconds 2

    # Obtener el volumen asociado al nombre del archivo
    $volume = Get-Volume -FileSystemLabel $fileName

    if ($volume) {
        $driveLetter = $volume.DriveLetter
        Write-Host "Montando VHD/VHDX '$fileName' en la unidad: $driveLetter"
    } else {
        Write-Host "Error: No se pudo encontrar la letra del VHD/VHDX."
    }
}
# Función para Desmontar VHX o VHDX.
function Detach-VHD {
    param (
        [string]$filePath
    )

    # Extraer el nombre del archivo (sin la extensión) de la ruta
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($filePath)

    # Obtener el volumen asociado al nombre del archivo
    $volume = Get-Volume -FileSystemLabel $fileName

    if ($volume) {
        $driveLetter = $volume.DriveLetter
        Write-Host "Desmontando VHD/VHDX '$fileName' de unidad: $driveLetter"
        Dismount-DiskImage -ImagePath $filePath | Out-Null
    } else {
        Write-Host "Error: No se pudo encontrar la letra del VHD/VHDX."
    }
}
# Función para montar ISO.
function Attach-ISO {
    param (
        [string]$filePath
    )

    # Montar la imagen ISO y esperar un momento para asegurarse de que Windows reconozca el disco
    Mount-DiskImage -ImagePath $filePath -PassThru | Out-Null
    Start-Sleep -Seconds 2

    # Obtener información sobre las unidades de CD/DVD usando WMI
    $cdDrive = Get-WmiObject -Query "SELECT * FROM Win32_CDROMDrive" | Select-Object -First 1

    if ($cdDrive) {
        $driveLetter = $cdDrive.Drive
        Write-Host "ISO montada en: $driveLetter"
    } else {
        Write-Host "Error: No se pudo encontrar la letra de unidad del ISO."
    }
}
# Función para desmontar ISO.
function Detach-ISO {
    param (
        [string]$filePath
    )

    # Desmontar la imagen ISO y esperar un momento para asegurarse de que Windows la haya desmontado
    Dismount-DiskImage -ImagePath $filePath | Out-Null
    Start-Sleep -Seconds 2

    Write-Host "ISO desmontada: $filePath"
}

if ($action -eq "/attach") {
    Attach-Image -filePath $filePath
}
elseif ($action -eq "/detach") {
    Detach-Image -filePath $filePath
}
else {
    Write-Host "Acción no reconocida. Use /attach o /detach."
}
