include_attribute 'smartstack::ports'
include_attribute 'smartstack::services'

default.smartstack.user = 'smartstack'
default.smartstack.home = '/opt/smartstack'
default.smartstack.gem_home = File.join(node.smartstack.home, '.gem')
default.smartstack.jar_source = "https://airbnb-public.s3.amazonaws.com/smartstack"
default.smartstack.ruby = '2.1.1'

# you should override this in your environment with the real cluster
default.zookeeper.smartstack_cluster = []

# Edit /etc/sudoers so that we can actually call gems & bundler with sudo
node.default['authorization']['sudo']['sudoers_default'] = [
    '!visiblepw',
    'env_reset',
    'env_keep =  "PATH COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS"',
    'env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"',
    'env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"',
    'env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"',
    'env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"',
    'env_keep += "HOME"',
    'always_set_home'
]
