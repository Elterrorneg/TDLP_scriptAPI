# Cargar el ensamblado de WPF
function Show-LoginWindow {
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

    $form = New-Object Windows.Forms.Form
    $form.Text = "Login"
    $form.Width = 300
    $form.Height = 200

    $tabControl = New-Object System.Windows.Forms.TabControl
    $tabControl.Width = $form.Width
    $tabControl.Height = $form.Height
    $form.Controls.Add($tabControl)

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

    $buttonSubmit.Add_Click({
        $usuario = $textUser.Text
        $password = $textPassword.Text
        $form.Close()
        Main -usuario $usuario -password $password
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
        $form.Close()
        Register -usuario $usuario -password $password
    })

    $form.ShowDialog()
}

function Register {
    param (
        [string]$usuario,
        [string]$password
    )

    $urlUsuario = "http://brandomedina.pythonanywhere.com/api_registrarusuario"

    # Datos de autenticación
    $authBody = @{
        "usuario" = $usuario
        "pass" = $password
    } | ConvertTo-Json

    Write-Output "Cuerpo de la solicitud de autenticacion: $authBody"

    # Encabezados para la solicitud de autenticación
    $authHeaders = @{
        "Content-Type" = "application/json"
    }
    try {
        $responseApi = Invoke-RestMethod -Uri $urlUsuario -Headers $authHeaders -Method Post -Body $authBody -ContentType "application/json; charset=utf-8"
        Write-Output "Response from API: $responseApi"
        [System.Windows.Forms.MessageBox]::Show("Datos enviados correctamente")
    } catch {
        Write-Output "Error al enviar usuarios: $_"
        $errorContent = $_.Exception.Response.Content
        Write-Output "Detalles del error: $errorContent"
        [System.Windows.Forms.MessageBox]::Show("Error al enviar usuarios")
    }
}

