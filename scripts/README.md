# Bash aliases

Change directory and run the script:
```
cd scripts
./create-aliases.sh
```

Then source the generated file:
```
source .bash_aliases_bench
```

You can add this to your .bashrc file:
```
cat >>~/.bashrc<<EOF
if [ -f ${PWD}/.bash_aliases_bench ] ; then
    . ${PWD}/.bash_aliases_bench
fi
EOF
```
