#!/bin/bash
# Set version info
BOX_VERSION_BASE=1.3.0

# Set versions requested of main components
export AB_VERSION=2.3
export ANSIBLE_VERSION=2.9.7
export APPSODY_VERSION=0.6.1
export ARGOCD_VERSION=1.5.2
export ARKADE_VERSION=0.3.2
export BAT_VERSION=0.15.0
export BOX_BASE="centos/7"
export BOX_BASE_VERSION=1905.1
export BUILDAH_VERSION=1.9.0
export CALICOCTL_VERSION=3.13.3
export CLOUDCTL_VERSION=3.3.0
export DOCKER_VERSION=19.03.8
export FAAS_CLI_VERSION=0.12.4
export GITHUB_CLI_VERSION=0.7.0
export GOLANG_VERSION=1.14.2
export GRADLE_VERSION=6.3
export HELM_VERSION=3.2.0
export IBMCLOUD_VERSION=1.0.0
export IBM_GARAGE_CLOUD_CLI_VERSION=0.5.3
export IBM_SOLSA_VERSION=0.3.6
export INLETSCTL_VERSION=0.5.2
export INLETS_VERSION=2.7.0
export JDK_VERSION=14-openj9
export JMETER_VERSION=5.2.1
export JQ_VERSION=1.6
export K3S_VERSION=1.17.4+k3s1
export KIND_VERSION=0.7.0
export KN_VERSION=0.14.0
export KO_VERSION=0.5.0
export KUBECTL_VERSION=1.18.2
export KUBECTX_VERSION=0.8.0
export KUBENS_VERSION=0.8.0
export KUSTOMIZE_VERSION=3.5.4
export MAVEN_VERSION=3.6.3
export MINIKUBE_VERSION=1.9.2
export MONGODB_VERSION=4.2
export MYSQL_VERSION=15.1
export NODEJS_VERSION=12.16.2
export OC_VERSION=4.3
export ODO_VERSION=1.2.0
export PODMAN_VERSION=1.4.4
export S2I_VERSION=1.3.0
export SKAFFOLD_VERSION=1.8.0
export SKOPEO_VERSION=0.1.37
export STERN_VERSION=1.11.0
export TERRAFORM_IBMCLOUD_VERSION=1.5.0
export TERRAFORM_VERSION=0.12.24
export TKN_VERSION=0.8.0
export TM_VERSION=0.2.0
export VAGRANT_CLOUD_BOX="cloud-native"
export VEGETA_VERSION=12.8.3
export YQ_VERSION=3.3.0



# Ask user for vagrant cloud token
echo -n "What is your Vagrant Cloud username? [csantanapr] "
read user
user=${user:-csantanapr}
export VAGRANT_CLOUD_USER=${user}

# Ask user for vagrant cloud token
echo -n "What is your Vagrant Cloud token? "
read -s token
echo ""
export VAGRANT_CLOUD_TOKEN=${token}

# Export dynamic versioning info
export BOX_VERSION=${BOX_VERSION_BASE}-$(date +'%Y%m%d')
commit=$(git --no-pager log -n 1 --format="%H")
export BOX_VERSION_DESCRIPTION="
## Description
This box is based on the ${BOX_BASE} box version ${BOX_BASE_VERSION}.

This project contains everything needed to build the cloud-native vagrant box.

It is pre-configured with 3 lightweight kubernetes distributions for local development [minikube](https://minikube.sigs.k8s.io/docs), [kind](https://kind.sigs.k8s.io), and [k3s](https://github.com/rancher/k3s) .

The box defaults to 2 CPU and 2GB of RAM

To disable the default Vagrant synced folder (\`/vagrant\`), you need to add the
following snippet to your \`Vagrantfile\`:

\`\`\`ruby
config.vm.synced_folder \".\", \"/vagrant\", disabled: true
\`\`\`

Use the following default Vagrantfile:

\`\`\`Vagrantfile
Vagrant.configure(\"2\") do |config|

  config.vm.box = \"csantanapr/cloud-native\"
  config.vm.synced_folder \".\", \"/vagrant\", disabled: true
  config.vm.provider \"virtualbox\" do |vb|
    vb.cpus = 2
    vb.memory = 2048
  end

end
\`\`\`

---

## Versions included in this release
Based on box [${BOX_BASE}](https://app.vagrantup.com/centos/boxes/7) version ${BOX_BASE_VERSION}

Kubernetes:
* k3s ${K3S_VERSION}
* kind ${KIND_VERSION}
* minikube ${MINIKUBE_VERSION}

Tools:
* ab ${AB_VERSION}
* ansible ${ANSIBLE_VERSION}
* appsody ${APPSODY_VERSION}
* argocd ${ARGOCD_VERSION}
* arkade ${ARKADE_VERSION}
* bat ${BAT_VERSION}
* buildah ${BUILDAH_VERSION}
* calicoctl ${CALICOCTL_VERSION}
* cloudctl ${CLOUDCTL_VERSION}
* docker ${DOCKER_VERSION}
* faas-cli ${FAAS_CLI_VERSION}
* emacs
* gh ${GITHUB_CLI_VERSION}
* go ${GOLANG_VERSION}
* gradle ${GRADLE_VERSION}
* helm ${HELM_VERSION}
* hey
* ibmcloud ${IBMCLOUD_VERSION}
* ibmcloud plugins (cdb, cfee, cos, cr, dev, es, functions, iam, is, ks, oc, resource, schematics, sl, terraform, watson)
* igc ${IBM_GARAGE_CLOUD_CLI_VERSION}
* inlets ${INLETS_VERSION}
* inletsctl ${INLETSCTL_VERSION}
* java ${JDK_VERSION}
* javac ${JDK_VERSION}
* jmeter ${JMETER_VERSION}
* jq ${JQ_VERSION}
* kn ${KN_VERSION}
* ko ${KO_VERSION}
* kube-ps1
* kubectl ${KUBECTL_VERSION}
* kubectx ${KUBECTX_VERSION}
* kubens ${KUBENS_VERSION}
* kustomize ${KUSTOMIZE_VERSION}
* latest updates installed at build time
* mkisofs
* mongo ${MONGODB_VERSION}
* mvn ${MAVEN_VERSION}
* mysql ${MYSQL_VERSION}
* node.js ${NODEJS_VERSION}
* oc ${OC_VERSION}
* odo ${ODO_VERSION}
* podman ${PODMAN_VERSION}
* psql
* python
* python3
* s2i ${S2I_VERSION}
* s3cmd
* screen
* skaffold ${SKAFFOLD_VERSION}
* skopeo ${SKOPEO_VERSION}
* serverless
* solsa ${IBM_SOLSA_VERSION}
* stern ${STERN_VERSION}
* terraform ${TERRAFORM_VERSION}
* terraform ibmcloud ${TERRAFORM_IBMCLOUD_VERSION}
* tig
* tkn ${TKN_VERSION}
* tm ${TM_VERSION}
* tmux
* tree
* vegeta ${VEGETA_VERSION}
* yq ${YQ_VERSION}
* unzip
* zip

---

$(cat CHANGELOG.md)

---

## Source info
[View source on Github](https://github.com/csantanapr/vagrant-cloud-native)

Built on commit: \`${commit}\`
"

echo "${BOX_VERSION_DESCRIPTION}"

# Validate build config
echo "Validating build json files"
packer validate packer.json || exit 1

# Run the actual build
echo "Building box version ${BOX_VERSION}"
packer build -force -on-error=abort packer.json || exit 1

# Tag git commit for this build
git tag -a "${BOX_VERSION}" -m "Version ${BOX_VERSION} built."