--AKARI Has Arrived!
--AlphaKretin
--For Nemoma
local scard = c33700409
local id = 33700409
function scard.initial_effect(c)
    --Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(scard.regtg)
    c:RegisterEffect(e1)
    --indes
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Cannot activate
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetRange(LOCATION_FZONE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetTargetRange(1, 0)
    e3:SetValue(scard.efilter)
    c:RegisterEffect(e3)
    --Special Summon token
    local e4 = Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_TOKEN)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
    e4:SetTarget(scard.tktg)
    e4:SetOperation(scard.tkop)
    c:RegisterEffect(e4)
    --cannot special summon
    local e5 = Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetTargetRange(1, 0)
    e5:SetTarget(scard.splimit)
    c:RegisterEffect(e5)
    --cannot link material
    local e6 = Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e6:SetTargetRange(LOCATION_MZONE, LOCATION_MZONE)
    e6:SetTarget(aux.TargetBoolFunction(Card.IsCode, id + 1))
    e6:SetValue(1)
    c:RegisterEffect(e6)
    --release all
    local e7 = Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_RECOVER)
    e7:SetType(EFFECT_TYPE_TRIGGER_F + EFFECT_TYPE_SINGLE)
    e7:SetCode(EVENT_LEAVE_FIELD)
    e7:SetTarget(scard.reltg)
    e7:SetOperation(scard.relop)
    c:RegisterEffect(e7)
    if not scard.global_check then
        scard.global_check = true
        scard[0] = 0
        scard[1] = 0
        scard.release_check = false
        scard.summon_check = false
    end
end
function scard.efilter(e, re, tp)
    return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function scard.regtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return true
    end
    local c = e:GetHandler()
    --to grave
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_PHASE + PHASE_END)
    e1:SetCountLimit(1)
    e1:SetRange(LOCATION_FZONE)
    e1:SetCondition(scard.gycon)
    e1:SetOperation(scard.gyop)
    e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END + RESET_SELF_TURN, 5)
    c:SetTurnCounter(0)
    c:RegisterEffect(e1)
