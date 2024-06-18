function Show-LoginWindow {
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

    $form = New-Object Windows.Forms.Form
    $form.Text = "Login"
    $form.Width = 300
    $form.Height = 200

    $labelUser = New-Object Windows.Forms.Label
    $labelUser.Text = "Usuario"
    $labelUser.Top = 20
    $labelUser.Left = 10
    $labelUser.AutoSize = $true
    $form.Controls.Add($labelUser)

    $textUser = New-Object Windows.Forms.TextBox
    $textUser.Top = 20
    $textUser.Left = 80
    $textUser.Width = 150
    $form.Controls.Add($textUser)

    $labelPassword = New-Object Windows.Forms.Label
    $labelPassword.Text = "Contraseña"
    $labelPassword.Top = 60
    $labelPassword.Left = 10
    $labelPassword.AutoSize = $true
    $form.Controls.Add($labelPassword)

    $textPassword = New-Object Windows.Forms.TextBox
    $textPassword.Top = 60
    $textPassword.Left = 80
    $textPassword.Width = 150
    $textPassword.PasswordChar = '*'
    $form.Controls.Add($textPassword)

    $buttonSubmit = New-Object Windows.Forms.Button
    $buttonSubmit.Text = "Enviar"
    $buttonSubmit.Top = 100
    $buttonSubmit.Left = 80
    $buttonSubmit.Width = 80
    $form.Controls.Add($buttonSubmit)

    $buttonSubmit.Add_Click({
        $usuario = $textUser.Text
        $password = $textPassword.Text
        $form.Close()
        Main -usuario $usuario -password $password
    })

    $form.ShowDialog()
}

function Show-LoginWindow {
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

    $form = New-Object Windows.Forms.Form
    $form.Text = "Login"
    $form.Width = 300
    $form.Height = 200

    $labelUser = New-Object Windows.Forms.Label
    $labelUser.Text = "Usuario"
    $labelUser.Top = 20
    $labelUser.Left = 10
    $labelUser.AutoSize = $true
    $form.Controls.Add($labelUser)

    $textUser = New-Object Windows.Forms.TextBox
    $textUser.Top = 20
    $textUser.Left = 80
    $textUser.Width = 150
    $form.Controls.Add($textUser)

    $labelPassword = New-Object Windows.Forms.Label
    $labelPassword.Text = "Contraseña"
    $labelPassword.Top = 60
    $labelPassword.Left = 10
    $labelPassword.AutoSize = $true
    $form.Controls.Add($labelPassword)

    $textPassword = New-Object Windows.Forms.TextBox
    $textPassword.Top = 60
    $textPassword.Left = 80
    $textPassword.Width = 150
    $textPassword.PasswordChar = '*'
    $form.Controls.Add($textPassword)

    $buttonSubmit = New-Object Windows.Forms.Button
    $buttonSubmit.Text = "Enviar"
    $buttonSubmit.Top = 100
    $buttonSubmit.Left = 30
    $buttonSubmit.Width = 80
    $form.Controls.Add($buttonSubmit)

    $buttonRegister = New-Object Windows.Forms.Button
    $buttonRegister.Text = "Registrar"
    $buttonRegister.Top = 100
    $buttonRegister.Left = 140
    $buttonRegister.Width = 80
    $form.Controls.Add($buttonRegister)

    $buttonSubmit.Add_Click({
        $usuario = $textUser.Text
        $password = $textPassword.Text
        $form.Close()
        Main -usuario $usuario -password $password
    })

    $buttonRegister.Add_Click({
        $form.Close()
        Show-RegisterWindow
    })

    $form.ShowDialog()
}

