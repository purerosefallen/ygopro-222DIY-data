--水之使徒 欧罗巴
local m=47510266
local cm=_G["c"..m]
function c47510266.initial_effect(c)
    aux.EnablePendulumAttribute(c)
    c:EnableReviveLimit()  
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA+LOCATION_HAND)
    e0:SetValue(SUMMON_TYPE_RITUAL)
    e0:SetCountLimit(1,47510266)
    e0:SetCondition(c47510266.spcon)
    e0:SetOperation(c47510266.spop)
    c:RegisterEffect(e0)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510266.psplimit)
    c:RegisterEffect(e1) 
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,47510267)
    e2:SetTarget(c47510266.sptg1)
    e2:SetOperation(c47510266.spop1)
    c:RegisterEffect(e2)   
    --atk change
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47510266,1))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetCountLimit(1,47510268)
    e3:SetCondition(c47510266.atkcon)
    e3:SetTarget(c47510266.atktg)
    e3:SetOperation(c47510266.atkop)
    c:RegisterEffect(e3)  
end
function c47510266.pefilter(c)
    return c:IsRace(RACE_FAIRY) or c:IsAttribute(ATTRIBUTE_WATER)
end
function c47510266.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510266.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510266.rfilter(c,tp)
    return c:IsRace(RACE_FAIRY) and c:IsLevelAbove(7) and (c:IsControler(tp) or c:IsFaceup())
end
function c47510266.mzfilter(c,tp)
    return c:IsControler(tp) and c:GetSequence()<5
end
function c47510266.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local rg=Duel.GetReleaseGroup(tp):Filter(c47510266.rfilter,nil,tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct=-ft+1
    return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c47510266.mzfilter,ct,nil,tp))
end
function c47510266.spop(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c47510266.rfilter,2,e:GetHandler()) end
    local g=Duel.SelectReleaseGroup(tp,c47510266.rfilter,2,2,e:GetHandler())
    Duel.Release(g,REASON_COST+REASON_MATERIAL+REASON_RITUAL)
end
function c47510266.spfilter(c,e,tp)
    return c:IsRace(RACE_FAIRY) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47510266.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c47510266.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c47510266.spop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47510266.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc=g:GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510266.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47510266.splimit(e,c)
    return not c:IsRace(RACE_FAIRY)
end
function c47510266.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    return tc and tc:IsFaceup() and tc:GetAttack()>0
end
function c47510266.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return true end
    e:GetHandler():GetBattleTarget():CreateEffectRelation(e)
end
function c47510266.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=c:GetBattleTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local atk=tc:GetAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(2)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_UPDATE_ATTACK)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e2:SetValue(math.ceil(atk/2))
        c:RegisterEffect(e2)
    end
end
function c47510266.thfilter(c)
    return c:IsFaceup() and c:GetAttack()>0 and c:IsRace(RACE_FAIRY)
end
function c47510266.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c47510266.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,c47510266.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c47510266.recop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 and Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end