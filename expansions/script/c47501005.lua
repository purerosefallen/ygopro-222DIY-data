--混沌领主 姬塔
function c47501005.initial_effect(c)
    --material
    c:EnableReviveLimit() 
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsCode,47500000),8,2)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --splimit
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_PZONE)
    e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e0:SetTargetRange(1,0)
    e0:SetTarget(c47501005.psplimit)
    c:RegisterEffect(e0)     
    --summon success
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c47501005.sumcon)
    e1:SetOperation(c47501005.sumsuc)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_MATERIAL_CHECK)
    e2:SetValue(c47501005.valcheck)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetValue(c47501005.efilter)
    c:RegisterEffect(e3)
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_ATKCHANGE)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1)
    e5:SetCost(c47501005.cost)
    e5:SetTarget(c47501005.deftg)
    e5:SetOperation(c47501005.defop)
    c:RegisterEffect(e5)
    --disable
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_DISABLE)
    e6:SetRange(LOCATION_PZONE)
    e6:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
    e6:SetTarget(c47501005.distg)
    c:RegisterEffect(e6)
    --disable effect
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_CHAIN_SOLVING)
    e7:SetRange(LOCATION_PZONE)
    e7:SetOperation(c47501005.disop)
    c:RegisterEffect(e7)
end
c47501005.pendulum_level=8
c47501005.card_code_list={47500000}
function c47501005.mfilter(c)
    return c:IsLevel(8)
end
function c47501005.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c47501005.psplimit(e,c,tp,sumtp,sumpos)
    return not c47501005.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47501005.mzfilter(c,xyzc)
    return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c47501005.xyzcheck(g)
    return g:IsExists(c47501005.mzfilter,1,nil)
end
function c47501005.disop(e,tp,eg,ep,ev,re,r,rp)
    local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
    if re:IsActiveType(TYPE_SPELL) and not re:IsActiveType(TYPE_PENDULUM) and bit.band(loc,LOCATION_SZONE)~=0 then
        Duel.NegateEffect(ev)
    end
end
function c47501005.distg(e,c)
    return not c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_SPELL)
end
function c47501005.valcheck(e,c)
    local g=c:GetMaterial()
    if g:IsExists(Card.GetOriginalCodeRule,1,nil,47500000) then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end
function c47501005.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function c47501005.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsSummonType(SUMMON_TYPE_XYZ) then return end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,1)
    e1:SetValue(c47501005.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetLabel(c:GetFieldID())
    Duel.RegisterEffect(e1,tp)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DISABLE)
    e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
    e2:SetTarget(c47501005.disable)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetLabel(c:GetFieldID())
    Duel.RegisterEffect(e2,tp)
end
function c47501005.aclimit(e,re,tp)
    return re:GetHandler():IsOnField() and re:GetHandler():GetFieldID()~=e:GetLabel()
end
function c47501005.disable(e,c)
    return c:GetFieldID()~=e:GetLabel() and (not c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT))
end
function c47501005.efilter(e,te)
    if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true
    else return te:IsActiveType(TYPE_LINK) and te:IsActivated() and te:GetOwner()~=e:GetOwner() end
end
function c47501005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47501005.deftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c47501005.deffilter(c)
    return c:IsDefenseBelow(1000) or c:IsType(TYPE_LINK)
end
function c47501005.defop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    while tc do
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetValue(-2500)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e4)
       tc=g:GetNext()
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47501005.deffilter,tp,0,LOCATION_MZONE,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end