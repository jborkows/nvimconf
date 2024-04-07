local notify = require 'notify'
notify.setup {
	background_colour = '#000000',
}
notify('Hello ' .. os.getenv 'USER')
