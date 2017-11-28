all: prepare-repo install-deps build clean-cache update-repo

prepare-repo:
	[[ -d repo ]] || ostree init --mode=archive-z2 --repo=repo
	[[ -d repo/refs/remotes ]] || mkdir -p repo/refs/remotes && touch repo/refs/remotes/.gitkeep

install-deps:
	flatpak --user remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak --user install flathub org.gnome.Platform/x86_64/3.26 org.gnome.Sdk/x86_64/3.26

build:
	curl https://raw.githubusercontent.com/gnunn1/tilix/master/experimental/flatpak/0001-Enable-flatpak.patch -O 
	flatpak-builder --force-clean --ccache --require-changes --repo=repo \
		--subject="Nightly build of Tilix, `date`" \
		${EXPORT_ARGS} app com.gexperts.Tilix.json

clean-cache:
	rm -rf .flatpak-builder/build

update-repo:
	flatpak build-update-repo --prune --prune-depth=20 --generate-static-deltas repo
	echo 'gpg-verify-summary=false' >> repo/config
