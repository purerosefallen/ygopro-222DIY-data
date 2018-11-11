--调查兵团 姬塔
function c47500021.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2,3,c47500021.lcheck)   
    --to extra
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47500021,0))
    e1:SetCategory(CATEGORY_TOEXTRA)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,47500020)
    e1:SetCondition(c47500021.tecon)
    e1:SetTarget(c47500021.tetg)
    e1:SetOperation(c47500021.teop)
    c:RegisterEffect(e1) 
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47500021,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetCountLimit(1,47500021)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c47500021.thcon)
    e2:SetTarget(c47500021.thtg)
    e2:SetOperation(c47500021.thop)
    c:RegisterEffect(e2)
end
c47500021.card_code_list={47500000}
function c47500021.lfilter(c)
    return c:IsAttribute(ATTRIBUTE_WIND) and c:IsCode(47500000)
end
function c47500021.lcheck(g,lc)
    return g:IsExists(c47500021.lfilter,1,nil)
end
function c47500021.matfilter(c)
    return c:GetSummonLocation()==LOCATION_EXTRA
end
function c47500021.cfilter(c,tp)
    return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end
function c47500021.thcon(e,tp,eg,ep,ev,re,r,rp)
    local zone=e:GetHandler():GetLinkedZone()
    return eg:IsExists(c47500021.cfilter,1,nil,tp,zone)
end
function c47500021.thfilter(c)
    return (c:IsLocation(LOCATION_GRAVE) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
        and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c47500021.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47500021.thfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c47500021.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47500021.thfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47500021.tecon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47500021.tefilter(c)
    return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and aux.IsCodeListed(c,47500000) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c47500021.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47500021.tefilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c47500021.teop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47500021,3))
    local g=Duel.SelectMatchingCard(tp,c47500021.tefilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoExtraP(g,tp,REASON_EFFECT)
    end
end