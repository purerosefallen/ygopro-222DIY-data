--宇智波斑
function c5013300.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2) 
    --effect gain
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c5013300.regcon)
    e1:SetOperation(c5013300.regop)
    c:RegisterEffect(e1)   
end
function c5013300.regcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c5013300.regop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetMaterialCount()>=2 then
       local e1=Effect.CreateEffect(c)
       e1:SetType(EFFECT_TYPE_SINGLE)
       e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
       e1:SetRange(LOCATION_MZONE)
       e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
       e1:SetValue(1)
       e1:SetReset(RESET_EVENT+0x1fe0000)
       c:RegisterEffect(e1)
       local e2=e1:Clone()
       e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
       c:RegisterEffect(e2)
       c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(5013300,0))
    end
    if c:GetMaterialCount()>=3 then
       local e3=Effect.CreateEffect(c)
       e3:SetType(EFFECT_TYPE_SINGLE)
       e3:SetCode(EFFECT_IMMUNE_EFFECT)
       e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
       e3:SetRange(LOCATION_MZONE)
       e3:SetReset(RESET_EVENT+0x1fe0000)
       e3:SetValue(c5013300.efilter)
       c:RegisterEffect(e3)
       c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(5013300,1))
    end
    if c:GetMaterialCount()>=4 then
       local e4=Effect.CreateEffect(c)
       e4:SetDescription(aux.Stringid(5013300,5))
       e4:SetCategory(CATEGORY_DESTROY)
       e4:SetType(EFFECT_TYPE_QUICK_O)
       e4:SetRange(LOCATION_MZONE)
       e4:SetCode(EVENT_FREE_CHAIN)
       e4:SetCountLimit(1)
       e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)   
       e4:SetReset(RESET_EVENT+0x1fe0000)
       e4:SetHintTiming(TIMING_SPSUMMON,0x1e0)
       e4:SetTarget(c5013300.destg)
       e4:SetOperation(c5013300.desop)
       c:RegisterEffect(e4)
       c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(5013300,2))
    end
    if c:GetMaterialCount()>=5 then
       local e5=Effect.CreateEffect(c)
       e5:SetType(EFFECT_TYPE_SINGLE)
       e5:SetCode(EFFECT_IMMUNE_EFFECT)
       e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
       e5:SetRange(LOCATION_MZONE)
       e5:SetReset(RESET_EVENT+0x1fe0000)
       e5:SetValue(c5013300.efilter2)
       c:RegisterEffect(e5)
       c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(5013300,3))
    end
    if c:GetMaterialCount()>=6 then
       local e6=Effect.CreateEffect(c)
       e6:SetType(EFFECT_TYPE_FIELD)
       e6:SetRange(LOCATION_MZONE)
       e6:SetCode(EFFECT_CANNOT_ACTIVATE)
       e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
       e6:SetTargetRange(0,1)
       e6:SetValue(c5013300.aclimit)
       c:RegisterEffect(e6)
       c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(5013300,4))
    end
end
function c5013300.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c5013300.efilter2(e,te)
    return te:IsActiveType(TYPE_MONSTER) and te:GetHandler()~=e:GetHandler()
end
function c5013300.efilter(e,te)
    return te:IsActiveType(TYPE_SPELL)
end
function c5013300.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c5013300.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.Destroy(g,REASON_EFFECT)
end