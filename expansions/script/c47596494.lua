--至高神的碎片 蛇夫座
function c47596494.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_LIGHT),2,3,c47596494.lcheck)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47596494,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,47596494)
    e1:SetCondition(c47596494.thcon)
    e1:SetTarget(c47596494.thtg)
    e1:SetOperation(c47596494.thop)
    c:RegisterEffect(e1)  
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47596494,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47596494)
    e2:SetCost(c47596494.inmcost)
    e2:SetTarget(c47596494.inmtg)
    e2:SetOperation(c47596494.inmop)
    c:RegisterEffect(e2)   
end
function c47596494.lcheck(g,lc)
    return g:IsExists(Card.IsAttackAbove,1,nil,2000)
end
function c47596494.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47596494.thfilter(c)
    return (c:IsCode(47598437) or c:IsCode(47597181) or c:IsCode(47592582)) and c:IsAbleToHand()
end
function c47596494.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47596494.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47596494.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47596494.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47596494.cfilter(c)
    return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:GetBaseAttack()>2000
end
function c47596494.inmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47596494.cfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47596494.cfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
    local tc=g:GetFirst()
    if tc:IsType(TYPE_XYZ) then e:SetLabel(1) end
    Duel.SendtoGrave(tc,REASON_COST)
end
function c47596494.inmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    if e:GetLabel()==1 then Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c47596494.inmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
        if c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetValue(c47596494.efilter)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
        c:RegisterEffect(e1)
        if e:GetLabel()==1 then
            local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
            local tc=g:GetFirst()
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
        end
    end    
end
function c47596494.efilter(e,re)
    return e:GetHandler()~=re:GetOwner()
end