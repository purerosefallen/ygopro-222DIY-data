--风伏龙-飓龙
function c50218520.initial_effect(c)
    --tohand
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,50218520)
    e1:SetCost(c50218520.cost)
    e1:SetTarget(c50218520.target)
    e1:SetOperation(c50218520.operation)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,50218521)
    e2:SetCondition(c50218520.spcon)
    e2:SetTarget(c50218520.sptg)
    e2:SetOperation(c50218520.spop)
    c:RegisterEffect(e2)
    --get effect
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_XMATERIAL)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCode(EFFECT_CANNOT_ACTIVATE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,1)
    e3:SetValue(c50218520.aclimit)
    e3:SetCondition(c50218520.actcon)
    c:RegisterEffect(e3)
end
function c50218520.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c50218520.filter(c)
    return c:IsSetCard(0xcb5) and not c:IsCode(50218520) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c50218520.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c50218520.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c50218520.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c50218520.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c50218520.spcon(e,tp,eg,ep,ev,re,r,rp)
    local loc=e:GetHandler():GetPreviousLocation()
    return loc==LOCATION_HAND
end
function c50218520.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c50218520.spop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP)
    end
end
function c50218520.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c50218520.actcon(e)
    return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end