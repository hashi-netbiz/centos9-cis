# centos9-cis

Description
-----------
This repo provides some scripts to be able to apply some CIS BENCHMARK to a CentOS Stream 9 VM in Azure cloud.

Instructions
------------

1.0 Setup
#####
1. Create a VM from the existing centos9 golden image in azure.
2. SSH into the VM created above
3. login as root and cd to the root home directory (/root)
4. run the following command to install git:
    yum install git -y
5. clone the CIS repository where installation scripts are kept e.g
   git clone https://github.com/$(your-repo)
6. make the setup script executable as follows:
    chmod +x /root/centos9-cis/cis-setup.bash
7. run the setup script as follows:
   bash /root/centos9-cis/cis-setup.bash
8. Stop the VM in azure and proceed to section 2.0 below


2.0 Finally create a golden image from the modified VM in 1.0 above
############
for the creation of the golden centos 9 stream image, refer to the 
microsoft publication referenced below:

    https://learn.microsoft.com/en-us/azure/virtual-machines/capture-image-portal


