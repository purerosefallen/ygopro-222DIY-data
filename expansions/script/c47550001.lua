--真红的穿光 泽塔
local m=47550001
local cm=_G["c"..m]
function c47550001.initial_effect(c)
    aux.EnablePendulumAttribute(c,false)
    --synchro summon
    aux.AddSynchroProcedure(c,c47550001.synfilter1,aux.NonTuner(nil),1)
    c:EnableReviveLimit()  
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47550001.psplimit)
    c:RegisterEffect(e1)  
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_BE_BATTLE_TARGET)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCondition(c47550001.fcon1)
    e2:SetTarget(c47550001.ftg1)
    e2:SetOperation(c47550001.fop1)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BECOME_TARGET)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCondition(c47550001.fcon2)
    e3:SetTarget(c47550001.ftg2)
    e3:SetOperation(c47550001.fop2)
    c:RegisterEffect(e3)    
    --counter
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47550001,0))
    e4:SetCategory(CATEGORY_COUNTER)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(c47550001.cttg)
    e4:SetOperation(c47550001.ctop)
    c:RegisterEffect(e4)
    --atk
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_SET_ATTACK_FINAL)
    e5:SetCondition(c47550001.atkcon)
    e5:SetValue(5000)
    c:RegisterEffect(e5)
    --break
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(0,LOCATION_MZONE)
    e6:SetTarget(c47550001.distg)
    e6:SetOperation(c47550001.disop)
    c:RegisterEffect(e6)
end
function c47550001.synfilter(c)
    return c:IsType(TYPE_TUNER) and c:IsRace(RACE_WARRIOR)
end
function c47550001.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c47550001.psplimit(e,c,tp,sumtp,sumpos)
    return not c47550001.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47550001.fcon1(e) 
    local at=Duel.GetAttackTarget()
    return at:IsControler(tp) and at:IsFaceup() and at:IsType(TYPE_PENDULUM) and e:GetHandler():GetFlagEffect(47550001)<1
end
function c47550001.ftg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttackTarget()
    if chkc then return chkc==tg end
    if chk==0 then return Duel.GetAttacker():IsOnField() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
end
function c47550001.fop1(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    if Duel.NegateAttack() and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
        local tc=Duel.GetFirstTarget()
        if tc:IsRelateToEffect(e) then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            c:RegisterFlagEffect(47550001,RESET_EVENT+RESETS_STANDARD,0,1)
        end
    end
end
function c47550001.ffilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER)
end
function c47550001.fcon2(e) 
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c47550001.ffilter,1,nil,tp) and e:GetHandler():GetFlagEffect(47550001)<1
end
function c47550001.ftg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local sg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c47550001.ffilter,nil,tp)
    Duel.SetTargetCard(sg)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c47550001.fop2(e,tp,eg,ep,ev,re,r,rp,chk)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local c=e:GetHandler()
    if Duel.NegateEffect(ev) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 then
        local tc=Duel.GetFirstTarget()
        if tc:IsRelateToEffect(e) then
            Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
            c:RegisterFlagEffect(47550001,RESET_EVENT+RESETS_STANDARD,0,1)
        end
    end
end
function c47550001.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c47550001.ctop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        tc:AddCounter(0x15d0,1)
        tc=g:GetNext()
    end
end
function c47550001.atkcon(e)
    local ph=Duel.GetCurrentPhase()
    local bc=e:GetHandler():GetBattleTarget()
    return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and bc:GetCounter(0x15d0)>0
end
function c47550001.distg(e,c)
    local c=e:GetHandler()
    return c:GetCounter(0x15d0)>0
end
function c47550001.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsDisabled() and c:GetCounter(0x15d0)>0 then
       SendtoGrave(c,REASON_RULE)
    end
end