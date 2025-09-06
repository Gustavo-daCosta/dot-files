#!/bin/zsh

if [ -n "$VIRTUAL_ENV" ]; then
	echo "You already have a virtual enviroment running, do you wanna deactivate it? [y/n] "
	read deactivate_current_venv
	deactivate_current_venv=$([[ -z "$deactivate_current_venv" || "$deactivate_current_venv" == "y" || "$deactivate_current_venv" == "Y" ]] && echo 1 || echo 0)

	if [ "$deactivate_current_venv" -eq 1 ]; then
		echo "Deactivating the currently virtual enviroment..."
		deactivate
	else
		echo "Do you want to create the virtual enviroment without activating it? [y/n] "
		read only_create_venv
		only_create_venv=$([[ -z "$only_create_venv" || "$only_create_venv" == "y" || "$only_create_venv" == "Y" ]] && echo 1 || echo 0)

		if [ "$only_create_venv" -eq 1 ]; then
			echo "Ok!"
		else
			echo "Ok! Exiting without creating the venv..."
			exit 1
		fi
	fi
fi

echo "Creating the virtual enviroment... -> .venv"
python3 -m venv .venv

if [ -z "$only_create_venv" ] || [ "$only_create_venv" -ne 1 ]; then
	echo "Activating the virtual enviroment..."
	source .venv/bin/activate
fi

if [ -f "$PWD/requirements.txt" ]; then
	echo "You already have a requirements.txt file in the current folder, do you want to install the packages? [y/n] "
	read install_packages
	install_packages=$([[ -z "$install_packages" || "$install_packages" == "y" || "$install_packages" == "Y" ]] && echo 1 || echo 0)

	if [ "$install_packages" -eq 1 ]; then
		echo "Installing packages..."
		pip install -r requirements.txt
	fi
else
	echo "The requirements.txt file was not found, do you want to create a new one? [y/n] "
	read create_requirements
	create_requirements=$([[ -z "$create_requirements" || "$create_requirements" == "y" || "$create_requirements" == "Y" ]] && echo 1 || echo 0)

	if [ "$create_requirements" -eq 1 ]; then
		echo "Creating requirements.txt file..."
		pip freeze > requirements.txt
	fi
fi

echo "All done!"
