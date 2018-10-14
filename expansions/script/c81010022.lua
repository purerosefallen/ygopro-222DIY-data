--高森蓝子
function c81010022.initial_effect(c)
    --extra summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(81010022,1))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e1:SetTarget(c81010022.extg)
    c:RegisterEffect(e1)
    --search
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(81010022,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetCountLimit(1,81010022)
    e2:SetCondition(c81010022.thcon)
    e2:SetTarget(c81010022.thtg)
    e2:SetOperation(c81010022.thop)
    c:RegisterEffect(e2)
end
function c81010022.extg(e,c)
    return c:IsAttack(800) and c:IsDefense(1000)
end
function c81010022.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
        and re:GetHandler():IsRace(RACE_SEASERPENT)
end
function c81010022.thfilter(c)
    return not c:IsCode(81010022) and c:IsRace(RACE_SEASERPENT) and c:IsLevel(3) and c:IsAbleToHand()
end
function c81010022.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81010022.thop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c81010022.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
