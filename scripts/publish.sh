#!/bin/sh

set -e

for chartyaml in */Chart.yaml; do
  # get version from chart yaml
  version=$(yq r "$chartyaml" version)
  chartdir=$(dirname "$chartyaml")
  tgz="$chartdir-$version.tgz"
  if [ ! -f "$tgz" ]; then
    echo "Packaging $chartdir..."
    helm package -u -d docs "$chartdir"
  else 
    echo "Skipping $chartdir..."
  fi
done

echo "Generating repo index..."
helm repo index --url https://realm.github.io/charts --merge docs/index.yaml docs
