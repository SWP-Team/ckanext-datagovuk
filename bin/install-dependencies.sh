#! /bin/bash

pip=${1-'/usr/bin/env pip'}

ckan_harvest_fork='alphagov'
ckan_harvest_sha='f52605c9a4f8ccaa0f5e83937c59ce9bf58cbc06'

ckan_dcat_fork='alphagov'
ckan_dcat_sha='be3b809fa7431c8d81508c01853e81ce6a5dfd84'

ckan_spatial_fork='alphagov'
ckan_spatial_sha='433c7f2a4ba0b05871fe8bbc9b0518aa594f392d'

# ckan 2.9.3 - alphagov/ckan/commits/fix-user-security
ckan_sha='885f9e0b668e3496a8f2c0c0a9f1cb59bf810e16'
ckan_fork='alphagov'

pycsw_tag='2.4.0'

pipopt='--exists-action=b --force-reinstall'

$pip install $pipopt -U numpy==1.16.4 wheel==0.37.0

$pip uninstall -y enum34

# needed for harvester run-test to target harvest sources
$pip install $pipopt -U factory-boy==2.12.0 mock==2.0.0 pytest==4.6.5

$pip install $pipopt -U $(curl -s https://raw.githubusercontent.com/$ckan_fork/ckan/$ckan_sha/requirement-setuptools.txt)
$pip install $pipopt -r https://raw.githubusercontent.com/$ckan_fork/ckan/$ckan_sha/requirements.txt
$pip install $pipopt -Ue "git+https://github.com/$ckan_fork/ckan.git@$ckan_sha#egg=ckan"

$pip install $pipopt -U $(curl -s https://raw.githubusercontent.com/$ckan_harvest_fork/ckanext-harvest/$ckan_harvest_sha/pip-requirements.txt)
$pip install $pipopt -U "git+https://github.com/$ckan_harvest_fork/ckanext-harvest.git@$ckan_harvest_sha#egg=ckanext-harvest"

$pip install $pipopt -U $(curl -s https://raw.githubusercontent.com/$ckan_dcat_fork/ckanext-dcat/$ckan_dcat_sha/requirements.txt)
$pip install $pipopt -U "git+https://github.com/$ckan_dcat_fork/ckanext-dcat.git@$ckan_dcat_sha#egg=ckanext-dcat"

$pip install $pipopt -U $(curl -s https://raw.githubusercontent.com/geopython/pycsw.git/$pycsw_tag/requirements.txt)
$pip install $pipopt -Ue "git+https://github.com/geopython/pycsw.git@$pycsw_tag#egg=pycsw"

pycsw_src="$(/usr/bin/env python -m site | grep pycsw | sed "s:[ |,|']::g")"
(cd $pycsw_src && /usr/bin/env python setup.py build)
$pip install $pipopt -e .

$pip install $pipopt -U $(curl -s https://raw.githubusercontent.com/$ckan_spatial_fork/ckanext-spatial/$ckan_spatial_sha/pip-requirements.txt)
$pip install $pipopt -U "git+https://github.com/$ckan_spatial_fork/ckanext-spatial.git@$ckan_spatial_sha#egg=ckanext-spatial"

$pip install $pipopt -U cryptography==2.8

$pip install $pipopt -r requirements.txt

$pip install $pipopt -U pyyaml==5.3.1
