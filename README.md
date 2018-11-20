
1.- Requerimientos

```shell

$ yum install -y gcc expat-devel git zlib-devel
$ git clone git@github.com:fiftech/chef-psql-data.git
$ cd psql-gunzip

$ make
$ sudo cp func.so `pg_config --pkglibdir`
$ sudo su - opscode-pgsql -c "psql opscode_chef"
> CREATE FUNCTION gunzip(bytea) RETURNS text
  AS 'func', 'gunzip'
  LANGUAGE C STRICT;


> select (gunzip(serialized_object)::json) from data_bag_items limit 1;

```
