GAM Master Script

## REQUIREMENTS

- Super Admin rights in G-Suite
- GAM installed on your machine (https://github.com/jay0lee/GAM/wiki)
- alias created for `gam` in your enviornment 

## USAGE 

```shell
./gamdaddy <argument> <email>
```

## Available Commands

		
```
create-user <email> <firstname> <lastname>
delete-user <email>
password <email>
backupcodes <email>
add-group <email> <group>
remove-group <email> <group>
pass-back <email> Changes password to default password and generates new backupcodes
create-group <email> <group name> PUT GROUP NAME IN QUOTES
export-group <groupname>
git-invite <github username>
term-user <email>
```
