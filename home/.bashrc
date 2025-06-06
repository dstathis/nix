# Source custom bashrc
if [ ! -z "$(\ls ~/.bashrc.d)" ]; then
	for f in ~/.bashrc.d/*; do
		. ${f}
	done
fi

# Import all aliases from the aliases.d folder
if [ ! -z "$(\ls ~/.aliases.d)" ]; then
	for f in ~/.aliases.d/*; do
		. ${f}
	done
fi
