1. Create AWS instance where you will execute all commands on your cluster.

    It can be a small instane of t2.Micro size with Ubuntu on it. I call is "Cluster Admin Server"

    * During creation of the instance you have to "Create Key Pair" and save it on your computer, move ro ~/.ssh and set permissions 0600
    
    * Connect to your admin instance
    
    ```
    ssh -i ~/.ssh/ClusterAdminServer.cer ubuntu@XXX.XXX.XXX.XXX
    ```

1. Install all required software with `kops_cluster_on_aws.sh`