function Test-Old {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Target
    )

    process {
        $aliveHosts = @()
        $jobs = @()

        # Get the total number of iterations
        $totalIterations = 254

        1..$totalIterations | ForEach-Object {
            $ip = "$Target.$_"

            # Display progress
            $percentComplete = ($_ / $totalIterations) * 100
            Write-Progress -Activity "Ping-Sweep" -Status "Scanning $ip" -PercentComplete $percentComplete

            # Start a job for each IP
            $jobs += Start-Job -ScriptBlock {
                param ($ip)
                $result = Test-Connection -ComputerName $ip -Count 1 -Timeout 1

                # Check the status and add to the aliveHosts array
                if ($result.Status -eq "Success") {
                    [PSCustomObject]@{
                        IPAddress = $result.DisplayAddress
                        Latency = $result.Latency
                        Status = $result.Status
                    }
                }
            } -ArgumentList $ip
        }

        # Wait for all jobs to complete
        $null = $jobs | Wait-Job

        # Receive the results from all jobs
        $aliveHosts = $jobs | Receive-Job

        # Clean up jobs
        $jobs | Remove-Job

        # Clear the progress bar
        Write-Progress -Completed

        # Output the list of alive hosts with additional details
        Write-Output $aliveHosts
    }
}
