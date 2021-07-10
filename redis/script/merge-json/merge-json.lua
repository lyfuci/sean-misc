-- KEYS[1] 是存储json的key
-- ARGV[1] 是被存储的json
local exist = redis.call('EXISTS',KEYS[1])
if (exist==1) then
    local tempKey = KEYS[1]..':temp'
    redis.call('JSON.SET',tempKey,'.',ARGV[1])
    local tempKeys = redis.call('JSON.OBJKEYS',tempKey)
    for k,v in pairs(tempKeys) do
        -- NOESCAPE 解决redis-json module 中文存储乱码问题
        local data = redis.call('JSON.GET',tempKey,'NOESCAPE',v)
        if(data~=nil) then
            redis.call('JSON.SET',KEYS[1],v,data)
        end
    end
    redis.call('DEL',tempKey)
elseif (exist==0) then
    redis.call('JSON.SET',KEYS[1],'.',ARGV[1])
end