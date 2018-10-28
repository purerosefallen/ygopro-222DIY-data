--大地的使徒 布罗迪亚
local m=47510262
local cm=_G["c"..m]
function c47510262.initial_effect(c)
    aux.EnablePendulumAttribute(c,false)
    --synchro summon
    aux.AddSynchroProcedure(c,c47510262.synfilter1,aux.NonTuner(c47510262.synfilter2),1)
    c:EnableReviveLimit()   
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510262.psplimit)
    c:RegisterEffect(e1)  
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTarget(c47510262.reptg)
    e2:SetValue(c47510262.repval)
    e2:SetOperation(c47510262.repop)
    c:RegisterEffect(e2)
    --defense attack
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_DEFENSE_ATTACK)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --indes
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetTargetRange(LOCATION_MZONE,0)
    e7:SetValue(1)
    c:RegisterEffect(e7)
    --indes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetCondition(c47510262.inmcon)
    e4:SetValue(c47510262.inmop)
    c:RegisterEffect(e4) 
    --immune (FAQ in Card Target)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c47510262.target)
    e5:SetValue(c47510262.efilter)
    c:RegisterEffect(e5)
    --pendulum
    local e10=Effect.CreateEffect(c)
    e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e10:SetCode(EVENT_DESTROYED)
    e10:SetProperty(EFFECT_FLAG_DELAY)
    e10:SetCondition(c47510262.pencon)
    e10:SetTarget(c47510262.pentg)
    e10:SetOperation(c47510262.penop)
    c:RegisterEffect(e10)
end
c47510262.list={
        CATEGORY_DESTROY,
        CATEGORY_RELEASE,
        CATEGORY_REMOVE,
        CATEGORY_TOHAND,
        CATEGORY_TODECK,
        CATEGORY_TOGRAVE,
        CATEGORY_DECKDES,
        CATEGORY_HANDES,
        CATEGORY_POSITION,
        CATEGORY_CONTROL,
        CATEGORY_DISABLE,
        CATEGORY_DISABLE_SUMMON,
        CATEGORY_EQUIP,
        CATEGORY_DAMAGE,
        CATEGORY_RECOVER,
        CATEGORY_ATKCHANGE,
        CATEGORY_DEFCHANGE,
        CATEGORY_COUNTER,
        CATEGORY_LVCHANGE,
        CATEGORY_NEGATE,
}
function c47510262.target(e,c)
    local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
    return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c47510262.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c47510262.pefilter(c)
    return c:IsRace(RACE_FAIRY) or c:IsAttribute(ATTRIBUTE_EARTH)
end
function c47510262.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510262.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510262.synfilter(c)
    return c:IsType(TYPE_TUNER)
end
function c47510262.synfilter2(c)
    return c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_RITUAL)
end
function c47510262.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)) and not c:IsReason(REASON_REPLACE)
end
function c47510262.desfilter(c,e,tp)
    return c:IsFaceup() and c:IsControler(1-tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c47510262.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c47510262.repfilter,1,nil,tp)
        and Duel.IsExistingMatchingCard(c47510262.desfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end
    if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
        local g=Duel.SelectMatchingCard(tp,c47510262.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil,e,tp)
        e:SetLabelObject(g:GetFirst())
        g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
        return true
    end
    return false
end
function c47510262.repval(e,c)
    return c47510262.repfilter(c,e:GetHandlerPlayer())
end
function c47510262.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,1-tp,47510262)
    local tc=e:GetLabelObject()
    tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
    Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c47510262.nfilter(c)
    return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c47510262.inmcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) then return end
    if e:GetHandler():GetFlagEffect(47510262)~=0 then return end
    if not rp==1-tp then return end
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
    if c47510262.nfilter(re:GetHandler()) then return true end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if g and g:IsExists(c47510262.nfilter,1,nil) then return true end
    local res,ceg,cep,cev,re,r,rp=Duel.CheckEvent(re:GetCode())
    if res and ceg and ceg:IsExists(c47510262.nfilter,1,nil) then return true end
    for i,ctg in pairs(c47510262.list) do
        local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,ctg)
        if tg then
            if tg:IsExists(c47510262.nfilter,1,c) then return true end
        elseif v and v>0 and Duel.IsExistingMatchingCard(c47510262.nfilter,tp,v,0,1,nil) then
            return true
        end
    end
    return false
end
function c47510262.inmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(EFFECT_IMMUNE_EFFECT)
    e4:SetValue(c47510262.efilter)
    e4:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
    c:RegisterEffect(e4)
    c:RegisterFlagEffect(47510262,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c47510262.efilter(e,re)
    return re:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c47510262.pencon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c47510262.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c47510262.penop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end