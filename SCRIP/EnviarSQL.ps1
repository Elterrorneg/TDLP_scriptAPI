function Show-LoginWindow {
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

    # Crear formulario principal
    $form = New-Object Windows.Forms.Form
    $form.Text = "Configuración de conexión SQL Server"
    $form.Width = 350
    $form.Height = 150

    # Crear etiqueta y caja de texto para ingresar el nombre del servidor SQL Server
    $labelServerName = New-Object Windows.Forms.Label
    $labelServerName.Text = "Nombre del servidor SQL Server:"
    $labelServerName.Top = 20
    $labelServerName.Left = 10
    $labelServerName.AutoSize = $true
    $form.Controls.Add($labelServerName)

    $textBoxServerName = New-Object Windows.Forms.TextBox
    $textBoxServerName.Top = 20
    $textBoxServerName.Left = 180
    $textBoxServerName.Width = 150
    $form.Controls.Add($textBoxServerName)

    # Botón para conectar al servidor SQL Server ingresado
    $buttonConnect = New-Object Windows.Forms.Button
    $buttonConnect.Text = "Conectar"
    $buttonConnect.Top = 60
    $buttonConnect.Left = 120
    $buttonConnect.Width = 100
    $buttonConnect.Add_Click({
        # Obtener el nombre del servidor ingresado por el usuario
        $serverName = $textBoxServerName.Text

        # Cerrar el formulario de configuración
        $form.Close()

        # Mostrar el formulario de login con el servidor SQL Server seleccionado
        Show-LoginForm -ServerName $serverName
    })
    $form.Controls.Add($buttonConnect)

    # Mostrar el formulario de configuración
    $form.ShowDialog()
}

