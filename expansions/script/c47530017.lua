--量产型牛高达
local m=47530017
local cm=_G["c"..m]
function c47530017.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false) 
    c:EnableReviveLimit()
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),10,2)  
    --splimit
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e0:SetRange(LOCATION_PZONE)
    e0:SetTargetRange(1,0)
    e0:SetTarget(c47530017.splimit)
    c:RegisterEffect(e0) 
    --break
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47530017,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_BATTLE_DESTROYING)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c47530017.bkcon)
    e1:SetOperation(c47530017.bkop)
    c:RegisterEffect(e1)
    --tograve
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c47530017.olcon)
    e2:SetOperation(c47530017.olop)
    c:RegisterEffect(e2) 
    --megacanon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47530017,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e3:SetCost(c47530017.descost)
    e3:SetTarget(c47530017.destg)
    e3:SetOperation(c47530017.desop)
    c:RegisterEffect(e3)
end
function c47530017.mfilter(c,xyzc)
    return (c:IsLevel(10) and c:IsRace(RACE_MACHINE)) or (c:IsType(TYPE_LINK) and c:IsLinkAbove(2) and c:IsRace(RACE_MACHINE))
end
function c47530017.splimit(e,c)
    return not c:IsRace(RACE_MACHINE)
end
function c47530017.bkcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=eg:GetFirst()
    return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
        and rc:IsFaceup() and rc:IsControler(tp)
end
function c47530017.bkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst():GetAttacker()
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local cg=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
    if cg:GetCount()>0 then
        Duel.SendtoGrave(cg,REASON_EFFECT)
    end
end
function c47530017.olcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47530017.olfilter(c,tp)
    return c:IsType(TYPE_MONSTER)
end
function c47530017.olop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectMatchingCard(tp,c47530017.olfilter,tp,LOCATION_MZONE,0,1,1,nil)
    if g:GetCount()>0 and c:IsRelateToEffect(e) then
        local og=g:GetOverlayGroup()
        if og:GetCount()>0 then
            Duel.SendtoGrave(og,REASON_RULE)
        end
        Duel.Overlay(c,Group.FromCards(g))
    end
end
function c47530017.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47530017.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47530017.desop(e,tp,eg,ep,ev,re,r,rp)
    local dg=Group.CreateGroup()
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local atk=c:GetAttack()
    while tc do
        local preatk=tc:GetAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_DEFENSE)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
        if predef~=0 and tc:IsDefense(0) or tc:IsType(TYPE_LINK) then dg:AddCard(tc) end
        tc=g:GetNext()
    end
    Duel.Remove(dg,POS_FACEDOWN,REASON_RULE)
end