local m=12007021
local cm=_G["c"..m]
--白金兔姬 圣诞节
function cm.initial_effect(c)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,5))
    e3:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BECOME_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(cm.discon)
    e3:SetTarget(cm.distg)
    e3:SetOperation(cm.disop)
    c:RegisterEffect(e3)
    --todeck
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_TODECK)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCondition(cm.remcon)
    e4:SetTarget(cm.remtg)
    e4:SetOperation(cm.remop)
    c:RegisterEffect(e4)

    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_UPDATE_ATTACK)
    e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e11:SetRange(LOCATION_MZONE)
    e11:SetValue(cm.atkval)
    local e12=Effect.CreateEffect(c)
    e12:SetType(EFFECT_TYPE_SINGLE)
    e12:SetCode(EFFECT_EXTRA_ATTACK)
    e12:SetRange(LOCATION_MZONE)
    e12:SetValue(1)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e1:SetRange(LOCATION_SZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(cm.eftg)
    e1:SetLabelObject(e11)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetLabelObject(e12)
    c:RegisterEffect(e2)
end
function cm.atkval(e,c)
    local m=Duel.GetLP(Duel.GetTurnPlayer())
    local n=Duel.GetLP(1-Duel.GetTurnPlayer())
    local wt=math.abs(m-n)
    return math.min(wt,1500)
end
function cm.tgfilter(c,tp)
    return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsSetCard(0xfb2)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(cm.tgfilter,1,nil,tp)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,re:GetHandler(),1,0,0)
    if eg:GetFirst():IsDestructable() and eg:GetFirst():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg:GetFirst(),1,0,0)
    end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)    
    if eg:GetFirst():IsRelateToEffect(re) then
        Duel.NegateEffect(ev)
        Duel.Destroy(eg:GetFirst(),REASON_EFFECT)
    end
end
function cm.remcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and re:GetHandler():IsSetCard(0xfb2)
end
function cm.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Destroy(g,REASON_EFFECT)
    end
end
function cm.eftg(e,c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfb2)
end