# Función para mostrar la ventana de login con el servidor SQL Server seleccionado
function Show-LoginForm {
    param (
        [string]$ServerName
    )

    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

    # Crear formulario de login
    $loginForm = New-Object Windows.Forms.Form
    $loginForm.Text = "Login"
    $loginForm.Width = 300
    $loginForm.Height = 200

    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Width = $loginForm.Width
    $tabControl.Height = $loginForm.Height
    $loginForm.Controls.Add($tabControl)

    $loginTab = New-Object System.Windows.Forms.TabPage
    $loginTab.Text = "Login"
    $tabControl.TabPages.Add($loginTab)

    $registerTab = New-Object System.Windows.Forms.TabPage
    $registerTab.Text = "Register"
    $tabControl.TabPages.Add($registerTab)

    $labelUser = New-Object Windows.Forms.Label
    $labelUser.Text = "Usuario"
    $labelUser.Top = 20
    $labelUser.Left = 10
    $labelUser.AutoSize = $true
    $loginTab.Controls.Add($labelUser)

    $textUser = New-Object Windows.Forms.TextBox
    $textUser.Top = 20
    $textUser.Left = 80
    $textUser.Width = 150
    $loginTab.Controls.Add($textUser)

    $labelPassword = New-Object Windows.Forms.Label
    $labelPassword.Text = "Contraseña"
    $labelPassword.Top = 60
    $labelPassword.Left = 10
    $labelPassword.AutoSize = $true
    $loginTab.Controls.Add($labelPassword)

    $textPassword = New-Object Windows.Forms.TextBox
    $textPassword.Top = 60
    $textPassword.Left = 80
    $textPassword.Width = 150
    $textPassword.PasswordChar = '*'
    $loginTab.Controls.Add($textPassword)

    $buttonSubmit = New-Object Windows.Forms.Button
    $buttonSubmit.Text = "Enviar"
    $buttonSubmit.Top = 100
    $buttonSubmit.Left = 30
    $buttonSubmit.Width = 80
    $loginTab.Controls.Add($buttonSubmit)

    $buttonRegister = New-Object Windows.Forms.Button
    $buttonRegister.Text = "Registrar"
    $buttonRegister.Top = 100
    $buttonRegister.Left = 140
    $buttonRegister.Width = 80
    $loginTab.Controls.Add($buttonRegister)

    $labelUserRegister = New-Object Windows.Forms.Label
    $labelUserRegister.Text = "Usuario"
    $labelUserRegister.Top = 20
    $labelUserRegister.Left = 10
    $labelUserRegister.AutoSize = $true
    $registerTab.Controls.Add($labelUserRegister)

    $textUserRegister = New-Object Windows.Forms.TextBox
    $textUserRegister.Top = 20
    $textUserRegister.Left = 80
    $textUserRegister.Width = 150
    $registerTab.Controls.Add($textUserRegister)

    $labelPasswordRegister = New-Object Windows.Forms.Label
    $labelPasswordRegister.Text = "Contraseña"
    $labelPasswordRegister.Top = 60
    $labelPasswordRegister.Left = 10
    $labelPasswordRegister.AutoSize = $true
    $registerTab.Controls.Add($labelPasswordRegister)

    $textPasswordRegister = New-Object Windows.Forms.TextBox
    $textPasswordRegister.Top = 60
    $textPasswordRegister.Left = 80
    $textPasswordRegister.Width = 150
    $textPasswordRegister.PasswordChar = '*'
    $registerTab.Controls.Add($textPasswordRegister)

    $buttonSubmitRegister = New-Object Windows.Forms.Button
    $buttonSubmitRegister.Text = "Registrar"
    $buttonSubmitRegister.Top = 100
    $buttonSubmitRegister.Left = 30
    $buttonSubmitRegister.Width = 80
    $registerTab.Controls.Add($buttonSubmitRegister)

    $buttonCancelar = New-Object Windows.Forms.Button
    $buttonCancelar.Text = "Cancelar"
    $buttonCancelar.Top = 100
    $buttonCancelar.Left = 140
    $buttonCancelar.Width = 80
    $registerTab.Controls.Add($buttonCancelar)

    # Mostrar mensaje de error
    function Show-ErrorMessage {
        param (
            [string]$message
        )
        
        $errorForm = New-Object Windows.Forms.Form
        $errorForm.Text = "Error"
        $errorForm.Width = 250
        $errorForm.Height = 150

        $labelError = New-Object Windows.Forms.Label
        $labelError.Text = $message
        $labelError.Top = 20
        $labelError.Left = 20
        $labelError.AutoSize = $true
        $errorForm.Controls.Add($labelError)

        $buttonClose = New-Object Windows.Forms.Button
        $buttonClose.Text = "Cerrar"
        $buttonClose.Top = 60
        $buttonClose.Left = 80
        $buttonClose.Width = 80
        $buttonClose.Add_Click({
            $errorForm.Close()
        })
        $errorForm.Controls.Add($buttonClose)

        $errorForm.ShowDialog()
    }

    $buttonSubmit.Add_Click({
        $usuario = $textUser.Text
        $password = $textPassword.Text
        $loginForm.Close()
        Main -usuario $usuario -password $password -serverName $ServerName
    })

    $buttonRegister.Add_Click({
        foreach ($control in $loginTab.Controls) {
            if ($control -is [System.Windows.Forms.TextBox]) {
                $control.Visible = $false
            }
        }
        foreach ($control in $registerTab.Controls) {
            if ($control -is [System.Windows.Forms.TextBox]) {
                $control.Visible = $true
            }
        }
        $tabControl.SelectedIndex = 1
    })

    $buttonCancelar.Add_Click({
        foreach ($control in $registerTab.Controls) {
            if ($control -is [System.Windows.Forms.TextBox]) {
                $control.Visible = $false
            }
        }
        foreach ($control in $loginTab.Controls) {
            if ($control -is [System.Windows.Forms.TextBox]) {
                $control.Visible = $true
            }
        }
        $tabControl.SelectedIndex = 0
    })

    $buttonSubmitRegister.Add_Click({
        $usuario = $textUserRegister.Text
        $password = $textPasswordRegister.Text

        $urlUsuario = "http://brandomedina.pythonanywhere.com/api_registrarusuario"

        # Datos de registro
        $authBody = @{
            "usuario" = $usuario
            "pass" = $password
        } | ConvertTo-Json

        Write-Output "Cuerpo de la solicitud de registro: $authBody"

        # Encabezados para la solicitud de registro
        $authHeaders = @{
            "Content-Type" = "application/json"
        }
        
        try {
            $responseApi = Invoke-RestMethod -Uri $urlUsuario -Headers $authHeaders -Method Post -Body $authBody -ContentType "application/json; charset=utf-8"
            Write-Output "Respuesta de la API: $responseApi"
            if ($responseApi.code -eq 1) {
                [System.Windows.Forms.MessageBox]::Show("Usuario registrado correctamente")
                $loginForm.Close()
            } elseif ($responseApi.message -eq 'Usuario ya existe') {
                Show-ErrorMessage -message "Usuario ya existe"
            } else {
                Show-ErrorMessage -message "Error al registrar usuario: $($responseApi.message)"
            }
        } catch {
            Write-Output "Error al enviar usuarios: $_"
            $errorContent = $_.Exception.Response.Content
            Write-Output "Detalles del error: $errorContent"
            Show-ErrorMessage -message "Error al enviar usuarios"
        }
    })

    # Mostrar el formulario de login
    $loginForm.ShowDialog()
}