function Show-RegisterWindow{
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

    $form = New-Object Windows.Forms.Form
    $form.Text = "Register"
    $form.Width = 300
    $form.Height = 200

    $labelUser = New-Object Windows.Forms.Label
    $labelUser.Text = "Usuario"
    $labelUser.Top = 20
    $labelUser.Left = 10
    $labelUser.AutoSize = $true
    $form.Controls.Add($labelUser)

    $textUser = New-Object Windows.Forms.TextBox
    $textUser.Top = 20
    $textUser.Left = 80
    $textUser.Width = 150
    $form.Controls.Add($textUser)

    $labelPassword = New-Object Windows.Forms.Label
    $labelPassword.Text = "Contraseña"
    $labelPassword.Top = 60
    $labelPassword.Left = 10
    $labelPassword.AutoSize = $true
    $form.Controls.Add($labelPassword)

    $textPassword = New-Object Windows.Forms.TextBox
    $textPassword.Top = 60
    $textPassword.Left = 80
    $textPassword.Width = 150
    $textPassword.PasswordChar = '*'
    $form.Controls.Add($textPassword)

    $buttonSubmit = New-Object Windows.Forms.Button
    $buttonSubmit.Text = "Registrar"
    $buttonSubmit.Top = 100
    $buttonSubmit.Left = 30
    $buttonSubmit.Width = 80
    $form.Controls.Add($buttonSubmit)

    $buttonCancelar = New-Object Windows.Forms.Button
    $buttonCancelar.Text = "Cancelar"
    $buttonCancelar.Top = 100
    $buttonCancelar.Left = 140
    $buttonCancelar.Width = 80
    $form.Controls.Add($buttonCancelar)

    $buttonSubmit.Add_Click({
        $usuario = $textUser.Text
        $password = $textPassword.Text
        $form.Close()
        Main -usuario $usuario -password $password
    })

    $buttonCancelar.Add_Click({
        $form.Close()
        Show-LoginWindow
    })
    $form.ShowDialog()
}

function Register {
    param (
        [string]$usuario,
        [string]$password
    )

    # Obtener el nombre de la PC
    $nombrePC = [System.Environment]::MachineName

    Write-Output "Nombre de la PC: $nombrePC"

    # URL para autenticar y obtener el token
    $urlAuth = "http://brandomedina.pythonanywhere.com/auth"

    # URL para enviar los eventos
    $urlEvento = "http://brandomedina.pythonanywhere.com/api_registraraplicacion"

    # Datos de autenticación
    $authBody = @{
        "username" = $usuario
        "password" = $password
    } | ConvertTo-Json

    Write-Output "Cuerpo de la solicitud de autenticación: $authBody"

    # Encabezados para la solicitud de autenticación
    $authHeaders = @{
        "Content-Type" = "application/json"
    }

    # Obtener el token
    try {
        $responseAuth = Invoke-RestMethod -Uri $urlAuth -Headers $authHeaders -Method Post -Body $authBody -ContentType "application/json; charset=utf-8"
        Write-Output "Respuesta de autenticación: $responseAuth"
    } catch {
        Write-Output "Error durante la autenticación: $_"
        [System.Windows.Forms.MessageBox]::Show("Datos incorrectos")
        return
    }

    if ($responseAuth -ne $null -and $responseAuth.access_token -ne $null) {
        $token = $responseAuth.access_token
        Write-Output "Token obtenido: $token"

        # Encabezados para la solicitud de envío de eventos
        $headers = @{
            "Content-Type" = "application/json; charset=utf-8"
            "Authorization" = "JWT $token"
        }

        Write-Output "Encabezados para la solicitud de eventos: $headers"

        # Obtener eventos de aplicación del Visor de eventos
        $events = Get-WinEvent -LogName Application -MaxEvents 20

        # Convertir eventos a JSON
        $jsonBody = $events | ForEach-Object {
            [PSCustomObject]@{
                nivel = $_.LevelDisplayName
                fecha_hora = $_.TimeCreated.ToString("yyyy-MM-ddTHH:mm:ssZ")
                origen = $_.ProviderName
                id_evento = $_.Id
                categoria_tarea = "aplicacion"
                nombre_pc = $nombrePC  # Agregar el nombre de la PC
            }
        } | ConvertTo-Json -Depth 3

        Write-Output "Cuerpo de la solicitud de eventos: $jsonBody"

        # Enviar los datos a la API
        try {
            $responseApi = Invoke-RestMethod -Uri $urlEvento -Headers $headers -Method Post -Body $jsonBody -ContentType "application/json; charset=utf-8"
            Write-Output "Response from API: $responseApi"
            [System.Windows.Forms.MessageBox]::Show("Datos enviados correctamente")
        } catch {
            Write-Output "Error al enviar eventos: $_"
            $errorContent = $_.Exception.Response.Content
            Write-Output "Detalles del error: $errorContent"
            [System.Windows.Forms.MessageBox]::Show("Error al enviar eventos")
        }
    } else {
        Write-Output "Error al obtener el token de autenticación"
    }
}

