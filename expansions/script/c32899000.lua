--- @title 七片蓝(上级召唤、反转召唤、通常召唤)
--- 画师个人官网：http://www.nanahira.com/
--- dimension-zero背景设定：http://dimension-zero.com/kiwoku/
--- @author 神鹰(455168247@qq.com)
--- @date 2018-2-10 00:30:05

xpcall(function() require("expansions/script/c32800000") end, function() require("script/c32800000") end)
local cm = orion

----------------------------------------------------------------------------------------------------
---------------------------------------------- 过滤器 ----------------------------------------------
----------------------------------------------------------------------------------------------------

--- 是否为七片蓝系列
function cm.isNanahira(c)
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
    return mt and mt.orion_name_with_nanahira
end

--- 是否为正面表示的七片蓝
function cm.isNanahiraFaceUp(c)
    return cm.isNanahira(c) and c:IsFaceup()
end

--- 是否为可被检索的七片蓝
function cm.canNanahiraSearch(c)
    return cm.isNanahira(c) and c:IsAbleToHand()
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 注册效果 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 零维灵摆通用检索效果
function cm.registerDimensionZeroSearch(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32899001, 0))
    e1:SetCategory(CATEGORY_DESTROY + CATEGORY_TOHAND + CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, 32899000)
    e1:SetCondition(cm.conditionAnotherNanahiraPendulum)
    e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
        if chk == 0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(cm.canNanahiraSearch, tp, LOCATION_DECK, 0, 1, nil) end
        Duel.SetOperationInfo(0, CATEGORY_DESTROY, e:GetHandler(), 1, 0, 0)
        Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
    end)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        if not c:IsRelateToEffect(e) or Duel.Destroy(c, REASON_EFFECT) == 0 then return end
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
        local g = Duel.SelectMatchingCard(tp, cm.canNanahiraSearch, tp, LOCATION_DECK, 0, 1, 1, nil)
        if g:GetCount() > 0 then
            Duel.SendtoHand(g, nil, REASON_EFFECT)
            Duel.ConfirmCards(1 - tp, g)
        end
    end)
    c:RegisterEffect(e1)
end

--- 零维为上级召唤而解放附加效果
-- @Card c 这张卡
-- @Effect ... 多个为目标附加的效果
function cm.registerDimensionZeroBeMaterial(c, ...)
    local arg = { ... }
    local m = c:GetCode()
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m, 2))
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_BE_PRE_MATERIAL)
    e1:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        local rc = e:GetHandler():GetReasonCard()
        return r == REASON_SUMMON and rc:IsFaceup()
    end)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        local rc = c:GetReasonCard()
        for k, v in pairs(arg) do
            rc:RegisterEffect(v)
        end
    end)
    c:RegisterEffect(e1)
end

--- 零维从额外卡组回手卡并上级召唤
function cm.registerDimensionZeroSummonFromExtra(c)
    local m = c:GetCode()
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m, 3))
    e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetHintTiming(0, 0x1c0 + TIMING_MAIN_END)
    e1:SetCountLimit(1, m + 100)
    e1:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        local ph = Duel.GetCurrentPhase()
        return (ph == PHASE_MAIN1 or ph == PHASE_MAIN2)
    end)
    e1:SetTarget(cm.targetNanahiraSummonTribute)
    e1:SetOperation(cm.operationNanahiraSummonAdvance)
    c:RegisterEffect(e1)
end

--- 零维回卡组副作用
function cm.registerDimensionZeroToDeck(c)
    local m = c:GetCode()
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m, 2))
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_PREDRAW)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        return Duel.GetTurnPlayer() == tp and Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) > 0 and Duel.GetDrawCount(tp) > 0
    end)
    e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
        if chk == 0 then return true end
        local dt = Duel.GetDrawCount(tp)
        if dt ~= 0 then
            _replace_count = 0
            _replace_max = dt
            local e1 = Effect.CreateEffect(e:GetHandler())
            e1:SetDescription(aux.Stringid(m, 2))
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_DRAW_COUNT)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetReset(RESET_PHASE + PHASE_DRAW)
            e1:SetTargetRange(1, 0)
            e1:SetValue(0)
            Duel.RegisterEffect(e1, tp)
        end
        Duel.SetOperationInfo(0, CATEGORY_TODECK, e:GetHandler(), 1, 0, 0)
    end)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        _replace_count = _replace_count + 1
        if _replace_count > _replace_max or not e:GetHandler():IsRelateToEffect(e) then return end
        local c = e:GetHandler()
        if c:IsRelateToEffect(e) then
            Duel.SendtoDeck(c, nil, 2, REASON_EFFECT)
        end
    end)
    c:RegisterEffect(e1)
end

--- 亡者十字里侧表示怪兽免疫效果
function cm.registerDeadMansCrossImmune(c)
    local tp = c:GetOwner()
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_IMMUNE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e1:SetTargetRange(LOCATION_MZONE, 0)
    e1:SetTarget(function(e, c)
        return c:IsFacedown()
    end)
    e1:SetValue(cm.isOpponent)
    e1:SetReset(RESET_EVENT + 0x1fe0000 + RESET_PHASE + PHASE_END + RESET_OPPO_TURN)
    Duel.RegisterEffect(e1, tp)
end

