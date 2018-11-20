#!/bin/bash

# list
function data_bag_list(){
    Q_data_bags_list="select name from data_bags;"
    sudo su - opscode-pgsql -c "psql opscode_chef -tAc '$Q_data_bags_list'"     
}

# item name
function Q_item_name() {
    item=$1
    echo "select item_name from data_bag_items where data_bag_name='$item';"
}

function get_data_bag_items() {
    databag=$1
    sudo su - opscode-pgsql -c "psql opscode_chef -tAc \"$(Q_item_name $databag)\""
}

# get data bag item decrypted
function Q_databag_item() {
    databag=$1
    item=$2
    echo "select (gunzip(serialized_object)::json) from data_bag_items where data_bag_name='$databag' and item_name='$item';"
}

function get_data_bag() {
    databag=$1
    item=$2
    sudo su - opscode-pgsql -c "psql opscode_chef -tAc \"$(Q_databag_item $databag $item)\""
}

# save json
function save_all() {
    data_bag_list | while read databag ;do
        echo "# databag: $databag"
        mkdir -p $databag
        get_data_bag_items $databag | while read item;do
            get_data_bag $databag $item > $databag/$item.json
        done
    done
}

save_all