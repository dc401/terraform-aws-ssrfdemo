# terraform-aws-ssrfdemo
Contains example terraform modules to deploy  a SSRF demo leveraging AWS EC2 instance, PHP creating a new VPC, IGW using a public subnet. The current IaC configuration and PHP is intentionally vulnerable to code and should be hardened if desired to use in an on-going production enviornment. 

This module is primarily used for demonstration purposes on the use of terraform cloud <> github action intergrations, SSRF PHP related EC2 IMDSv1 vulnerabilities, and terraform isolated module input and output variable pass through basics. From a security perspective, it also show cases the gaps of typical scanners that won't be able to follow wget links within user data for scanning, e.g. the PHP code itself. 

*Note* There are folders with the vulnerable and fixed PHP example code along with the credential sync shell scripts. Those are in the git ignore file and would not be part of the commits when triggered to terraform cloud.

Article on the complete setup, deployment and use of this coming soon...


To learn more about security visit: xtecsystems.com/research
