1. Once AKS is created, we will create a namespace.

kubectl create namespace argocd

2. Then install argocd using below Yaml

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

3. If required we can also initialize the ArgoCD service in kubernetes as a LoadBalancer service.

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

4. Now we will create ArgoCD application Yaml. This will deploy ArgoCD project to keep a watch on our GitHub repo and deploy on K8s.

5. Once ArgoCD application is deployed, We can use the CLI or we can install argocd client on bastion or on any VM to connect to our gitHub repo. There are two options provide, HTTPS or SSH based.

6. If we select SSH we will have to create ssh on bastion for ArgoCD and also create a secret for the SSH in the AKS cluster as well.

for e.g. If we select ssh based authentication.

First generate ssh key on bastion or on any VM you want to access ArgoCD from.

ssh-keygen -t rsa -b 4096 -C "argocd"

Then proceed with creating a secret using the generated ssh-keygen

kubectl create secret generic git-ssh-key -n argocd --from-file=sshPrivateKey=~/.ssh/id_rsa

7. Once the keygen is created we can then login into to ArgoCD (ensue ArgoCD client is installed on the VM) 

argocd login <ARGOCD_SERVER_IP>

argocd repo add git@github.com:username/repo_name.git --ssh-private-key-path ~/.ssh/id_rsa