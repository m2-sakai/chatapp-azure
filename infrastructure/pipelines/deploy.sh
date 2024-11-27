#!/bin/bash

# login
az login

# nsg deploy
az deployment group create -g rg-adcl-test-je-01 -f ../templates/network/create-nsg-rule_template.bicep -p ../parameters/network/create-nsg/create-nsg-rule-sub-0_0_parameter.bicepparam
az deployment group create -g rg-adcl-test-je-01 -f ../templates/network/create-nsg-rule_template.bicep -p ../parameters/network/create-nsg/create-nsg-rule-sub-1_0_parameter.bicepparam
az deployment group create -g rg-adcl-test-je-01 -f ../templates/network/create-nsg-rule_template.bicep -p ../parameters/network/create-nsg/create-nsg-rule-sub-2_0_parameter.bicepparam
az deployment group create -g rg-adcl-test-je-01 -f ../templates/network/create-nsg-rule_template.bicep -p ../parameters/network/create-nsg/create-nsg-rule-sub-3_0_parameter.bicepparam
az deployment group create -g rg-adcl-test-je-01 -f ../templates/network/create-nsg-rule_template.bicep -p ../parameters/network/create-nsg/create-nsg-rule-sub-4_0_parameter.bicepparam

# vnet deploy
az deployment group create -g rg-adcl-test-je-01 -f ../templates/network/create-vnet-subnet_template.bicep -p ../parameters/network/create-vnet/create-vnet-subnet-01_parameter.bicepparam

# pdz deploy
az deployment group create -g rg-adcl-test-je-01 -f ../templates/network/create-pdz-record_template.bicep -p ../parameters/network/create-pdz/create-pdz-record-azurewebsites_parameter.bicepparam
az deployment group create -g rg-adcl-test-je-01 -f ../templates/network/create-pdz-record_template.bicep -p ../parameters/network/create-pdz/create-pdz-record-documents_parameter.bicepparam
az deployment group create -g rg-adcl-test-je-01 -f ../templates/network/create-pdz-record_template.bicep -p ../parameters/network/create-pdz/create-pdz-record-webpubsub_parameter.bicepparam

# pip deploy
az deployment group create -g rg-adcl-test-je-01 -f ../templates/network/create-pip_template.bicep -p ../parameters/network/create-pip/create-pip-apim-01_parameter.bicepparam

# log appi deploy
az deployment group create -g rg-adcl-test-je-01 -f ../templates/monitor/create-log-appi_template.bicep -p ../parameters/monitor/create-log-appi/create-log-appi-01_parameter.bicepparam

# id deploy
az deployment group create -g rg-adcl-test-je-01 -f ../templates/identity/create-id_template.bicep -p ../parameters/identity/create-id/create-id-01_parameter.bicepparam

# st deploy
az deployment group create -g rg-adcl-test-je-01 -f ../templates/storage/create-st_template.bicep -p ../parameters/storage/create-st/create-st-01_parameter.bicepparam

# asp deploy
az deployment group create -g rg-adcl-test-je-01 -f ../templates/web/create-asp_template.bicep -p ../parameters/web/create-asp/create-asp-01_parameter.bicepparam

# func deploy
az deployment group create -g rg-adcl-test-je-01 -f ../templates/web/create-func_template.bicep -p ../parameters/web/create-func/create-func-01_parameter.bicepparam

# cosmos deploy
az deployment group create -g rg-adcl-test-je-01 -f ../templates/database/create-cosmos_template.bicep -p ../parameters/database/create-cosmos/create-cosmos-01_parameter.bicepparam
