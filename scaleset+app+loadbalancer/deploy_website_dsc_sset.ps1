# Define the script for your Desired Configuration to download and run
$dscConfig = @{
    "wmfVersion" = "latest";
    "configuration" = @{
      "url" = "https://github.com/iainfoulds/azure-samples/raw/master/dsc.zip";
      "script" = "configure-http.ps1";
      "function" = "WebsiteTest";
    };
  }
  
  # Get information about the scale set
  $vmss = Get-AzureRmVmss `
                  -ResourceGroupName "RG" `
                  -VMScaleSetName "vm2018yg"
  
  # Add the Desired State Configuration extension to install IIS and configure basic website
  $vmss = Add-AzureRmVmssExtension `
      -VirtualMachineScaleSet $vmss `
      -Publisher Microsoft.Powershell `
      -Type DSC `
      -TypeHandlerVersion 2.24 `
      -Name "DSC" `
      -Setting $dscConfig
  
  # Update the scale set and apply the Desired State Configuration extension to the VM instances
  Update-AzureRmVmss `
      -ResourceGroupName "RG" `
      -Name "vm2018yg"  `
      -VirtualMachineScaleSet $vmss