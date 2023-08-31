package.cpath =  "./lib/lpeg/?.so;" .. "./lib/sproto/?.so;" .. package.cpath
package.path = "./lib/sproto/?.lua;" .. package.path
local sproto = require "sproto"
local core = require "sproto.core"

local function sproto_parse() 
    -- sproto协议
    local sp = sproto.parse [[
        .PSkillBuffEffectStat {
            entityType  1:integer 	#释放技能实体类型
            effectType	2:integer	#技能还是buff  1:技能 2:buff
            skillId		3:integer
            buffId		4:integer
            attack		5:integer(4)		#攻击
            skillEffectPct  6:integer	#技能伤害影响
            skillHurtEffectPct  7:integer(4) #伤害系数影响
            skillPvpEffectPct  8:integer(4)  #PVP系数影响
            buffEffectAttrType	9:integer 		#buff修改属性
            buffEffectAttrAddValue	10:integer(4)	#buff修改属性值
            buffEffectAttrValue	 11:integer(4)		#buff修改属性当前值
            hurt		12:integer		#技能伤害
            showEffect   13:integer     #触发类型  类型看ShowEffectType枚举
            phase		14:integer		#段数
            buffIsSelf	15:boolean	#buff是否对自己生效 false: 对敌方生效
            hitPointsCount	16:integer	#总段数
        }
        .PStats {
            stats   0:*PSkillBuffEffectStat
        }
    ]]
    return sp    
end

local function data_create()
    local stats = {}
    for i=1,1000 do
        table.insert(stats, {
            skillId = i,
            attack = 5000000000.41,
            skillEffectPct = 111 + 222 << 16 + 333 << 32,
            hurt = 1241241421,
            showEffect = 0,
            phase = 1,
        })
    end

    return {stats = stats}, "PStats"
end

local sp = sproto_parse()

collectgarbage "collect"
local count = collectgarbage "count"

local data, sprotoName = data_create()

collectgarbage "collect"
local newcount = collectgarbage "count"
print("lua table 增长内存(大概)", (newcount - count) * 1024 , "字节")

local code = sp:encode(sprotoName, data)
code = core.pack(code)
print("编码后二进制字符串占", string.len(code) , "字节")