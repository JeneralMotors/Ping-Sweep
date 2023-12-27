# Define a function named Ping-Sweep
function Ping-Sweep {
    [CmdletBinding()]
    param (
        # Define a parameter named Target which represents the base IP address
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Target
    )

    process {
        # Initialize an array to store alive hosts
        $aliveHosts = @()
        
        # Initialize an array to store background jobs
        $jobs = @()

        # Iterate through all possible host addresses (1 to 254)
        1..254 | ForEach-Object {
            # Construct the IP address
            $ip = "$Target.$_"
            
            # Start a background job to test connection to the IP address
            $jobs += Start-Job -ScriptBlock {
                param ($ip)
                
                # Test the connection to the IP address
                $result = Test-Connection -ComputerName $ip -Count 1 -Timeout 1

                # Check the status and add to the aliveHosts array if successful
                if ($result.Status -eq "Success") {
                    [PSCustomObject]@{
                        IPAddress = $result.DisplayAddress
                        Latency = $result.Latency
                        Status = $result.Status
                    }
                }
            } -ArgumentList $ip
        }

        # Wait for all background jobs to complete
        $null = $jobs | Wait-Job

        # Receive the results from all background jobs
        $aliveHosts = $jobs | Receive-Job

        # Clean up background jobs
        $jobs | Remove-Job

        # Output the list of alive hosts with additional details
        Write-Output $aliveHosts
    }
}
