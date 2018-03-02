--- @title 基础类库
--- @author 神鹰(455168247@qq.com)
--- @date 2018-2-4 14:07:44

orion = orion or {}
orion.SALT = 455168247 -- 自用盐值
orion.seed = 0 -- 随机种子
local cm = orion

----------------------------------------------------------------------------------------------------
---------------------------------------------- 过滤器 ----------------------------------------------
----------------------------------------------------------------------------------------------------

--- 是否为对方
function cm.isOpponent(e, te)
    return e:GetHandlerPlayer() ~= te:GetHandlerPlayer()
end

--- 是否为可被融合的某种族
function cm.isFusionRace(c, type)
    return c:IsCanBeFusionMaterial() and c:IsRace(type)
end

--- 场上是否已有卡号为code的卡
function cm.isFaceUpOnField(e, code)
    return Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(code) end, e:GetHandlerPlayer(), LOCATION_ONFIELD, 0, 1, e:GetHandler())
end

--- 对方是否可被解放
function cm.isOpponentReleasable(c, tp)
    return c:IsReleasable() and Duel.GetMZoneCount(1 - tp, c, tp) > 0
end

--- 是否正面表示离场
function cm.isLeftFaceup(e)
    return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

--- 是否为上级召唤
function cm.isSummonAdvance(e)
    return cm.isSummonType(e, SUMMON_TYPE_ADVANCE)
end

--- 是否为通常召唤
function cm.isSummonNormal(e)
    return cm.isSummonType(e, SUMMON_TYPE_NORMAL)
end

--- 是否为某种召唤
function cm.isSummonType(e, type)
    return bit.band(e:GetHandler():GetSummonType(), type) == type
end

--- 是否能从某位置特殊召唤满足f的怪兽
function cm.canSummonFromLocation(e, tp, f, location)
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 and Duel.IsExistingMatchingCard(f, tp, location, 0, 1, nil, e, tp)
end

--- 是否能特殊召唤且与场上不重复
function cm.canSummonAndUnique(e, tp, code, atk, def, level)
    return Duel.IsPlayerCanSpecialSummonMonster(tp, code, 0, 0x4011, atk, def, level, RACE_PLANT, ATTRIBUTE_WIND) and not cm.isFaceUpOnField(e, code)
end

--- 是否为召唤的玩家
function cm.isSummonPlayer(c, sp)
    return c:GetSummonPlayer() == sp
end

--- 相同或相邻纵列
function cm.isNearby(e, c)
    -- 通过「治疗图腾衍生物」测试有问题，故废弃
    --return e:GetHandler():GetColumnGroup(1, 1):IsContains(c)
    local ec = e:GetHandler()
    return cm.getNearbyMonsterColumnGroup(ec, ec:GetControler(), 0, 1):IsContains(c)
end

--- 自己以外的相同或相邻纵列
function cm.isNearbyNotSelf(e, c)
    return cm.isNearby(e, c) and c ~= e:GetHandler()
end