function Main {
    param (
        [string]$usuario,
        [string]$password
    )

    Write-Output "Iniciando autenticación para el usuario: $usuario"

    # Obtener el nombre de la PC
    $nombrePC = [System.Environment]::MachineName

    Write-Output "Nombre de la PC: $nombrePC"

    # URL para autenticar y obtener el token
    $urlAuth = "http://brandomedina.pythonanywhere.com/auth"

    # URL para enviar los eventos de aplicacion
    $urlEventoAplicacion = "http://brandomedina.pythonanywhere.com/api_registraraplicacion"

     # URL para enviar los eventos de instalación
    $urlEventoInstalacion = "http://brandomedina.pythonanywhere.com/api_registrarinstalacion"

    # URL para enviar los eventos de sistema
    $urlEventoSistema = "http://brandomedina.pythonanywhere.com/api_registrarsistema"

    # URL para enviar los eventos de seguridad
    $urlEventoSeguridad = "http://brandomedina.pythonanywhere.com/api_registrarseguridad"

    # Datos de autenticación
    $authBody = @{
        "username" = $usuario
        "password" = $password
    } | ConvertTo-Json

    Write-Output "Cuerpo de la solicitud de autenticación: $authBody"

    # Encabezados para la solicitud de autenticación
    $authHeaders = @{
        "Content-Type" = "application/json"
    }

    # Obtener el token
    try {
        $responseAuth = Invoke-RestMethod -Uri $urlAuth -Headers $authHeaders -Method Post -Body $authBody -ContentType "application/json; charset=utf-8"
        Write-Output "Respuesta de autenticación: $responseAuth"
    } catch {
        Write-Output "Error durante la autenticación: $_"
        [System.Windows.Forms.MessageBox]::Show("Datos incorrectos")
        return
    }

    if ($responseAuth -ne $null -and $responseAuth.access_token -ne $null) {
        $token = $responseAuth.access_token
        Write-Output "Token obtenido: $token"

        # Encabezados para la solicitud de envío de eventos
        $headers = @{
            "Content-Type" = "application/json; charset=utf-8"
            "Authorization" = "JWT $token"
        }

        Write-Output "Encabezados para la solicitud de eventos: $headers"

        # Obtener eventos de aplicación del Visor de eventos
        $eventsAplicacion = Get-WinEvent -LogName Application -MaxEvents 20

        # Convertir eventos a JSON
        $jsonBodyAplicacion = $eventsAplicacion | ForEach-Object {
            [PSCustomObject]@{
                nivel = $_.LevelDisplayName
                fecha_hora = $_.TimeCreated.ToString("yyyy-MM-ddTHH:mm:ssZ")
                origen = $_.ProviderName
                id_evento = $_.Id
                categoria_tarea = "aplicacion"
                nombre_pc = $nombrePC  # Agregar el nombre de la PC
            }
        } | ConvertTo-Json -Depth 3

        Write-Output "Cuerpo de la solicitud de eventos (aplicación): $jsonBodyAplicacion"

        # Enviar los datos a la API aplicacion
        try {
            $responseApi = Invoke-RestMethod -Uri $urlEventoAplicacion -Headers $headers -Method Post -Body $jsonBodyAplicacion -ContentType "application/json; charset=utf-8"
            Write-Output "Response from API (aplicación): $responseApi"
            [System.Windows.Forms.MessageBox]::Show("Datos aplicacion enviados correctamente")
        } catch {
            Write-Output "Error al enviar eventos: $_"
            $errorContent = $_.Exception.Response.Content
            Write-Output "Detalles del error: $errorContent"
            [System.Windows.Forms.MessageBox]::Show("Error al enviar eventos aplicacion")
        }
        
        # Obtener eventos de instalación del Visor de eventos
        $eventsInstalacion = Get-WinEvent -LogName Setup -MaxEvents 20

        # Obtener eventos de instalación del Visor de eventos
        $jsonBodyInstalacion = $eventsInstalacion | ForEach-Object {
            [PSCustomObject]@{
                nivel = $_.LevelDisplayName
                fecha_hora = $_.TimeCreated.ToString("yyyy-MM-ddTHH:mm:ssZ")
                origen = $_.ProviderName
                id_evento = $_.Id
                categoria_tarea = "instalacion"
                nombre_pc = $nombrePC  # Agregar el nombre de la PC
            }
        } | ConvertTo-Json -Depth 3

        Write-Output "Cuerpo de la solicitud de eventos (instalación): $jsonBodyInstalacion"

        # Enviar los datos de instalación a la API
        try {
            $responseApi = Invoke-RestMethod -Uri $urlEventoInstalacion -Headers $headers -Method Post -Body $jsonBodyInstalacion -ContentType "application/json; charset=utf-8"
            Write-Output "Respuesta de la API (instalación): $responseApi"
            [System.Windows.Forms.MessageBox]::Show("Datos de instalación enviados correctamente")
        } catch {
            Write-Output "Error al enviar eventos de instalación: $_"
            $errorContent = $_.Exception.Response.Content
            Write-Output "Detalles del error: $errorContent"
            [System.Windows.Forms.MessageBox]::Show("Error al enviar eventos de instalación")
        }

        # Obtener eventos de sistema del Visor de eventos
        $eventsSistema = Get-WinEvent -LogName System -MaxEvents 20

        # Convertir eventos de sistema a JSON
        $jsonBodySistema = $eventsSistema | ForEach-Object {
            [PSCustomObject]@{
                nivel = $_.LevelDisplayName
                fecha_hora = $_.TimeCreated.ToString("yyyy-MM-ddTHH:mm:ssZ")
                origen = $_.ProviderName
                id_evento = $_.Id
                categoria_tarea = "sistema"
                nombre_pc = $nombrePC  # Agregar el nombre de la PC
            }
        } | ConvertTo-Json -Depth 3

        Write-Output "Cuerpo de la solicitud de eventos (sistema): $jsonBodySistema"

        # Enviar los datos de sistema a la API
        try {
            $responseApi = Invoke-RestMethod -Uri $urlEventoSistema -Headers $headers -Method Post -Body $jsonBodySistema -ContentType "application/json; charset=utf-8"
            Write-Output "Respuesta de la API (sistema): $responseApi"
            [System.Windows.Forms.MessageBox]::Show("Datos de sistema enviados correctamente")
        } catch {
            Write-Output "Error al enviar eventos de sistema: $_"
            $errorContent = $_.Exception.Response.Content
            Write-Output "Detalles del error: $errorContent"
            [System.Windows.Forms.MessageBox]::Show("Error al enviar eventos de sistema")
        }

        # Obtener eventos de seguridad del Visor de eventos
        $eventsSeguridad = Get-WinEvent -LogName Security -MaxEvents 20

        # Convertir eventos a JSON
        $jsonBodySeguridad = $eventsSeguridad | ForEach-Object {
            [PSCustomObject]@{
                palabras_clave = $_.Message
                fecha_hora = $_.TimeCreated.ToString("yyyy-MM-ddTHH:mm:ssZ")
                origen = $_.ProviderName
                id_evento = $_.Id
                categoria_tarea = "seguridad"
                nombre_pc = $nombrePC
            }
        } | ConvertTo-Json -Depth 3

        Write-Output "Cuerpo de la solicitud de eventos: $jsonBodySeguridad"

        # Enviar los datos a la API seguridad
        try {
            $responseApi = Invoke-RestMethod -Uri $urlEventoSeguridad -Headers $headers -Method Post -Body $jsonBodySeguridad -ContentType "application/json; charset=utf-8"
            Write-Output "Response from API: $responseApi"
            [System.Windows.Forms.MessageBox]::Show("Datos seguridad enviados correctamente")
        } catch {
            Write-Output "Error al enviar eventos: $_"
            $errorContent = $_.Exception.Response.Content
            Write-Output "Detalles del error: $errorContent"
            [System.Windows.Forms.MessageBox]::Show("Error al enviar eventos")
        }

    } else {
        Write-Output "Error al obtener el token de autenticación"
    }
}

Show-LoginWindow
