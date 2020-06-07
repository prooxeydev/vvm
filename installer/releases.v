module installer

import net.http
import releases
import json

pub fn get_releases() ?[]releases.Release {
	response := http.get('https://api.github.com/repos/vlang/v/releases') or { panic(err) }

	if response.status_code != 200 {
		return error('Failed to connect to github')
	}

	release_list := json.decode([]releases.Release, response.text) or {
		return error('Failed to parse json')
	}

	return release_list
}

pub fn print_releases(release_list []releases.Release) {
	println('Available releases on GitHub:')
	for release in release_list {
		println('- $release.name')
	}
}

pub fn (release_list []releases.Release) contains(version string) bool {
	return release_list.filter(it.name == version).len == 1
}

pub fn (release_list []releases.Release) get(version string) releases.Release {
	return release_list.filter(it.name == version)[0]
}