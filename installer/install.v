module installer

import releases
import net.http

pub fn install(release releases.Release, path, suffix string) {
	mut asset := releases.Assets{}
	if release.assets.len > 1 {
		assets := release.assets.filter(it.name.starts_with('v'))
		if assets.len == 1 {
			asset = assets[0]
		} else if assets.len > 1 {
			op_asset := assets.filter(it.name == 'v_${suffix}.zip')
			if op_asset.len == 0 {
				println('Version $release.name doesn\'t contains v_${suffix}.zip')
			} else {
				asset = op_asset[0]
			}
		} else {
			println('Version $release.name doesn\'t have a v_*.zip')
		}
	} else {
		asset = release.assets[0]
	}

	mut request := http.new_request('get', 'https://api.github.com/repos/vlang/v/releases/assets/$asset.id', '') or { panic(err) }
	request.add_header('Accept', 'application/octet-stream')
	response := request.do() or { panic(err) }
}