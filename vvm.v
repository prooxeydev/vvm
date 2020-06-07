module main

import installer
import os

const (
	help = 'VVM is a version manager for V written in V

Usage:
	vvm <command> <args>

Commands:
	help			Shows the help page

	list [--local]		Lists all available versions | --local shows a list of all installed V versions
	install	<version>	Install a version to disk
	remove <version>	Removes a version from disk
	use	<version>	Use a installed version'
)

fn main() {
	args := os.args[1..]
	home := os.home_dir()
	mut path := '${home}vvm'
	suffix := os.user_os()

	if !os.exists(path) {
		os.mkdir(path) or { panic(err) }
	}

	if args.len > 0 && args[0] != 'help' {
		releases := installer.get_releases() or { panic(err) }
		match args[0] {
			'list' {
				if args.len == 1 {
					installer.print_releases(releases)
				} else {
					if args[1] == '--local' {
						content := os.ls(path) or { panic(err) }
						println(content.len)
						/*for file in content {
							println(file)
						}*/
					}
				}
			}
			'install' {
				if args.len > 1 {
					version := args[1]
					if releases.contains(version) {
						installer.install(releases.get(version), path, suffix)
					} else {
						println('Unknown version')
						return
					}
				} else {
					println('Arguments missing')
					return
				}
			}
			else {}
		}
	} else {
		println(help)
	}


}

/*

*/