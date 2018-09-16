--Lacia the Aeonbreaker's Shield
function c32904925.initial_effect(c)
    --set
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32904925,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,32904925)
    e1:SetTarget(c32904925.settg)
    e1:SetOperation(c32904925.setop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
    --to hand
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(32904925,1))
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCountLimit(1,33904925)
    e4:SetCondition(c32904925.regcon)
    e4:SetTarget(c32904925.regtg)
    e4:SetOperation(c32904925.regop)
    c:RegisterEffect(e4)
end
function c32904925.setfilter(c)
    return c:IsSetCard(0xaa12) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c32904925.settg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32904925.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c32904925.setop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
    local g=Duel.SelectMatchingCard(tp,c32904925.setfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SSet(tp,g:GetFirst())
        Duel.ConfirmCards(1-tp,g)
    end
end
function c32904925.regcon(e,tp,eg,ep,ev,re,r,rp)
    return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c32904925.thfilter(c)
    return c:IsSetCard(0xaa12) and c:IsType(TYPE_MONSTER)
end
function c32904925.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32904925.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c32904925.regop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetCondition(c32904925.thcon)
    e1:SetOperation(c32904925.thop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c32904925.thfilter2(c)
    return c32904925.thfilter(c) and c:IsAbleToHand()
end
function c32904925.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c32904925.thfilter2,tp,LOCATION_DECK,0,1,nil)
end
function c32904925.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,32904925)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c32904925.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end