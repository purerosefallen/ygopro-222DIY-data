--尤伊西丝-星薙之型
local m=47510222
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=m+2
function c47510222.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --synchro summon
    aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsType,TYPE_PENDULUM),1)
    c:EnableReviveLimit() 
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e0:SetRange(LOCATION_PZONE)
    e0:SetCode(EVENT_LEAVE_FIELD)
    e0:SetCondition(c47510222.spcon)
    e0:SetTarget(c47510222.sptg)
    e0:SetOperation(c47510222.spop)
    c:RegisterEffect(e0)
    --Change
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510222,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c47510222.chcon)
    e1:SetTarget(c47510222.changetg)
    e1:SetOperation(c47510222.changeop)
    c:RegisterEffect(e1)  
    --Cannot be effect
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c47510222.efftg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetValue(c47510222.atlimit)
    c:RegisterEffect(e4) 
    --damege
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47510222,2))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_DAMAGE)
    e3:SetCountLimit(2)
    e3:SetCondition(c47510222.damcon)
    e3:SetOperation(c47510222.damop)
    c:RegisterEffect(e3)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetTarget(c47510222.inmtg)
    e5:SetValue(c47510222.efilter2)
    c:RegisterEffect(e5) 
end
function c47510222.cfilter(c,tp)
    return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
        and (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function c47510222.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47510222.cfilter,1,nil,tp)
end
function c47510222.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47510222.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c47510222.inmtg(e,c)
    local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
    return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c47510222.efilter2(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c47510222.atlimit(e,c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c~=e:GetHandler()
end
function c47510222.efftg(e,c)
    return c~=e:GetHandler()
end
function c47510222.chcon(e)
    return e:GetHandler():GetFlagEffect(47510223)==0
end
function c47510222.changetg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c.dfc_back_side and c.dfc_front_side==c:GetOriginalCode() end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c47510222.changeop(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or c:IsImmuneToEffect(e) then return end
    local tcode=c.dfc_back_side
    c:SetEntityCode(tcode,true)
    if c:ReplaceEffect(tcode,0,0) then   
    c:RegisterFlagEffect(47510223,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
    end
end
function c47510222.damcon(e,tp,eg,ep,ev,re,r,rp)
    if ep~=tp then return false end
    if bit.band(r,REASON_EFFECT)~=0 then return rp==1-tp end
    return e:GetHandler():IsRelateToBattle()
end
function c47510222.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,1000,REASON_EFFECT)
end