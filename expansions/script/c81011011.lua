--樱井桃华
function c81011011.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FAIRY),2)
    --maintain
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c81011011.mtcon)
    e1:SetOperation(c81011011.mtop)
    c:RegisterEffect(e1)
    --tograve
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(81011011,0))
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_PAY_LPCOST)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,81011011)
    e2:SetCondition(c81011011.tgcon)
    e2:SetCost(c81011011.tgcost)
    e2:SetTarget(c81011011.tgtg)
    e2:SetOperation(c81011011.tgop)
    c:RegisterEffect(e2)
    --destroy replace
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DESTROY_REPLACE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTarget(c81011011.destg)
    e3:SetValue(1)
    c:RegisterEffect(e3)
end
function c81011011.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c81011011.mtop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.CheckLPCost(tp,1000) and Duel.SelectYesNo(tp,aux.Stringid(81011011,2)) then
        Duel.PayLPCost(tp,1000)
    else
        Duel.Destroy(e:GetHandler(),REASON_COST)
    end
end
function c81011011.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end
function c81011011.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(81011011)==0 end
    c:RegisterFlagEffect(81011011,RESET_CHAIN,0,1)
end
function c81011011.tgfilter(c,val)
    return c:IsRace(RACE_FAIRY) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c81011011.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c81011011.tgfilter,tp,LOCATION_DECK,0,1,nil,ev) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81011011.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c81011011.tgfilter,tp,LOCATION_DECK,0,1,1,nil,ev)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function c81011011.rfilter(c)
    return c:IsRace(RACE_FAIRY) and c:IsAbleToRemove()
end
function c81011011.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local dc=eg:GetFirst()
    if chk==0 then return eg:GetCount()==1 and dc~=e:GetHandler() and dc:IsFaceup() and dc:IsLocation(LOCATION_MZONE)
        and dc:IsRace(RACE_FAIRY) and Duel.IsExistingMatchingCard(c81011011.rfilter,tp,LOCATION_GRAVE,0,1,nil) end
    if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        local g=Duel.SelectMatchingCard(tp,c81011011.rfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
        return true
    else return false end
end
