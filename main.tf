// Configure the Google Cloud provider
provider "google" {
 credentials = file("CREDENTIALS_FILE.json")
 project     = "my-file"
 region      = "us-west1"
}
// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "jenkinsansible-vm-${random_id.instance_id.hex}"
 machine_type = "n1-standard-1"
 zone         = "us-west1-a"

 boot_disk {
   initialize_params {
     image = "centos-cloud/centos-7-v20200714"
   }
 }

// Make sure ansible is installed on all new instances for later steps
 metadata_startup_script = "sudo yum update -y; sudo yum install -y epel-release; sudo yum install -y ansible; sudo ansible-galaxy install robertdebock.jenkins; sudo ansible-galaxy install lrk.prometheus"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}

provisioner "remote-exec" {
  command = ["ansible-playbook -u root install_jenkins_monitoring.yml]
}