echo "Για σου Ντήλαν"

export EDITOR=vim

# Import all aliases from the aliases.d folder
if [ ! -z "$(\ls ~/.aliases.d)" ]; then
	for f in ~/.aliases.d/*; do
		. ${f}
	done
fi
