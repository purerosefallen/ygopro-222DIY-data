--魔创龙 库拉姬
function c23305009.initial_effect(c)
	--xyz summo
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),8,2)
	c:EnableReviveLimit()
     --actlimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetOperation(c23305009.chainop)
    c:RegisterEffect(e1)
     --actlimit
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(1110112,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_REMOVE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,1110117)
    e3:SetTarget(c1110112.tg2)
    e3:SetOperation(c1110112.op2)
    c:RegisterEffect(e3)
end
function c23305009.chainop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_DRAGON) then
        Duel.SetChainLimit(c23305009.chainlm)
    end
end
function c23305009.chainlm(e,rp,tp)
    return tp==rp
end
function c1110112.filter2(c)
    return c:IsAbleToHand()
end
function c1110112.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(c1110112.filter2,tp,LOCATION_REMOVED,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
--
function c1110112.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c1110112.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
end