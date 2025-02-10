CREATE TABLE IF NOT EXISTS characters (
  id int(11) NOT NULL AUTO_INCREMENT,
  discord varchar(50) DEFAULT NULL,
  steamid varchar(50) DEFAULT NULL,
  first_name varchar(50) DEFAULT NULL,
  last_name varchar(50) DEFAULT NULL,
  twitter_name varchar(50) DEFAULT NULL,
  dob varchar(50) DEFAULT NULL,
  gender varchar(50) DEFAULT NULL,
  dept varchar(50) DEFAULT NULL,
  level TEXT DEFAULT NULL,
  lastLoc varchar(250) DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS characters_settings (
  discord varchar(50) DEFAULT NULL,
  steamid varchar(50) DEFAULT NULL,
  dark_mode varchar(50) DEFAULT 1,
  cloud_spawning varchar(50) DEFAULT 1,
  image_slideshow varchar(50) DEFAULT 0,
  character_gardient_color varchar(50) DEFAULT '#DDADF3|#582185',
  refresh_gardient_color varchar(50) DEFAULT '#3E3BDF|#6529C5',
  settings_gardient_color varchar(50) DEFAULT '#1792DA|#49C06D',
  disconnect_gardient_color varchar(50) DEFAULT '#FF0000|#EB7F27',
  framework_side VARCHAR(50) DEFAULT 'left',
  framework_background VARCHAR(250) DEFAULT NULL,
  framework_hud TEXT DEFAULT '[]'
);

-- ALTER TABLE characters ADD COLUMN level TEXT DEFAULT NULL;
-- ALTER TABLE characters_settings ADD COLUMN framework_hud TEXT DEFAULT '[]';