--- 是否为魔法陷阱卡
function cm.isTypeSpellOrTrap(c)
    return c:IsType(TYPE_SPELL + TYPE_TRAP)
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 注册效果 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 注册发动时效果
function cm.registerEffectActivate(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
end

--- 自己没有怪兽时可从手牌特召
function cm.registerSpsummonSelfNoMonsterOnField(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(orion.conditionSelfNoMonsterOnField)
    c:RegisterEffect(e1)
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 创建效果 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 不会被战斗破坏
function cm.createEffectIndestructable(c)
    return cm.createEffectSingle(c, EFFECT_INDESTRUCTABLE_BATTLE, 1)
end

--- 1回合几次不会被破坏
function cm.createEffectIndestructableCount(c)
    local e1 = cm.createEffectSingle(c, EFFECT_INDESTRUCTABLE_COUNT, function(e, re, r, rp)
        return bit.band(r, REASON_BATTLE) ~= 0
    end)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetCountLimit(1)
    return e1
end

--- 反弹战斗伤害
function cm.createEffectReflectDamage(c)
    return cm.createEffectSingle(c, EFFECT_REFLECT_BATTLE_DAMAGE, 1)
end

--- 生成在怪兽区域的持续效果
function cm.createEffectSingle(c, code, value)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(code)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(value)
    return e1
end

--- 不会成为攻击目标，默认为所有队友
function cm.createEffectCannotSelectBattleTarget(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0, LOCATION_MZONE)
    e1:SetValue(orion.valueNotItself)
    return e1
end

--- 测试启动效果
function cm.createTestI(c)
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(100)
    return e1
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 发动条件 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 自己场上没有怪兽
function cm.conditionSelfNoMonsterOnField(e, c)
    if c == nil then return true end
    return Duel.GetFieldGroupCount(c:GetControler(), LOCATION_MZONE, 0) == 0
            and Duel.GetLocationCount(c:GetControler(), LOCATION_MZONE) > 0
end

--- 解放对方
function cm.conditionOpponentReleasable(e, c)
    if c == nil then return true end
    local tp = c:GetControler()
    local ft = Duel.GetLocationCount(1 - tp, LOCATION_MZONE)
    return ft > -1 and Duel.IsExistingMatchingCard(cm.isOpponentReleasable, tp, 0, LOCATION_MZONE, 1, nil, tp)
end

--- 上级召唤
function cm.conditionSummonAdvance(e, tp, eg, ep, ev, re, r, rp)
    return cm.isSummonAdvance(e)
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 发动代价 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 丢弃1张手卡
function cm.costDiscardOneCard(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil) end
    Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD)
end

--- 把这张卡除外
function cm.costRemoveItself(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():IsAbleToRemoveAsCost() end
    Duel.Hint(HINT_OPSELECTED, 1 - tp, e:GetDescription())
    Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 目标选择 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 破坏另一张卡
function cm.targetDestroyAnotherCard(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    local c = e:GetHandler()
    if chkc then return chkc:IsOnField() and c ~= chkc end
    if chk == 0 then return Duel.IsExistingTarget(nil, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, c) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g = Duel.SelectTarget(tp, nil, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, c)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

--- 上级召唤祭品
function cm.targetSummonTribute(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    local c = e:GetHandler()
    local lv = c:GetLevel()
    if lv < 5 then return end
    local ct = 1
    if lv > 6 then ct = 2 end
    if chk == 0 then return Duel.CheckTribute(c, ct) end
    Duel.SetOperationInfo(0, CATEGORY_SUMMON, c, 1, 0, 0)
end

--- 测试破坏1卡
function cm.targetTestDestroy(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsOnField() end
    if chk == 0 then return Duel.IsExistingTarget(aux.TRUE, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g = Duel.SelectTarget(tp, aux.TRUE, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, e:GetHandler())
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 效果内容 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 破坏对方所有怪兽
function cm.operationDestroyOpponentMonsterAll(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
    Duel.Destroy(g, REASON_EFFECT)
end

--- 破防目标后破坏自己
function cm.operationDestroyItselfThenAnother(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc, REASON_EFFECT)
        Duel.BreakEffect()
        Duel.Destroy(c, REASON_EFFECT)
    end
end

--- 解放对方
function cm.operationReleaseOpponent(e, tp, eg, ep, ev, re, r, rp)
    local ft = Duel.GetLocationCount(1 - tp, LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
    local g = Duel.SelectMatchingCard(tp, cm.isOpponentReleasable, tp, 0, LOCATION_MZONE, 1, 1, nil, tp)
    Duel.Release(g, REASON_COST)
end

--- 上级召唤
function cm.operationSummonAdvance(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local lv = c:GetLevel()
    if not c:IsRelateToEffect(e) then return end
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

--- 测试破坏1卡
function cm.operationTestDestroy(e, tp, eg, ep, ev, re, r, rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc, REASON_EFFECT)
        Duel.Destroy(e:GetHandler(), REASON_EFFECT)
    end
end

----------------------------------------------------------------------------------------------------
-------------------------------------------- 永续效果值 --------------------------------------------
----------------------------------------------------------------------------------------------------

--- 自己以外
function cm.valueNotItself(e, c)
    return c ~= e:GetHandler()
end

--- 不受效果影响的卡以外
function cm.valueNotImmune(e, re, tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end

--- 类机壳免疫(不受魔法·陷阱卡的效果影响，也不受原本的等级或者阶级比这张卡的等级低的怪兽发动的效果影响)
function cm.valueQliImmune(e, te)
    if te:IsActiveType(TYPE_SPELL + TYPE_TRAP) and e:GetHandler():GetControler() ~= te:GetHandler():GetControler() then return true
    else return aux.qlifilter(e, te)
    end
end

----------------------------------------------------------------------------------------------------
--------------------------------------------- 通用函数 ---------------------------------------------
----------------------------------------------------------------------------------------------------

--- 混合洗切里侧表示的怪兽
function cm.shuffleMonsterFaceDown(tp)
    local g = Duel.GetMatchingGroup(Card.IsFacedown, tp, LOCATION_MZONE, 0, nil)
    if g:GetCount() > 0 then
        Duel.ShuffleSetCard(g)
    end
end

--- 混合洗切盖放的魔陷
function cm.shuffleSpellAndTrapFaceDown(tp)
    local g = Duel.GetMatchingGroup(function(c)
        return c:IsFacedown()
    end, tp, LOCATION_SZONE, 0, nil)
    if g:GetCount() > 0 then
        Duel.ShuffleSetCard(g)
    end
end

--- 获取互相连接
-- @return Group
function cm.getLinkEachotherGroup(c)
    return c:GetLinkedGroup():Filter(function(c, mc)
        local lg = c:GetLinkedGroup()
        return lg and lg:IsContains(mc)
    end, nil, c)
end

--- 过滤Link位置
function cm.filterLinkColumn(seq)
    if seq == 5 then seq = 1 end
    if seq == 6 then seq = 3 end
    return seq
end

--- 自己两纵列的距离
function cm.getSelfMonsterColumnDistance(seq1, seq2)
    seq1 = cm.filterLinkColumn(seq1)
    seq2 = cm.filterLinkColumn(seq2)
    if seq1 > seq2 then
        return seq1 - seq2
    else
        return seq2 - seq1
    end
end

--- 双方两纵列的距离
function cm.getOpponentMonsterColumnDistance(seq1, seq2)
    seq1 = cm.filterLinkColumn(seq1)
    seq2 = cm.filterLinkColumn(seq2)
    seq2 = 4 - seq2
    if seq1 > seq2 then
        return seq1 - seq2
    else
        return seq2 - seq1
    end
end

--- 获取某张卡周围某纵列范围内的组合
-- @Card c 这张卡
-- @number tp 回合玩家
-- @number min 最小值，范围为0-4，0代表相同纵列
-- @number max 最大值，范围为0-4，0代表相同纵列
-- @return Group 符合条件的组合
function cm.getNearbyMonsterColumnGroup(c, tp, min, max)
    local seq = c:GetSequence()
    return Duel.GetMatchingGroup(function(c1)
        local tp1 = c1:GetControler()
        local seq1 = c1:GetSequence()
        local distence = 0
        if tp == tp1 then
            distence = cm.getSelfMonsterColumnDistance(seq, seq1)
        else
            distence = cm.getOpponentMonsterColumnDistance(seq, seq1)
        end
        return distence >= min and distence <= max
    end, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
end

--- 获取某玩家的某位置code之和
function cm.getPlayerLocationCodes(tp, self, opponent, max)
    local seed = 0
    local i = 0
    local count = Duel.GetFieldGroupCount(tp, self, opponent)
    Duel.GetMatchingGroup(function(c)
        if i < max and i < count then
            seed = seed + c:GetCode()
            i = i + 1
        end
    end, tp, self, opponent, nil)
    return seed
end

--- 获取双方某个位置的code之和
function cm.getLocationCodes(tp, location, max)
    return cm.getPlayerLocationCodes(tp, 0, location, max) + cm.getPlayerLocationCodes(tp, location, 0, max)
end

--- 根据卡组内容获取若干个code之和
function cm.getRandomCodes(tp)
    local seed = cm.getLocationCodes(tp, LOCATION_HAND, 5) +
            cm.getLocationCodes(tp, LOCATION_DECK, 5) +
            cm.getLocationCodes(tp, LOCATION_EXTRA, 5) +
            cm.getLocationCodes(tp, LOCATION_GRAVE, 5) +
            cm.getLocationCodes(tp, LOCATION_REMOVED, 5)
    -- 检查对方卡组最上方的卡，用新的函数统一处理，故废弃
    --if Duel.GetFieldGroupCount(tp, 0, LOCATION_DECK) > 0 then
    --	seed = seed + Duel.GetDecktopGroup(1 - tp, 1):GetFirst():GetCode()
    --end
    return tonumber(tostring(seed):reverse())
end

--- 线性同余法生成新的随机种子
function cm.ramdomLinearCongruence(seed)
    local limit = 0x7FFFFFFF
    local quotient = math.modf(seed / 127773)
    local remainder = seed % 127773
    return (16807 * remainder - 2836 * quotient) % (limit + 1)
end

--- 生成随机数
-- @number seed 随机种子
-- @number min 随机数最小值
-- @number max 随机数最大值
-- @return number 生成的随机数
-- @return number 下一个随机种子
-- @useage r, seed = orion.random(seed, 0, 3) -- 可能生成0、1、2、3，如seed初始值为32800001时结果为3
function cm.random(seed, min, max)
    cm.seed = cm.ramdomLinearCongruence(seed)
    return cm.seed % (max - min + 1) + min, cm.seed
end

--- 清空随机种子
function cm.clearRandom()
    cm.seed = 0
end

--- 生成简单的加盐随机数
function cm.randomSimple(tp, min, max)
    if (cm.seed == 0) then
        cm.seed = cm.getRandomCodes(tp) + cm.SALT
    end
    return cm.random(cm.seed, min, max)
end