function Main {
    param (
        [string]$usuario,
        [string]$password,
        [string]$serverName
    )

    Write-Output "Iniciando autenticación para el usuario: $usuario"

    # Obtener el nombre de la PC
    $nombrePC = [System.Environment]::MachineName

    Write-Output "Nombre de la PC: $nombrePC"

    # URL para autenticar y obtener el token
    $urlAuth = "http://brandomedina.pythonanywhere.com/auth"

    # URL para enviar los eventos SQL Server
    $urlEventoSQLServer = "http://brandomedina.pythonanywhere.com/api_registrarsqlserver"

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

        # Crear la conexión a SQL Server
        $database = "master"
        $connectionString = "Server=$serverName;Database=$database;Integrated Security=True;"
        $query = "EXEC xp_readerrorlog"

        try {
            $connection = New-Object System.Data.SqlClient.SqlConnection
            $connection.ConnectionString = $connectionString
            $connection.Open()

            $command = $connection.CreateCommand()
            $command.CommandText = $query

            $reader = $command.ExecuteReader()
            $dataTable = New-Object System.Data.DataTable
            $dataTable.Load($reader)

            $events = @()
            
            foreach ($row in $dataTable.Rows) {
                $events += [PSCustomObject]@{
                    date = $row["LogDate"]
                    source = $row["ProcessInfo"]
                    message = ($row["Text"] -split ' ')[0..1] -join ' '
                    log_type = "SQL Server"
                    log_source = "Current - " + $row["LogDate"]
                    nombre_pc = $nombrePC
                }
            }

            $jsonBody = $events | ConvertTo-Json -Depth 5

            Write-Output "Eventos a enviar: $jsonBody"

            try {
                $response = Invoke-RestMethod -Uri $urlEventoSQLServer -Headers $headers -Method Post -Body $jsonBody -ContentType "application/json; charset=utf-8"
                Write-Output "Respuesta de la API: $response"
                [System.Windows.Forms.MessageBox]::Show("Datos enviados correctamente")
            } catch {
                Write-Output "Error al enviar datos: $_"
                [System.Windows.Forms.MessageBox]::Show("Error al enviar datos")
            }
        } catch {
            Write-Output "Error al conectar con SQL Server: $_"
            [System.Windows.Forms.MessageBox]::Show("Error al conectar con SQL Server")
        }
    } else {
        Write-Output "No se pudo obtener el token de autenticación."
        [System.Windows.Forms.MessageBox]::Show("Error de autenticación")
    }
}

# Mostrar ventana de configuración de conexión al inicio
Show-LoginWindow
