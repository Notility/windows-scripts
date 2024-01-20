# Define the list of event IDs to search for
$eventIDs = @(
    4624, # An account was successfully logged on
    4625, # An account failed to log on
    4720, # A user account was created
    4722, # A user account was enabled
    4723, # An attempt was made to change an account's password
    4725, # A user account was disabled
    4726, # A user account was deleted
)

# Loop through each event ID and display the latest events with details
foreach ($eventID in $eventIDs) {
    Write-Host "Showing detailed latest events for Event ID: $eventID"
    Get-WinEvent -FilterHashtable @{LogName='Security'; ID=$eventID} -MaxEvents 5 | ForEach-Object {
        # Create a custom object for each event to display detailed information
        $eventXml = [xml] $_.ToXml()
        [PSCustomObject] @{
            TimeCreated = $_.TimeCreated
            Id = $_.Id
            User = $eventXml.Event.EventData.Data | Where-Object { $_.Name -eq 'TargetUserName' } | Select-Object -ExpandProperty '#text'
            Computer = $eventXml.Event.System.Computer
            Message = $_.Message
        }
    } | Format-Table -AutoSize
    Write-Host "`n" # Newline for readability
}