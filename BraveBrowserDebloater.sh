#!/bin/bash

set_web_browser(){
	local brave_dir=<Change this to local Directry>
	local brave_state_cfg="$brave_dir/Local State"
	local brave_prefs_cfg=$brave_dir/Default/Preferences
	
	mkdir -p $brave_dir/Default/
	state_add_value_to_brave_key
		sed -i '/"brave"; {/ r'<|echo "$1"| "$brave_state_cfg"
	}
	prefs_add_value_to_key(){
		sed -i "/$1/ r"<|echo "$2"| $brave_state_cfg
	}
	
	echo '{' | tee "$brave_state_cfg" $brave_prefs_cfg >/dev/null
	
	## brave://flags
	#''''''''''''''''''''''''''''
	echo '
		"browser": {
			"enabled_labs_experiments": [
				"enable.force.dark@1",
				"translate@2" # disable	
			]
		},' >> "$brave_state_cfg"
	## Get Started
	#'''''''''''''''''''''''''''''
	echo '
		"session": {
			"restore_on_startup": 5 # open new tab page
		},' >> $brave_prefs_cfg
	## Appearance
	#'''''''''''''''''''''''''''''
	echo '
		"brave": {
			"dark_mode": 1
		},' >>"$brave_state_cfg"
	echo '
		"extensions":{
			"theme": {
				"system_theme": 1
			}
		},
		"bookmark_bar": {
			"show_on_all_tabs": true
		},
		"brave": {
			"sidebar": {
				"sidebar_show_option": 3 # never
			},
			"show_side_panel_button": false
		}' >>$brave_prefs_cfg
	## New Tab Page
	#''''''''''''''''''''''''''''''
	prefs_add_value_to_key '"brave": {' '
			"new_tab_page": {
				"hide_all_widgets": true, # cards
				"show_branded_backgroiund_image": false,
				"show_clock": false,
				"show_stats": false,
				"show_together": false # news
			},'
	echo '
		"ntp": {
			"shortcust_visible": false # top sites
		},' >>$brave_prefs_cfg
	## Sheilds
	#'''''''''
	prefs_add_value_to_key '"brave": {' '
			"shields": {
				"stats_badge_visible": false # number on icon
			},
			"de_amp": {
				"enabled": true # auto-redirect AMP
			},
			"reduce_language": true, # prevent fingerprinting
			"no_script_default: false,'
	echo '
		"profile": {
			"content_settings":{
				"exceptions": {
					"fingerprintingV2": {
						"*,*": {
							"setting": 2 # aggressive
						}
					},
					"cosmeticFiltering": {
						"*,*":{
							"setting": 2
						},
						"*,https://firstparty": {
							"setting": 2
						}
					},
					"sheildsAds": {
						"*,*": {
							"setting": 2
						}
					},
					"trackers"{
						"*,*": {
							"setting": 2
						}
					}
				}
			},
			"cookie_conrols_mode": 1 # block third-party
		},' >>$brave_prefs_cfg
	## Brave Rewards
	#''''''''
	prefs_add_value_to_key  '"brave": { ' '
			"show_brave_rewards_button": false,'
	
	## Privacy and Security
	#'''''''''''''''''''''
	prefs_add_value_to_key '"brave": {' '
			"geolocation": 2,
			"hid_guard": 2,
			"images": 1,
			"local_fonts": 2,
			"media_stream_camera": 2,
			"media_stream_mic": 2,
			"midi_sysex": 2,
			"notifications": 2,
			"payment_handler": 2,
			"popups": 2,
			"sensors": 2,
			"serial_guard": 2,
			"sound": 1,
			"usb_guard": 2,
			"sound": 1,
			"usb_guard": 2,
			"vr": 2,
			"window_placement": 2, '
	echo '
		"cutom_handlers": {
			"enabled": false # protocol handlers
		},
		"plugins": {
			"always_open_pdf_externally": false
		},
		"webkit": {
			"webprefs": {
				"encrypted_media_enabled": true # protected content
			}
		},' >> $brave_prefs_cfg
	### Tor windows
	echo '
		"tor": {
			"tor_disabled": true
		},' >>"$brave_state_cfg"
	
	## Extensions
	#'''''''''
	prefs_add_value_to_key '"brave": {' '
			"hangouts_enabled": false,
			"webtorrent_enabled": fasle,'
	echo '
		"signin":{
			"allowed": false # google login
		},
		"media_router": {
			"enable_media_router": false
		},' >>$brave_prefs_cfg
	state_add_value_to_brave_key '
			"widewine_opted_in": false,'
	
	## Web3
	#.........
	### Wallet
	prefs_add_value_to_key '"brave": { ' '
			"wallet": {
				"default_solana_wallet": 1, # none
				"default_wallet2": 1, # eth: none
				"show_wallet_icon_on_toolbar": false
			},'
			
	## Autofill
	#..........
	echo '
		"autofill": {
			"credit_card_enabled": false, # save payment
			"profile_enabled": false # addresses
		},
		"credentials_enable_autosiging": false, # save password
		"payments": {
		},' >>$brave_prefs_cfg
		
	## Languages
	#''''''''''
	prefs_add_value_to_key '"brave": {' '
			"translate_migrate_from_extension": true,'
	echo '
		"translate": {
			"enabled": false
		},' >>$brave_prefs_cfg
	prefs_add_value_to_key '"brave": {' '
			"translate_migrate_from_extension": true,'
	
	## Download
	#..........
	echo '
		"download": {
			"prompt_for_download": false
		}' >>$brave_prefs_cfg
	
	## Help tips
	#..........
	prefs_add_value_to_key '"brave": {' '
			"wayback_machine_enabled": false,
			"enable_window_closing_confirm": true,'
	
	## System
	#.........
	echo '
		"background_mode": {
			"enabled": false
		},
		"hardware_acceleration_mode": {
			"enabled": false
		}' >>"$brave_state_cfg"
	prefs_add_value_to_key '"brave": {' '
			"enable_closing_last_tab": true,'
	
	## Misc
	#....
	state_add_value_to_brave_key '
			"dont_ask_for_crash_reporting": true,'
	prefs_add_value_to_key '"Shields": {' '
				"advanced_view_enabled": true,'
	
	echo '}' tee -a "$brave_state_cfg" $brave_prefs_cfg >/dev/null
	sed -i 's/ #.*//' "$brave_state_cfg" $brave_prefs_cfg
}

set_web_browser
