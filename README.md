# Question 1

![Question 1 Diagram](https://github.com/Dandav159/LeumiAssignment/blob/main/Question1/Diagram.png)

### Github Setup
	1. Created new repository in Github for assignment.
	2. Created access token for pushing to repo.
	3. Pushed python app to repo.

### Jenkins Setup
	1. New AWS Region, created EC2 instance.
	2. Installed Docker on instance.
	3. Spun Jenkins controller container with volume and restart policy so it runs on boot (below).
	4. `sudo docker run --name jenkins --restart always -p 8080:8080 -v jenkins_home:/var/jenkins_home jenkins/jenkins`.
	5. Installed kuberntes plugin.
	6. Integrated Github repo with git plugin.
	7. Created initial pipeline job.
	8. Set Controller number of executors to 0.
	7. Created snapshot from instance.

### VPC Setup
	1. Created terraform resources for VPC with 2 public subnets (assign public IP), internet gateway, routing table, and rt to sn association.
	2. Created terraform resources for EC2 with Jenkins controller snapshot, and security group open to traffic from port 80, 8080, and 22.

### EKS Setup
	1. Created terraform resources for EKS, managed node group, relevant roles for cluster and nodes.
	2. Changed cluster context (`aws eks update-kubeconfig --region eu-central-1 --name assignment-cluster`).
	3. Created terraform resources for k8s namespaces, jenkins service account, relevant role and rolebinding, as well as token for jenkins cloud configuration.
	4. Configured Jenkins cloud with kubernetes plugin (cluster endpoint given as terraform output).

### ECR Setup
	1. Created ECR repository.
	2. Pushed WeatherApp image to repo.
	3. `aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 122610493328.dkr.ecr.eu-central-1.amazonaws.com/weatherapp`.

### Helm Setup
	1. Created helm chart for python app.
	2. Deployment and LoadBalancer service that connects to it and exposes on port 443.

### Pipeline
	1. Created Jenkinsfile (declarative pipeline).
	2. Set up agent as kubernetes pod.
	3. AWS container with downloaded docker for ECR authentication.
	4. Buildkit container for building and publishing. (DIND is problematic in k8s clusters 1.24+)
	5. Helm container for deploying chart.
	6. Created common volume for AWS container to share credentials with Buildkit.
	7. Deployed helm chart on cluster on appropriate namespace.

### LoadBalancer
	1. Opened port range of NodePort in EKS node sg.

### Deletion
	1. Run `helm uninstall weather-app --namespace app` to delete release and LB
	2. Run terraform destroy to delete infrastructure.

### Recreation (Manual operations)
	1. In Terraform folder, `terraform apply`
	2. Run `aws eks update-kubeconfig --region eu-central-1 --name assignment-cluster` (set context to newly created cluster)
	4. Log in Jenkins UI
	5. Configure kubernetes cloud as following:
		- K8s URL: cluster endpoint given as terraform output.
		- Jenkins URL: Jenkins instance private IP and port 8080.
		- Namespace: jenkins
		- Disable HTTPS check, enable WebSocket. (simplfies connection of Jenkins controller to agent)
		- Create new credential secret text, paste token outputted from `kubectl create token jenkins --namespace jenkins`.
		- Test connection.
	6. Run pipeline job.
	7. Open port range of NodePort in EKS node sg.
	8. Access app in LB URL, port 443.

---
# Question 2

### a. I would check:
	- "enable DNS resolution" option is enabled for the VPCs, meaning DNS resolution can be done with the AWS DNS server.
	- DNS configuration of the instance's resolver is correctly configured and pointing to the DNS server address.
	- route tables in internal VPCs are routing to TGW and the inspection VPC route table is routing to DNS server.
	- TGW route table is properly configured to route the request to inspection VPC.
	- checkpoint FW instance isn't blocking DNS traffic.
	- Route 53 service is correctly configured.
	- inbound/outbound rules on the instance security group or NACL not blocking DNS (port 53). 

### b. I would check:
	- TGW route table is properly configured to route the request to egress VPC.
	- TGW ENI attachment has been properly placed in the egress VPC.
	- route table in egress VPC is routing to NAT gateway.
	- NAT gateway is properly connecting to the internet, providing connection to the VPCs.
	- NFW isn't blocking any HTTPS response traffic.
	- inbound/outbound rule on the instance security group or NACL not blocking HTTPS (port 443).

### Pull access denied:
	- Might be a problem in authentication/authorization of the TEST EC2 with the NEXUS repo, or that repo url isn't correct.
	- Check if docker login was successful and if the proper permissions for pulling the image are configured.
	- Check if the name of the image/repo url is correct and no mispelling occurred.
	- Check if the repo is running and accessible from the nexus machine.

### Container pull time out:
    - Indicates a connectivity issue between the TEST EC2 and NEXUS EC2.
    - Check the connection between VPC's if routing tables of both VPCs and TGW are properly configured.
    - Check any problems with NACLs or security groups blocking any relevant ports.
    - Check whether the NEXUS EC2 machine is healthy and running properly.

### Docker daemon is not running:
    - Indicates docker service isn't active in TEST EC2.
    - Check whether docker installation is correct and there aren't any misconfigures.
    - Check whether the service is properly running with systemctl.
    - Check whether the user is in docker group (necessary to be able to use the docker daemon).

---
# Question 3

	- Since the address of the machine is retrieved, the problem isn't related to the DNS service but rather the attempt to connect via HTTPS.
	- If the service is on, and listening on port 443.
	- If the service is using a valid SSL/TLS certificate.
	- Check the security group of the machine to see if it's blocking HTTPS (port 443).
	- Any NACL rule on the VPC blocking HTTPS.
	- TGW, its attachments, and route tables are properly configured from egress VPC to test VPC.
	- NFW isn't blocking HTTPS traffic.
	- NAT gateway is properly configured for allowing internet connection to the VPCs.

---
# Question 4

	- `sudo yum install telnet` should be able to install in on an amazon linux 2 machine.
	- A potential problem is that the repo isn't updated and telnet might not be found.
	- Can be solved with `sudo yum update` to update the system packages.	

---
# Question 5

### EC2 Instance Setup
	1. Created new instance.
	2. Installed and enabled apache service (listens on http 80).
	3. Created snapshot from instance.

### Terraform
	1. Created VPC configuration with 1 public subnet (assign public IP), internet gateway, routing table, and rt to sn association.
	2. Created EC2 instance configuration with apache snapshot.
	3. Created security group allowing http traffic from leumi proxy. (unclear if all traffic or only http should be allowed)
	4. Created elastic IP for the instance.
	5. Created NLB, listener on port 80 (forwards to tg), target group containing instance and instance->tg attachment.