function Aplicacion{

    param (
        [hashtable]$headers,
        [string]$nombrePC
    )

    $eventsAplicacion = Get-WinEvent -LogName Application -MaxEvents 20

    # URL para enviar los eventos de aplicacion
    $urlEventoAplicacion = "http://brandomedina.pythonanywhere.com/api_registraraplicacion"
    # Convertir eventos a JSON
    $jsonBodyAplicacion = $eventsAplicacion | ForEach-Object {
        [PSCustomObject]@{
            nivel = $_.LevelDisplayName
            fecha_hora = $_.TimeCreated.ToString("yyyy-MM-ddTHH:mm:ssZ")
            origen = $_.ProviderName
            id_evento = $_.Id
            categoria_tarea = $_.Task
            nombre_pc = $nombrePC  # Agregar el nombre de la PC
        }
    } | ConvertTo-Json -Depth 3

    Write-Output "Cuerpo de la solicitud de eventos (aplicacion): $jsonBodyAplicacion"

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
}
function Instalacion{

    param (
        [hashtable]$headers,
        [string]$nombrePC
    )

     # URL para enviar los eventos de instalación
    $urlEventoInstalacion = "http://brandomedina.pythonanywhere.com/api_registrarinstalacion"

    $eventsInstalacion = Get-WinEvent -LogName Setup -MaxEvents 20

        # Obtener eventos de instalación del Visor de eventos
        $jsonBodyInstalacion = $eventsInstalacion | ForEach-Object {
            [PSCustomObject]@{
                nivel = $_.LevelDisplayName
                fecha_hora = $_.TimeCreated.ToString("yyyy-MM-ddTHH:mm:ssZ")
                origen = $_.ProviderName
                id_evento = $_.Id
                categoria_tarea = $_.Task
                nombre_pc = $nombrePC  # Agregar el nombre de la PC
            }
        } | ConvertTo-Json -Depth 3

        Write-Output "Cuerpo de la solicitud de eventos (instalacion): $jsonBodyInstalacion"

        # Enviar los datos de instalación a la API
        try {
            $responseApi = Invoke-RestMethod -Uri $urlEventoInstalacion -Headers $headers -Method Post -Body $jsonBodyInstalacion -ContentType "application/json; charset=utf-8"
            Write-Output "Respuesta de la API (instalación): $responseApi"
            [System.Windows.Forms.MessageBox]::Show("Datos de instalacion enviados correctamente")
        } catch {
            Write-Output "Error al enviar eventos de instalacion: $_"
            $errorContent = $_.Exception.Response.Content
            Write-Output "Detalles del error: $errorContent"
            [System.Windows.Forms.MessageBox]::Show("Error al enviar eventos de instalacion")
        }
}
function Sistema{

    param (
        [hashtable]$headers,
        [string]$nombrePC
    )

    # URL para enviar los eventos de sistema
    $urlEventoSistema = "http://brandomedina.pythonanywhere.com/api_registrarsistema"

    $eventsSistema = Get-WinEvent -LogName System -MaxEvents 20

    # Convertir eventos de sistema a JSON
    $jsonBodySistema = $eventsSistema | ForEach-Object {
        [PSCustomObject]@{
            nivel = $_.LevelDisplayName
            fecha_hora = $_.TimeCreated.ToString("yyyy-MM-ddTHH:mm:ssZ")
            origen = $_.ProviderName
            id_evento = $_.Id
            categoria_tarea = $_.Task
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
}
function Seguridad{

    param (
        [hashtable]$headers,
        [string]$nombrePC
    )
    
    # URL para enviar los eventos de seguridad
    $urlEventoSeguridad = "http://brandomedina.pythonanywhere.com/api_registrarseguridad"

    $eventsSeguridad = Get-WinEvent -LogName Security -MaxEvents 20

    # Convertir eventos a JSON
    $jsonBodySeguridad = $eventsSeguridad | ForEach-Object {
        [PSCustomObject]@{
            palabras_clave = $_.KeywordsDisplayNames -join ", "
            fecha_hora = $_.TimeCreated.ToString("yyyy-MM-ddTHH:mm:ssZ")
            origen = $_.ProviderName
            id_evento = $_.Id
            categoria_tarea = $_.Task
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
}
function SqlServer{

    param (
        [hashtable]$headers,
        [string]$nombrePC
    )

    # URL para enviar los eventos SQL Server
    $urlEventoSQLServer = "http://brandomedina.pythonanywhere.com/api_registrarsqlserver"

    $database = "master"
    $connectionString = "Server=$nombrePC;Database=$database;Integrated Security=True;"
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
            [System.Windows.Forms.MessageBox]::Show("Datos  SQL enviados correctamente")
        } catch {
            Write-Output "Error al enviar datos: $_"
            [System.Windows.Forms.MessageBox]::Show("Error al enviar datos")
        }
    } catch {
        Write-Output "Error al conectar con SQL Server: $_"
        [System.Windows.Forms.MessageBox]::Show("Error al conectar con SQL Server")
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


    # Datos de autenticación
    $authBody = @{
        "username" = $usuario
        "password" = $password
    } | ConvertTo-Json

    Write-Output "Cuerpo de la solicitud de autenticacion: $authBody"

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

        # Crear la interfaz de usuario
        Add-Type -AssemblyName PresentationFramework      
        $Window = New-Object System.Windows.Window
        $Window.Title = "Formulario con Desplegable"
        $Window.Width = 300
        $Window.Height = 200
        $Window.WindowStartupLocation = "CenterScreen"

        # Crear un grid para organizar los elementos
        $Grid = New-Object System.Windows.Controls.Grid
        $Window.Content = $Grid
        
        $labelUser = New-Object System.Windows.Controls.Label
        $labelUser.Content = "Seleccionar una opcion:"
        $labelUser.Width = 100
        $labelUser.Height = 50
        $labelUser.Margin = [System.Windows.Thickness]::new(0, 0, 50, 80)
        $Grid.Children.Add($labelUser)


        # Crear el combobox (desplegable)
        $ComboBox = New-Object System.Windows.Controls.ComboBox
        $ComboBox.Width = 100
        $ComboBox.Height = 40
        $ComboBox.Margin = [System.Windows.Thickness]::new(50, 0, 50, 40)

        # Añadir opciones al combobox
        $ComboBox.Items.Add("Todo")
        $ComboBox.Items.Add("Aplicacion")
        $ComboBox.Items.Add("Seguridad")
        $ComboBox.Items.Add("Instalacion")
        $ComboBox.Items.Add("Sistema")
        $ComboBox.Items.Add("SqlServer")
        # Añadir el combobox al grid
        $Grid.Children.Add($ComboBox)

        # Crear un botón para obtener la selección
        $Button = New-Object System.Windows.Controls.Button
        $Button.Content = "Registrar Seleccion"
        $labelUser.Width = 200
        $labelUser.Height = 50
        $Button.Margin = [System.Windows.Thickness]::new(50, 110, 50, 20)

        # Evento del botón
        $Button.Add_Click({
            $selectedOption = $ComboBox.SelectedItem
            $message = ""
            switch ($selectedOption) {
                "Aplicacion" {
                    Aplicacion -headers $headers -nombrePC $nombrePC 
                }
                "Seguridad" {
                    Seguridad -headers $headers -nombrePC $nombrePC
                }
                "Instalacion" {
                    Instalacion -headers $headers -nombrePC $nombrePC
                }
                "Sistema" {
                    Sistema -headers $headers -nombrePC $nombrePC
                }
                "SqlServer" {
                   SqlServer -headers $headers -nombrePC $nombrePC
                }
                "Todo" {
                   Aplicacion -headers $headers -nombrePC $nombrePC
                   Seguridad -headers $headers -nombrePC $nombrePC
                   Instalacion -headers $headers -nombrePC $nombrePC
                   Sistema -headers $headers -nombrePC $nombrePC
                   SqlServer -headers $headers -nombrePC $nombrePC
                }

                Default {
                    $message = "No has seleccionado una opcion válida."
                    [System.Windows.MessageBox]::Show($message)
                }
            }

        })

        # Añadir el botón al grid
        $Grid.Children.Add($Button)

        $Window.ShowDialog() | Out-Null
    } else {
        Write-Output "Error al obtener el token de autenticacion"
    }
}


Show-LoginWindow