end
function scard.gycon(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp
end
function scard.gyop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local ct = c:GetTurnCounter()
    ct = ct + 1
    c:SetTurnCounter(ct)
    if ct == 5 then
        Duel.SendtoGrave(c, REASON_EFFECT)
    end
end
function scard.IsCanSummonAkariToken(tp)
    return Duel.IsPlayerCanSpecialSummonMonster(
        tp,
        id + 1,
        0,
        TYPE_MONSTER + TYPE_NORMAL + TYPE_TOKEN,
        1000,
        1000,
        1,
        RACE_CYBERSE,
        ATTRIBUTE_LIGHT,
        POS_FACEUP
    )
end
function scard.tktg(e, tp, eg, ep, ev, re, r, rp, chk)
    scard.summon_check = true
    if chk == 0 then
        return ((scard[tp] & 0x1) == 0 or (scard[tp] & 0x2) == 0 or (scard[tp] & 0x4) == 0 or (scard[tp] & 0x8) == 0 or
            (scard[tp] & 0x10) == 0) and
            scard.IsCanSummonAkariToken(tp) and
            Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
    end
    Duel.SetOperationInfo(0, CATEGORY_TOKEN, nil, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, 0)
    scard.summon_check = false
end
function scard.tkop(e, tp, eg, ep, ev, re, r, rp)
    scard.summon_check = true
    local c = e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp, LOCATION_MZONE) < 1 or not scard.IsCanSummonAkariToken(tp) then
        return
    end
    local token = Duel.CreateToken(tp, id + 1)
    local flag = 0
    Duel.SpecialSummonStep(token, 0, tp, tp, false, false, POS_FACEUP)
    if (scard[tp] & 0x1) == 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
        --atk
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1500)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        token:RegisterEffect(e1)
        local e2 = e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        token:RegisterEffect(e2)
        flag = flag | 0x1
        token:RegisterFlagEffect(0, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(id, 0))
    end
    if (scard[tp] & 0x2) == 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
        --indes
        local e3 = Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e3:SetRange(LOCATION_MZONE)
        e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e3:SetValue(1)
        e3:SetReset(RESET_EVENT + RESETS_STANDARD)
        token:RegisterEffect(e3)
        flag = flag | 0x2
        token:RegisterFlagEffect(0, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(id, 1))
    end
    if (scard[tp] & 0x4) == 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
        --indes
        local e4 = Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e4:SetRange(LOCATION_MZONE)
        e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
        e4:SetValue(1)
        e4:SetReset(RESET_EVENT + RESETS_STANDARD)
        token:RegisterEffect(e4)
        flag = flag | 0x4
        token:RegisterFlagEffect(0, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(id, 2))
    end
    if (scard[tp] & 0x8) == 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
        --cannot be target
        local e5 = Effect.CreateEffect(c)
        e5:SetType(EFFECT_TYPE_SINGLE)
        e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
        e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e5:SetRange(LOCATION_MZONE)
        e5:SetValue(1)
        e5:SetReset(RESET_EVENT + RESETS_STANDARD)
        token:RegisterEffect(e5)
        local e6 = e5:Clone()
        e6:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
        c:RegisterEffect(e6)
        flag = flag | 0x8
        token:RegisterFlagEffect(0, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(id, 3))
    end
    if flag == 0 or (scard[tp] & 0x10) == 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 4)) then
        --cannot release
        local e7 = Effect.CreateEffect(c)
        e7:SetType(EFFECT_TYPE_SINGLE)
        e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e7:SetRange(LOCATION_MZONE)
        e7:SetCode(EFFECT_UNRELEASABLE_SUM)
        e7:SetValue(1)
        e7:SetReset(RESET_EVENT + RESETS_STANDARD)
        token:RegisterEffect(e7)
        local e8 = Effect.CreateEffect(c)
        e8:SetType(EFFECT_TYPE_FIELD)
        e8:SetCode(EFFECT_CANNOT_RELEASE)
        e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e8:SetRange(LOCATION_MZONE)
        e8:SetTargetRange(1, 1)
        e8:SetTarget(scard.relval)
        e8:SetValue(1)
        token:RegisterEffect(e8)
        flag = flag | 0x10
        token:RegisterFlagEffect(0, RESET_EVENT + RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT, 1, 0, aux.Stringid(id, 4))
    end
    --reset effects
    local e9 = Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_CONTINUOUS + EFFECT_TYPE_SINGLE)
    e9:SetCode(EVENT_LEAVE_FIELD)
    e9:SetOperation(scard.resetop)
    e9:SetLabel(flag)
    token:RegisterEffect(e9)
    scard[tp] = scard[tp] | flag
    Duel.SpecialSummonComplete()
    scard.summon_check = false
end
function scard.relval(e, c)
    return c == e:GetHandler() and not scard.release_check
end
function scard.resetop(e, tp, eg, ep, ev, re, r, rp)
    local p = e:GetHandler():GetPreviousControler()
    scard[p] = scard[p] - e:GetLabel()
end
function scard.splimit(e, c)
    return not scard.summon_check
end
function scard.relfilter(c)
    return c:IsCode(id + 1) and c:IsReleasableByEffect()
end
function scard.reltg(e, tp, eg, ep, ev, re, r, rp, chk)
    scard.release_check = true
    if chk == 0 then
        return not e:GetHandler():IsLocation(LOCATION_DECK) and not (c:IsLocation(LOCATION_REMOVED) and c:IsFacedown())
    end
    local g = Duel.GetMatchingGroup(scard.relfilter, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
    Duel.SetOperationInfo(0, CATEGORY_RELEASE, g, #g, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_RECOVER, nil, 0, tp, 0)
    scard.release_check = false
end
function scard.relop(e, tp, eg, ep, ev, re, r, rp)
    scard.release_check = true
    local g = Duel.GetMatchingGroup(scard.relfilter, tp, LOCATION_MZONE, LOCATION_MZONE, nil)
    Duel.Release(g, REASON_EFFECT)
    local og = Duel.GetOperatedGroup()
    if #og > 0 then
        atk = og:GetSum(Card.GetPreviousAttackOnField)
        Duel.Recover(tp, atk, REASON_EFFECT)
        Duel.Recover(1 - tp, atk, REASON_EFFECT)
    end
    scard.release_check = false
end