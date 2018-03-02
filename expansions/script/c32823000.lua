--- @title 图腾（范围效果和继承能力）
--- @author 神鹰(455168247@qq.com)
--- @date 2018-2-3 20:13:06

xpcall(function() require("expansions/script/c32800000") end, function() require("script/c32800000") end)
local cm = orion
cm.BASE_TOTEM_EARTH = 32823001 -- 石爪图腾
cm.BASE_TOTEM_AIR = 32823002 -- 空气图腾
cm.BASE_TOTEM_WATER = 32823003 -- 治疗图腾
cm.BASE_TOTEM_FIRE = 32823004 -- 灼热图腾
-- 基础图腾表
cm.BASE_TOTEMS = {
    [cm.BASE_TOTEM_EARTH] = {
        atk = 0,
        def = 2000,
        level = 1,
        effect = function(c)
            local e1 = cm.createEffectCannotSelectBattleTarget(c)
            e1:SetValue(cm.isNearbyNotSelf)
            c:RegisterEffect(e1)
            c:RegisterEffect(cm.createEffectIndestructableCount(c))
            -- give effect
            e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_BE_PRE_MATERIAL)
            e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
                local c = e:GetHandler()
                local rc = c:GetReasonCard()
                local e2 = cm.createEffectCannotSelectBattleTarget(c)
                e2:SetDescription(aux.Stringid(cm.BASE_TOTEM_EARTH, 0))
                e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                e2:SetValue(cm.isNearbyNotSelf)
                e2:SetReset(RESET_EVENT + 0x1fe0000) -- 理论上去墓地、除外、回手牌、回卡组、从场上移动到其他位置都不重置，但实测能重置
                rc:RegisterEffect(e2)
                e2 = cm.createEffectIndestructableCount(rc)
                e2:SetReset(RESET_EVENT + 0x1fe0000)
                rc:RegisterEffect(e2)
                local e3 = e1:Clone()
                e3:SetReset(RESET_EVENT + 0x1120000)
                rc:RegisterEffect(e3)
                -- TODO: 复制效果如何加提示文本？
                -- rc:CopyEffect(m, RESET_EVENT + 0x1120000) -- 只能复制某张卡片的效果
            end)
            c:RegisterEffect(e1)
        end
    },
    [cm.BASE_TOTEM_AIR] = {
        atk = 0,
        def = 2000,
        level = 1,
        effect = function(c)
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetRange(LOCATION_MZONE)
            e1:SetTargetRange(0, LOCATION_MZONE)
            e1:SetValue(function(e, c)
                local eseq = e:GetHandler():GetSequence()
                local seq = c:GetSequence()
                local switch = {
                    [0] = 1000,
                    [1] = 750,
                    [2] = 500,
                    [3] = 250,
                    [4] = 0
                }
                return -switch[cm.getOpponentMonsterColumnDistance(eseq, seq)]
            end)
            c:RegisterEffect(e1)
            -- give effect
            local e2 = Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
            e2:SetCode(EVENT_BE_PRE_MATERIAL)
            e2:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
                local c = e:GetHandler()
                local rc = c:GetReasonCard()
                local e3 = e1:Clone()
                e3:SetDescription(aux.Stringid(cm.BASE_TOTEM_AIR, 0))
                e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                e3:SetReset(RESET_EVENT + 0x1fe0000)
                rc:RegisterEffect(e3)
                local e4 = e2:Clone()
                e4:SetReset(RESET_EVENT + 0x1120000)
                rc:RegisterEffect(e4)
            end)
            c:RegisterEffect(e2)
        end
    },
    [cm.BASE_TOTEM_WATER] = {
        atk = 0,
        def = 2000,
        level = 1,
        effect = function(c)
            local e1 = Effect.CreateEffect(c)
            e1:SetCategory(CATEGORY_RECOVER)
            e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
            e1:SetCode(EVENT_PHASE + PHASE_END)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetRange(LOCATION_MZONE)
            e1:SetCountLimit(1)
            e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
                local c = e:GetHandler()
                local count = cm.getNearbyMonsterColumnGroup(c, tp, 0, 1):GetCount()
                if chk == 0 then
                    return count > 0
                end
                if count < 1 then
                    return false
                end
                Duel.SetTargetPlayer(tp)
                local number = 500 * count
                Duel.SetTargetParam(number)
                Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, number)
            end)
            e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
                local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
                Duel.Recover(p, d, REASON_EFFECT)
            end)
            c:RegisterEffect(e1)
            -- give effect
            local e2 = Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
            e2:SetCode(EVENT_BE_PRE_MATERIAL)
            e2:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
                local c = e:GetHandler()
                local rc = c:GetReasonCard()
                local e3 = e1:Clone()
                e3:SetDescription(aux.Stringid(cm.BASE_TOTEM_WATER, 0))
                e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                e3:SetReset(RESET_EVENT + 0x1fe0000)
                rc:RegisterEffect(e3)
                local e4 = e2:Clone()
                e4:SetReset(RESET_EVENT + 0x1120000)
                rc:RegisterEffect(e4)
            end)
            c:RegisterEffect(e2)
        end
    },
    [cm.BASE_TOTEM_FIRE] = {
        atk = 0,
        def = 0,
        level = 1,
        effect = function(c)
            c:RegisterEffect(cm.creatEffectAtkUp(c))
            c:RegisterEffect(cm.creatEffectDefUp(c))
            -- give effect
            local e1 = Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_BE_PRE_MATERIAL)
            e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
                local c = e:GetHandler()
                local rc = c:GetReasonCard()
                local e2 = cm.creatEffectAtkUp(rc)
                e2:SetDescription(aux.Stringid(cm.BASE_TOTEM_FIRE, 0))
                e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
                e2:SetReset(RESET_EVENT + 0x1fe0000)
                rc:RegisterEffect(e2)
                e2 = cm.creatEffectDefUp(rc)
                e2:SetReset(RESET_EVENT + 0x1fe0000)
                rc:RegisterEffect(e2)
                local e3 = e1:Clone()
                e3:SetReset(RESET_EVENT + 0x1120000)
                rc:RegisterEffect(e3)
            end)
            c:RegisterEffect(e1)
        end
    }
}

