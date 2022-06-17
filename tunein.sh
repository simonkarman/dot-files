# (T)une(I)n (S)tart
tis() {
  header() { echo "\n\033[0;31m$1\033[0m" }

  header "Loggin in to OnePassword..."
  op get account || lxo

  header "Getting AWS credentials..."
  opid="n3ah537v5nh6xfhh34xahnqnge"
  username=$(op get item $opid | jq --raw-output '.details.fields[0].value')
  password=$(op get item $opid | jq --raw-output '.details.fields[1].value')
  mfatoken=$(op get totp $opid)
  saml2aws login --session-duration="43200" "--username=$username" "--password=$password" "--mfa-token=$mfatoken"

  header "Updating kubeconfig..."
  export AWS_PROFILE=ti-dev-platform
  aws eks update-kubeconfig --name "dev-platform-shared-uswest2-01" --region "us-west-2" --profile "ti-dev-platform" --alias "dev-platform-shared-uswest2-01"
  kubectl config set-context --current --namespace="platform-microservices"

  # Others
  export PULUMI_CONFIG_PASSPHRASE=
}
