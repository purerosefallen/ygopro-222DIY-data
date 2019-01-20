--光辉星曜·圣芒
function c66915005.initial_effect(c)
    c:SetUniqueOnField(1,0,66915005)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
    e2:SetValue(LINK_MARKER_TOP)
    c:RegisterEffect(e2)    
    --disable spsummon
    local e22=Effect.CreateEffect(c)
    e22:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
    e22:SetType(EFFECT_TYPE_QUICK_O)
    e22:SetRange(LOCATION_MZONE)
    e22:SetCode(EVENT_SPSUMMON)
    e22:SetCondition(c66915005.condition)
    e22:SetCost(c66915005.cost)
    e22:SetTarget(c66915005.target)
    e22:SetOperation(c66915005.operation)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c66915005.eftg)
    e5:SetLabelObject(e22)
    --spsummon limit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c66915005.sumlimit)
    c:RegisterEffect(e2)
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_FIELD)
    e11:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e11:SetRange(LOCATION_SZONE)
    e11:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e11:SetTarget(c66915005.tgtg)
    e11:SetValue(1)
    c:RegisterEffect(e11)    
end
function c66915005.sumlimit(e,c,sump,sumtype,sumpos,targetp)
    return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x1374)
end
function c66915005.eftg(e,c)
    local lg=e:GetHandler():GetLinkedGroup()
    return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x1374) and lg:IsContains(c)
end
function c66915005.tgtg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsType(TYPE_EFFECT) and c:IsSetCard(0x1374)
end
function c66915005.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=ep and eg:GetCount()==1 and Duel.GetCurrentChain()==0
end
function c66915005.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c66915005.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c66915005.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    Duel.NegateSummon(eg)
    Duel.Destroy(eg,REASON_EFFECT)
end