----------------------------------------------------------------------------------------------------
---------------------------------------------- 过滤器 ----------------------------------------------
----------------------------------------------------------------------------------------------------

--- 是否为图腾系列
function cm.isTotem(c)
    for index, value in pairs(cm["BASE_TOTEMS"]) do
        if (c:GetCode() == index) then
            return true
        end
    end
    local code = c:GetCode()
    local mt = _G["c" .. code]
    if not mt then
        _G["c" .. code] = {}
        if pcall(function() dofile("expansions/script/c" .. code .. ".lua") end) or pcall(function() dofile("script/c" .. code .. ".lua") end) then
            mt = _G["c" .. code]
            _G["c" .. code] = nil
        else
            _G["c" .. code] = nil
            return false
        end
    end
    return mt and mt.orion_name_with_totem
end

--- 是否能特殊召唤且与场上图腾不重复
function cm.canSummonAndUniqueTotem(e, tp, index, value)
    return cm.canSummonAndUnique(e, tp, index, value["atk"], value["def"], value["level"])
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 创建效果 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 生成随机特召图腾效果，默认为启动效果
function cm.createEffectSummonToken(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
        if chk == 0 then
            if (Duel.GetLocationCount(tp, LOCATION_MZONE) < 1) then
                return false
            end
            for index, value in pairs(cm["BASE_TOTEMS"]) do
                if (cm.canSummonAndUniqueTotem(e, tp, index, value)) then
                    return true
                end
            end
            return false
        end
        Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, 0, 0)
        Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 1, 0, 0)
    end)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local choices = {} -- 与场上不重复的图腾
        local count = 0 -- choices的总数
        for index, value in pairs(cm["BASE_TOTEMS"]) do
            if (cm.canSummonAndUniqueTotem(e, tp, index, value)) then
                choices[count] = index
                count = count + 1
            end
        end
        if count == 0 then
            return false
        end
        local choice = cm.randomSimple(tp, 0, count - 1)
        local code = choices[choice]
        Duel.Hint(HINT_CARD, 0, code)
        local token = Duel.CreateToken(tp, code)
        cm["BASE_TOTEMS"][code]["effect"](token)
        Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP)
        Duel.SpecialSummonComplete()
    end)
    return e1
end

--- 攻击力上升1000
function cm.creatEffectAtkUp(c)
    return orion.createEffectSingle(c, EFFECT_UPDATE_ATTACK, 1000)
end

--- 守备力上升1000
function cm.creatEffectDefUp(c)
    return orion.createEffectSingle(c, EFFECT_UPDATE_DEFENSE, 1000)
end