--- 亡者十字通用盖放效果
function cm.registerDeadMansCrossFaceDown(c)
    local e1
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_DECREASE_TRIBUTE_SET)
    e2:SetValue(0x20002)
    e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32899010, 2))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
        local c = e:GetHandler()
        if chk == 0 then
            return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and c:IsMSetable(true, e2, 0)
        end
        Duel.SetOperationInfo(0, CATEGORY_SUMMON, c, 1, 0, 0)
    end)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        if not c:IsRelateToEffect(e) then return end
        Duel.MSet(tp, c, true, e2, 0)
        cm.shuffleMonsterFaceDown(tp)
        cm.registerDeadMansCrossImmune(c)
    end)
    c:RegisterEffect(e1)
    e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32899010, 2))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCategory(CATEGORY_POSITION)
    e1:SetTarget(function(e, tp, eg, ep, ev, re, r, rp, chk)
        local c = e:GetHandler()
        if chk == 0 then return c:IsCanTurnSet() end
        Duel.SetOperationInfo(0, CATEGORY_POSITION, c, 1, 0, 0)
    end)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local c = e:GetHandler()
        if not c:IsRelateToEffect(e) then return end
        if c:IsFaceup() then
            Duel.ChangePosition(c, POS_FACEDOWN_DEFENSE)
        end
        cm.shuffleMonsterFaceDown(tp)
        cm.registerDeadMansCrossImmune(c)
    end)
    c:RegisterEffect(e1)
end

--- Vanguard G通召不会被战斗破坏、战斗伤害由对方代受
function cm.registerVanguardGSummonNormal(c)
    local e1 = cm.createEffectIndestructable(c)
    e1:SetCondition(cm.isSummonNormal)
    c:RegisterEffect(e1)
    e1 = cm.createEffectReflectDamage(c)
    e1:SetCondition(cm.isSummonNormal)
    c:RegisterEffect(e1)
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 创建效果 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 零维灵摆破坏自己和对方
function cm.createDimensionZeroDestroy(c, dtg)
    local m = c:GetCode()
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m, 1))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1, m)
    e1:SetCondition(cm.conditionAnotherNanahira)
    e1:SetTarget(dtg)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        if not e:GetHandler():IsRelateToEffect(e) then return end
        local tc = Duel.GetFirstTarget()
        if tc:IsRelateToEffect(e) then
            Duel.Destroy(tc, REASON_EFFECT)
            Duel.Destroy(e:GetHandler(), REASON_EFFECT)
        end
    end)
    return e1
end

--- 零维为上级召唤而解放的结束阶段
function cm.createDimensionZeroBeMaterialEndTurn(c, etg, eop)
    local m = c:GetCode()
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m, 3))
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_RELEASE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP + EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1, m + 100)
    e1:SetCondition(function(e, tp, eg, ep, ev, re, r, rp)
        return e:GetHandler():IsReason(REASON_SUMMON)
    end)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp)
        local e2 = Effect.CreateEffect(e:GetHandler())
        e2:SetDescription(aux.Stringid(m, 3))
        e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_PHASE + PHASE_END)
        e2:SetReset(RESET_PHASE + PHASE_END)
        e2:SetCountLimit(1)
        e2:SetTarget(etg)
        e2:SetOperation(eop)
        Duel.RegisterEffect(e2, tp)
    end)
    return e1
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 发动条件 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 场上有其他表侧表示的七片蓝卡
function cm.conditionAnotherNanahira(e, tp, eg, ep, ev, re, r, rp)
    return Duel.IsExistingMatchingCard(cm.isNanahiraFaceUp, e:GetHandlerPlayer(), LOCATION_ONFIELD, 0, 1, e:GetHandler())
end

--- 灵摆另一侧有七片蓝
function cm.conditionAnotherNanahiraPendulum(e, tp, eg, ep, ev, re, r, rp)
    return Duel.IsExistingMatchingCard(cm.isNanahira, tp, LOCATION_PZONE, 0, 1, e:GetHandler())
end


----------------------------------------------------------------------------------------------------
--------------------------------------------- 目标选择 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 上级召唤祭品
function cm.targetNanahiraSummonTribute(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    local c = e:GetHandler()
    local lv = c:GetLevel()
    if lv < 5 then return end
    local ct = 1
    if lv > 6 then ct = 2 end
    if chk == 0 then return Duel.CheckTribute(c, ct) and c:IsAbleToHand() end
    Duel.SetOperationInfo(0, CATEGORY_TOHAND, c, 1, tp, LOCATION_EXTRA)
    Duel.SetOperationInfo(0, CATEGORY_SUMMON, c, 1, 0, 0)
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 效果内容 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 回手并上级召唤
function cm.operationNanahiraSummonAdvance(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SendtoHand(c, nil, REASON_EFFECT)
    Duel.ConfirmCards(1 - tp, c)
    local lv = c:GetLevel()
    if lv < 5 then return end
    local ct = 1
    if lv > 6 then ct = 2 end
    if not Duel.CheckTribute(c, ct) or not c:IsSummonable(true, e) then return end
    local g = Duel.SelectTribute(tp, c, ct, ct)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
    e1:SetReset(RESET_CHAIN)
    e1:SetValue(SUMMON_TYPE_ADVANCE)
    e1:SetCondition(aux.TRUE)
    e1:SetOperation(function(e, tp, eg, ep, ev, re, r, rp, c)
        c:SetMaterial(g)
        Duel.Release(g, REASON_SUMMON + REASON_MATERIAL)
    end)
    c:RegisterEffect(e1, true)
    Duel.Summon(tp, c, true, nil)
end

