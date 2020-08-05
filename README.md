# hospital
This project takes application code from source to relase.
The original application source code is gotten from Jayendra Matarage's code https://github.com/blackburn3333/Hospital-Management-System.git

Tools used: Azure Devops service,Azure Iaas, Terraform, Ansible, Packer, Bash etc.

This application is deployed to Azure scale sets which closely adapts to the changing resources demands in the health sector.
The Scalesets, load balancers aand all other infrastucture is provisoned on Azure using Terraform as shown in the Terraform folder scripts.
Packer and Ansible is used to create images in the desired state.
Azure Devops was used to set up Continuous Integration/Continuous Delivery pipelines and the tasks are outlined in the pipeline.yaml file
