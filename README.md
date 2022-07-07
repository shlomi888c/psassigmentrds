# psassigmentrds

![ps](https://user-images.githubusercontent.com/100487390/177867491-2f3cdf8c-9f3e-429a-914a-0de35ae36a03.jpg)

this terraform code build two ec2 and rds service with mysql database that can attach to worpress when he will be install
and this system protected by waf app and the traffic is mangment by the alb.

vpc.tf: creates a vpc creates 4 private subnet and 2 public subnets creates  internet gateway to connect the VPC to the internet creates a 2 NAT gateway for the public subnet can access the internet 
         create two elastic ip to internet access. create two private route table  and one public route table and associating route table with the subnets.
         
ec2.tf create 2 ec2 t3 micro aws linux 2.

securitygroup create securitygroup for ec2 and for rds service. 

alb.tf create alb and attach it to ec2.

rds.tf create rds service with mysql database multi zone with replica.

waf.tf create waf app to attach the alb.

varliables.tf holds the definition of variables.

terraform.tfvars default values for vars.
