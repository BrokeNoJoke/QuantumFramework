const fs = require('fs')
let path = GetResourcePath(GetCurrentResourceName()) + `/config/config.lua`

on('NAT2K15:PREPARECONFIG', function(callback) {
    fs.readFile(`${path}`, 'utf8', function(err, data) {
        callback(data)
    })
});

on('NAT2K15:SAVECONFIGPASSED', function(data) {
    if(!data.config) {
        console.log(`^1[ERROR] FiveM Framework^7: No data passed to save config!`)
    } else {
        fs.mkdir(GetResourcePath(GetCurrentResourceName()) + '/config/backup', function(error) {
            let check = true
            if(error) {
                if(error.code == 'EEXIST') {
                    check = true
                } else {
                    console.log(`Error creating backup folder: ${error}`)
                    check = false
                }
            } 
            if(check) {
                fs.copyFile(`${path}`, GetResourcePath(GetCurrentResourceName()) + `/config/backup/config-backup.lua`, function(err) {
                    if(err) {
                        console.log(`Error moving config file to backup: ${err}`)
                    } else {
                        fs.writeFile(`${path}`, data.config, function(err2, data) {
                            if (err2) {
                                console.log(`Error saving config: ${err2}`)
                            } else {
                                console.log(`^1FiveM Framework^7: Config saved!\nBackup has been created in ^3${GetResourcePath(GetCurrentResourceName())}/config/backup^0`)
                            }
                        })
                    }
                })
            }
        })
    }    
})

on('NAT2K15:UpdateConfig', function(config, oldVersion, newVersion, cb) {
    const configPath = GetResourcePath(GetCurrentResourceName()) + '/config/config.lua';

    fs.readFile(configPath, 'utf8', function(err, data) {
        if (err) {
            console.log(`Error reading config: ${err}`);
            return cb(err);
        }

        let regex = new RegExp(`(version\\s*=\\s*")${oldVersion}(")`, 'g');
        let newConfig = data.replace(regex, `$1${newVersion}$2`);

        fs.writeFile(configPath, newConfig, function(err) {
            if (err) {
                console.log(`Error saving config: ${err}`);
                return cb(err);
            }

            console.log(`^1FiveM Framework^7: Updated config version to ^3${newVersion}^0`);


            let formattedConfig = config ? '\n' + config.trim() + '\n\n' : "";

            fs.appendFile(configPath, formattedConfig, function(err) {
                if (err) {
                    console.log(`Error appending to config: ${err}`);
                    return cb(err);
                }

                console.log(`^1FiveM Framework^7: Config updated and saved!`);
                fs.readFile(configPath, 'utf8', function(err, newConfigData) {
                    if (err) {
                        console.log(`Error reading config: ${err}`);
                        return cb(err);
                    }
                    cb(null, newConfigData);
                })
            });
        });
    });
});



