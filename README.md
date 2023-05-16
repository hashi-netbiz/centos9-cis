# RHEL Centos 9 Stream Hardening using CIS Benchmark

Description
-----------
This repo provides 2 options to harden a CentOS Stream 9 VM in accordance with CIS Benchmark (Server - Level 1).
Section A below describes how openscap and ansible can be used to harden the centos 9 stream. Section B describes how a single 
clause in the CIS benchmark (specifically Clause 5.2) can be implemented to harden the image.

# SECTION A:
### [1] Install the required packages:
        dnf -y install openscap-scanner scap-security-guide

### [2] SCAP Security Guide is installed under the [/usr/share/xml/scap/ssg/content] directory: 
        ll /usr/share/xml/scap/ssg/content/ 

### [3] Display description for each content. Openscap Implemented security profiles are listed.
        oscap info /usr/share/xml/scap/ssg/content/ssg-cs9-ds.xml 
        
### [4] Scan CentOS System with [oscap] command. This is based on CIS server level 1 security checks only.
###     Scan result is generated as HTML report, verify it and try to apply recommended settings as much as possible:
        oscap xccdf eval \
        --profile xccdf_org.ssgproject.content_profile_cis_server_l1 \
        --results ssg-cs9-ds.xml \
        --report ssg-cs9-ds.html \
        --fetch-remote-resources \
        /usr/share/xml/scap/ssg/content/ssg-cs9-ds.xml 

### [5] Check the html report and rename as ssg-cs9-ds-existing.html
###        Copy the html file to the context user home directory as below:
        cp ssg-cs9-ds-existing.html /home/user/ssg-cs9-ds-existing.html
        
###      Transfer the newly created report from the VM to local environment to view:
###      Run the copy command on your desktop
        scp user@ip or host:/home/user/ssg-cs9-ds-existing.html ./        

### [6] Generate remediation script from scaned result.
        Remediation script will change various system settings, so you must take care if you run it, especially for production systems.
       
### make sure the [Result ID] in the result output on [4]
        oscap info ssg-cs9-ds.xml | grep "Result ID" 
        
###     Generate remediation script
        oscap xccdf generate fix \
        --fix-type ansible \
        --output ssg-cs9-ds-remediation-playbook.yml \
        --result-id xccdf_org.open-scap_testresult_xccdf_org.ssgproject.content_profile_cis_server_l1 \   
        ssg-cs9-ds.xml 
        
###     Copy the newly created ansible playbook file to the context user's home directory
        cp ssg-cs9-ds-remediation-playbook.yml /home/user/ssg-cs9-ds-remediation-playbook-existing.yml
        
###     Change the file ownership. Replace {CONTEXT-USER} with actual centos local user
        sudo chown {CONTEXT-USER} ssg-cs9-ds-remediation-playbook-existing.yml
        
###      Transfer the newly created playbook file from the VM to the local desktop environment to view:
###      Run the copy command on your desktop 
        scp user@ip or host:/home/user/ssg-cs9-ds-remediation-playbook-existing.yml ./ 
        
###      Open the downloaded ansible file in visual studio code and edit the file to comform to the recommendations on the openscap ticket (LINK TO TICKET).

###      Rename the modified ansible file as ssg-cs9-ds-remediation-playbook-new.yml

###      Upload playbook back to the VM. Run the following command on your desktop from the directory where the updated playbook is located. Replace {CONTEXT-USER} with actual centos local user
        scp ssg-cs9-ds-remediation-playbook-new.yml {CONTEXT-USER}@ip or host:/home/{CONTEXT-USER}
        
###      CD into the VM root directory and EXECUTE the following command:
        cp /home/{CONTEXT-USER}/ssg-cs9-ds-remediation-playbook-new.yml ssg-cs9-ds-remediation-playbook-new.yml        
        
###     run remediation script
###     install ansible-core. Since sysctl module is not included, install this module via ansible-galaxy 
        dnf install ansible-core -y
        ansible-galaxy collection install ansible.posix
        
###     Update the default anible hosts file located at /etc/ansible/hosts and append the following line:
        localhost ansible_connection=local        

###     Execute ansible playbook to install CIS benchmarks and remediate.       
###     Replace 'sysctl:' with 'ansible.posix.sysctl:' in remediation playbook       
        sed 's/sysctl:/ansible.posix.sysctl:/g'  ssg-cs9-ds-remediation-playbook-new.yml 
        
###     Run playbook
        ansible-playbook ./ssg-cs9-ds-remediation-playbook-new.yml
        
### [7] Re-run the HTML report and check the result:
        oscap xccdf eval \
        --profile xccdf_org.ssgproject.content_profile_cis_server_l1 \
        --results ssg-cs9-ds.xml \
        --report ssg-cs9-ds.html \
        --fetch-remote-resources \
        /usr/share/xml/scap/ssg/content/ssg-cs9-ds.xml 
     
### [8]
###      Review the latest html report generated in 7 above and rename it as ssg-cs9-ds-updated.html
###      Copy the html file to the context user home directory as below:
        cp ssg-cs9-ds-existing.html /home/user/ssg-cs9-ds-updated.html
        
###      Transfer the latest report from the VM to local environment to view and make comparison with the original report:
###     Run the copy command on your desktop
        scp user@ip or host:/home/user/ssg-cs9-ds-updated.html ./ 
        
### [9] CD to the root directory of the VM and it up but executing the following:
        rm -f ssg*
        
###[10] Finally create a golden image from the modified VM. For the creation of the golden centos 9 stream image, refer to the microsoft publication referenced below:

        https://learn.microsoft.com/en-us/azure/virtual-machines/capture-image-portal






### SECTION B

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


