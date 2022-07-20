# (T)une(I)n AWS
ti_aws() {
  header() { echo "\n\033[0;31m$1\033[0m" }

  header "Loggin in to OnePassword..."
  op get account || eval $(op signin xebia)

  header "Getting AWS credentials..."
  opid="n3ah537v5nh6xfhh34xahnqnge"
  username=$(op get item $opid | jq --raw-output '.details.fields[0].value')
  password=$(op get item $opid | jq --raw-output '.details.fields[1].value')
  mfatoken=$(op get totp $opid)
  saml2aws login --session-duration="43200" "--username=$username" "--password=$password" "--mfa-token=$mfatoken"
  export AWS_PROFILE=ti-dev-platform
  aws sts get-caller-identity | jq
}

# header "Updating kubeconfig..."
# export AWS_PROFILE=ti-dev-platform
# aws eks update-kubeconfig --name "dev-platform-shared-uswest2-01" --region "us-west-2" --profile "ti-dev-platform" --alias "dev-platform-shared-uswest2-01"
# # aws eks update-kubeconfig --name "operations-nonprod-uswest2-02" --region "us-west-2" --profile "ti-operations" --alias "operations-nonprod-uswest2-02"
# kubectl config set-context --current --namespace="clarity"

# (T)une(I)n Pulumi
ti_pulumi() {
  if [[ -z $AWS_PROFILE ]]; then
    echo "ERROR: Please set the AWS_PROFILE..."
    return 1;
  fi
  stack=$1
  if [[ -z $stack ]]; then
    echo "ERROR: Please provide an argument for the pulumi stack..."
    return 1;
  fi
  application=$(basename $(git rev-parse --show-toplevel));
  echo "TuneIn pulumi loggin in to '\033[0;31m$application\033[0m' backend on '\033[0;31m$AWS_PROFILE\033[0m'.";
  pulumi login s3://clarity-$AWS_PROFILE-pulumi-state/$application;
  export PULUMI_CONFIG_PASSPHRASE=
  pulumi stack select $stack && echo "Successfully selected '$stack' stack." || echo "\033[0;31mERROR\033[0m while selecting '$stack' stack"
}
