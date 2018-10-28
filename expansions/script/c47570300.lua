--提亚马特·马格纳
local m=47570300
local cm=_G["c"..m]
function c47570300.initial_effect(c)
    --xyz summon
    c:EnableReviveLimit()
    aux.AddXyzProcedureLevelFree(c,c47570300.mfilter,c47570300.xyzcheck,3,3)   
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47570300.psplimit)
    c:RegisterEffect(e1)  
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DISABLE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c47570300.discost)
    e2:SetTarget(c47570300.distg)
    e2:SetOperation(c47570300.disop)
    c:RegisterEffect(e2) 
    --destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c47570300.reptg)
    c:RegisterEffect(e3)
    --indes
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e4:SetRange(LOCATION_PZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetValue(c47570300.indval)
    c:RegisterEffect(e4)
    local e5=e4:Clone()
    e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e5:SetValue(1)
    c:RegisterEffect(e5)
end
function c47570300.indval(e,re,r,rp)
    return rp==1-e:GetHandlerPlayer()
end
function c47570300.mfilter(c,xyzc)
    return c:IsXyzType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c47570300.xyzcheck(g)
    return g:GetClassCount(Card.GetLevel)==1
end
function c47570300.pefilter(c)
    return c:IsRace(RACE_WYRM) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_WIND)
end
function c47570300.psplimit(e,c,tp,sumtp,sumpos)
    return not c47570300.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47570300.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47570300.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c47570300.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        tc=g:GetNext()
    end
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_CHAIN_SOLVING)
    e3:SetCondition(c47570300.discon2)
    e3:SetOperation(c47570300.disop2)
    e3:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e3,tp) 
end
c47570300.list={
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
function c47570300.nfilter(c)
    return c:IsLocation(LOCATION_MZONE)
end
function c47570300.discon2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c47570300.nfilter(re:GetHandler()) then return true end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if g and g:IsExists(c47570300.nfilter,1,nil) then return true end
    local res,ceg,cep,cev,re,r,rp=Duel.CheckEvent(re:GetCode())
    if res and ceg and ceg:IsExists(c47570300.nfilter,1,nil) then return true end
    for i,ctg in pairs(c47570300.list) do
        local ex,tg,ct,p,v=Duel.GetOperationInfo(ev,ctg)
        if tg then
            if tg:IsExists(c47570300.nfilter,1,c) then return true end
        elseif v and v>0 and Duel.IsExistingMatchingCard(c47570300.nfilter,tp,v,0,1,nil) then
            return true
        end
    end
    return false
end
function c47570300.disop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.NegateEffect(ev)
end
function c47570300.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) and e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT) then
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetValue(-1500)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e4)
       tc=g:GetNext()
    end
        return true
    else return false end
end