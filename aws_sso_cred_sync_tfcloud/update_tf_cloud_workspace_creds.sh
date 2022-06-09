#!/usr/bin/env zsh
# Quick and dirty script to update credentials automatically to Terraform Cloud using AWS SSO credentialing
# www.xtecsystems.com/research
# Dennis Chow 06/08/2022

#The script will process AWS credentials that are set in your default profile via SSO on the local host.
#Tools like Leapp.cloud can automate the rotation of your AWS Access Key, Secret, and STS session token in the credentials file
#The credentials will be sent via env variables to Terraform Cloud for your default/first workspace and organization for runtime
#Terraform cloud needs your credentials to perform the IaaC deployment on your behalf using the HCL AWS Provider

function crtl_c() {
    echo "Terminate request received, cleaning up..."
    unset TFCLOUD_API_TOKEN
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset TFCLOUD_WORKSPACE_ID
    unset PAYLOAD
    unset TFCLOUD_WORKSPACE_ID
    unset ORGNAME
    exit 0
}

#trap crtl function clean up
trap ctl_c SIGTERM
trap ctl_c SIGINT
trap ctl_c INT

for i in {1..16}
do
    #Set your organization Terraform cloudname here
    ORGNAME="xtecsystems"

    #locations assume you installed in the default home user folder
    TFCLOUD_API_TOKEN=$(cat ~/.terraform.d/credentials.tfrc.json | jq -r '.credentials."app.terraform.io".token')
    AWS_ACCESS_KEY_ID=$(cat ~/.aws/credentials | grep -i '[default]' -a1 | grep -i 'aws_access_key_id' | cut -d'=' -f2)
    AWS_SECRET_ACCESS_KEY=$(cat ~/.aws/credentials | grep -i '[default]' -a2 | grep -i 'aws_secret_access_key' | cut -d'=' -f2)
    AWS_SESSION_TOKEN=$(cat ~/.aws/credentials | grep -i '[default]]' -A3 | grep -i 'aws_session_token' | cut -d'"' -f2)
    TFCLOUD_WORKSPACE_ID=$(curl -s --header "Authorization: Bearer $TFCLOUD_API_TOKEN" --header "Content-Type: application/vnd.api+json" --url "https://app.terraform.io/api/v2/organizations/$ORGNAME/workspaces" | jq -r '.data | .[] | .id')

    echo "Your Active Default Workspace: $TFCLOUD_WORKSPACE_ID"
    #Attempted array for variable settings on payload and function for curl but ran into parsing issues
    #At the time of this script, the TF Cloud API for updating the variable won't take multiple variables in the payload as a batch
    PAYLOAD=$(cat update_workspace_test_vars.json | jq --arg AWS_ACCESS_KEY_ID "$AWS_ACCESS_KEY_ID" '. | select(.data.attributes.key == "AWS_ACCESS_KEY_ID") | .data.attributes.value=$AWS_ACCESS_KEY_ID')
    curl --header "Authorization: Bearer $TFCLOUD_API_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data $PAYLOAD \
    --url "https://app.terraform.io/api/v2/workspaces/$TFCLOUD_WORKSPACE_ID/vars"

    echo ""

    PAYLOAD=$(cat update_workspace_test_vars.json | jq --arg AWS_SECRET_ACCESS_KEY "$AWS_ACCESS_KEY_ID" '. | select(.data.attributes.key == "AWS_SECRET_ACCESS_KEY") | .data.attributes.value=$AWS_SECRET_ACCESS_KEY')
    curl --header "Authorization: Bearer $TFCLOUD_API_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data $PAYLOAD \
    --url "https://app.terraform.io/api/v2/workspaces/$TFCLOUD_WORKSPACE_ID/vars"
    echo ""

    PAYLOAD=$(cat update_workspace_test_vars.json | jq --arg AWS_SESSION_TOKEN "$AWS_SESSION_TOKEN" '. | select(.data.attributes.key == "AWS_SESSION_TOKEN") | .data.attributes.value=$AWS_SESSION_TOKEN')
    curl --header "Authorization: Bearer $TFCLOUD_API_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data $PAYLOAD \
    --url "https://app.terraform.io/api/v2/workspaces/$TFCLOUD_WORKSPACE_ID/vars"
    
    #clean up in between
    unset TFCLOUD_API_TOKEN
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset TFCLOUD_WORKSPACE_ID
    unset PAYLOAD
    unset TFCLOUD_WORKSPACE_ID
    unset ORGNAME

    #refresh every 30 min
    sleep 1800
    #ensure the crtl c trap breaks compltely out of loop
    break
done