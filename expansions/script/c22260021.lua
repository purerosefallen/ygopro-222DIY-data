--密语 拒绝
local m=22260021
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableUnsummonable()
    --SpecialSummonLimlt
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --down
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22260021,0))
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_HANDES)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_DRAW)
    e2:SetCountLimit(1,222600210)
    e2:SetCondition(c22260021.dwcon)
    e2:SetTarget(c22260021.dwtg)
    e2:SetOperation(c22260021.dwop)
    c:RegisterEffect(e2)
    --conter
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c22260021.dscon)
    e3:SetCost(c22260021.dscost)
    e3:SetTarget(c22260021.dstg)
    e3:SetOperation(c22260021.dsop)
    c:RegisterEffect(e3)
end
--
function c22260021.cfilter(c,tp)
    return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c22260021.dwcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c22260021.cfilter,1,nil,1-tp)
end
function c22260021.dwtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetCard(eg)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c22260021.filter(c,e,tp)
    return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c22260021.dwop(e,tp,eg,ep,ev,re,r,rp)
    local sg=eg:Filter(c22260021.filter,nil,e,1-tp)
    if sg:GetCount()==0 then
    elseif sg:GetCount()==1 then
        Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
    else
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
        local dg=sg:Select(1-tp,1,1,nil)
        Duel.SendtoGrave(dg,REASON_EFFECT+REASON_DISCARD)
    end
end
--
function c22260021.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end
function c22260021.dscon(e,tp,eg,ep,ev,re,r,rp)
    return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c22260021.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c22260021.dsop(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.NegateActivation(ev) then return end
    if re:GetHandler():IsRelateToEffect(re) then 
        Duel.Destroy(eg,REASON_EFFECT)
    end
end