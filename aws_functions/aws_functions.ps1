function awshelp {
    Write-Host @"
    awsacctalias - Show account aliases for current credentials
    awsgetcaller - Show current credentials
    awswhoami - Show current credentials
    awsunsetcreds - unset the AWS_SHARED_CREDENTIALS_FILE environment variabe
    awscheckcreds - Show what is set as the environment variable for AWS_SHARED_CREDENTIALS_FILE
    awsunsetprofile - unset the AWS_PROFILE environment variabe
    awscheckprofile - Show what is set as the environment variable for AWS_PROFILE
    awscheck - Show what is set as the environment variables matching AWS_*
    awssetcreds - Sets the AWS_SHARED_CREDENTIALS_FILE environment variable
    awssetprofile - Sets the AWS_PROFILE environment variable
    awssetregion - Sets the AWS_REGION environment variable
    awsunset - unsets all known AWS_* environment variables.
    

    Todo:
    awscfnhelper - Alias to the cloudformation helper script found in ~/Documents/repos/scsarver/utility_scripts/cloudformation
    awsssmto - Finds a matching ec2 instance and starts an ssm session
    awsssminventory - Show ec2 instances data for instance that can use ssm.
    awsgetinstancedata - Extract the id, ami and Name Tag for ec2 instances matching the suppled value against the Name tag.
    awsacctnumberfromarn - Extracts the account number from an ARN (Amazon Resource Name)
    awsextractcreds - Extract a credentials file from the standard location into the current directory as [default]
    awss3countobjects - Returns a count of objects in the s3 bucket
    awsfindsecret - Finds an AWS Secret matching the supplied string.
    awslistcfn - Lists cloudformation stack names
    awsfindcfn - Finds a cloudformation stack name matched to the supplied string
"@
}

function awsacct {

    Write-Host (aws iam list-account-aliases | jq -r ".AccountAliases[0]")
    
}

function awsgetcaller {

    Write-Host (aws sts get-caller-identity --query 'Account' --output text)
    
}
function awsgetacct {

    Write-Host (aws sts get-caller-identity --query 'Account' --output text)
    
}

function awsunsetcreds {

    [System.Environment]::SetEnvironmentVariable("AWS_SHARED_CREDENTIALS_FILE","")
    
}
function awscheckcreds {

    Write-Host (aws sts get-caller-identity --query 'Account' --output text)
    
}
function awsunsetprofile {

    [System.Environment]::SetEnvironmentVariable("AWS_PROFILE","")
    
}
function awswhoami {

    awsgetacct
    Write-Host (aws sts get-caller-identity)
    
}

function awscheckcreds {

    Get-ChildItem env:* | Where-Object {$_.Name -eq "AWS_SHARED_CREDENTIALS_FILE"}
}

function awscheckprofile {

    Get-ChildItem env:* | Where-Object {$_.Name -eq "AWS_PROFILE"}
}

function awscheckprofile {

    Get-ChildItem env:* | Where-Object {$_.Name -like "AWS_*"}
}


# function awsextractcreds {
#     [CmdletBinding()]
#     param (
#         [Parameter()]
#         [TypeName]
#         $ParameterName
#     )
#     $Env:AWS_PROFILE=""
#     $Env:AWS_SHARED_CREDENTIALS_FILE=""
#     if [ "" == "$1" ]; then
#       echo "Passing the profile to extract credentials for is required!"
#     else
#       local ACCESS_KEY="$(aws configure get aws_access_key_id --profile $1 )"
#       if [ "The config profile ($1) could not be found" == "$ACCESS_KEY" ]; then
#         echo "$ACCESS_KEY"
#       else
#         touch awscreds
#         echo "[default]">awscreds
#         echo "aws_access_key_id=$(aws configure get $1.aws_access_key_id)">>awscreds
#         echo "aws_secret_access_key=$(aws configure get $1.aws_secret_access_key)">>awscreds
#         echo "aws_session_token=$(aws configure get $1.aws_session_token)">>awscreds
#       fi
#     fi
#   }

  function unsetvar{
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$env_variable
    )
    [System.Environment]::SetEnvironmentVariable("$($env_variable)","")
  }

  function setvar{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$env_variable,
        
        [Parameter(Mandatory)]
        [string]$env_variable_value
    )
  [System.Environment]::SetEnvironmentVariable("$($env_variable)","$($env_variable_value)")
}

function printvar{
    [CmdletBinding()]
  param(
      [Parameter()]
      [string]$env_variable
  )
  Write-Host([System.Environment]::GetEnvironmentVariable("$($env_variable)"))
}
  function awsunset {
    #https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html
    unsetvar AWS_ACCESS_KEY_ID
    unsetvar AWS_SECRET_ACCESS_KEY
    unsetvar AWS_SESSION_TOKEN
    unsetvar AWS_DEFAULT_REGION
    unsetvar AWS_DEFAULT_OUTPUT
    unsetvar AWS_DEFAULT_PROFILE
    unsetvar AWS_CA_BUNDLE
    unsetvar AWS_SHARED_CREDENTIALS_FILE
    unsetvar AWS_CONFIG_FILE
    #https://docs.aws.amazon.com/cli/latest/topic/config-vars.html
    unsetvar AWS_PROFILE
    unsetvar AWS_METADATA_SERVICE_TIMEOUT
    unsetvar AWS_METADATA_SERVICE_NUM_ATTEMPTS
    #I think this is remanant of usage thart was supposed to be looking at AWS_DEFAULT_REGION yet here it lives on :(
    unsetvar AWS_REGION
  }

function awssetcreds {
    [CmdletBinding()]
    param(
        [Parameter()]
        [String]$aws_cred_file
    )
    [System.Environment]::SetEnvironmentVariable("AWS_SHARED_CREDENTIALS_FILE","$($aws_cred_file)")
}

function awssetprofile {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$aws_profile
    )
    [System.Environment]::SetEnvironmentVariable("AWS_PROFILE","$($aws_profile)")
}

function awssetregion {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$aws_region
    )
    [System.Environment]::SetEnvironmentVariable("AWS_REGION","$($aws_region)")
}

function awssetdefault {
    [System.Environment]::SetEnvironmentVariable("AWS_DEFAULT_REGION","us-east-1")
    [System.Environment]::SetEnvironmentVariable("AWS_PAGER","")
}
  