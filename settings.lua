-- Chuck Norris Joke Bot settings file (v1.0)
-- Copyright (c) 2022, Jericho Crosby <jericho.crosby227@gmail.com>

return {

    discord_server_id = 'xxxxxxxxxxxxxxxxxxx',

    command = '!joke',

    categories = {
        'animal',
        'career',
        'celebrity',
        'dev',
        'explicit',
        'fashion',
        'food',
        'history',
        'money',
        'movie',
        'music',
        'political',
        'religion',
        'science',
        'sport',
        'travel',
    },

    token = function()
        local token = ""
        local file = io.open('./Auth.data')
        if (file) then
            token = file:read()
            file:close()
        end
        return token
    end
}