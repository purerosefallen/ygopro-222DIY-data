--战神的星晶兽 奥丁
function c47510022.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510022.psplimit)
    c:RegisterEffect(e1) 
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510022)
    e2:SetCondition(c47510022.thcon)
    e2:SetTarget(c47510022.thtg)
    e2:SetOperation(c47510022.thop)
    c:RegisterEffect(e2) 
    --spsum
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47510023)
    e3:SetTarget(c47510022.tg)
    e3:SetOperation(c47510022.op)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --todefense
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCountLimit(1,47510000)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetCost(c47510022.cost)
    e5:SetTarget(c47510022.target)
    e5:SetOperation(c47510022.operation)
    c:RegisterEffect(e5)
    c47510022.ss_effect=e5
    --atk
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetTarget(c47510022.efilter)
    e6:SetValue(500)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e7)
end
function c47510022.pefilter(c)
    return c:IsRace(RACE_FAIRY) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47510022.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510022.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510022.efilter(e,c)
    return c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47510022.rfilter(c)
    return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x5de) or c:IsSetCard(0x5da)) and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsAbleToHand()
end
function c47510022.cfilter(c,att)
    return c:IsFaceup() and c:IsAttribute(att)
end
function c47510022.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47510022.cfilter,tp,LOCATION_MZONE,0,1,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c47510022.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingMatchingCard(c47510022.rfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47510022.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47510022.rfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47510022.gfilter(c)
    return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c47510022.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c47510022.gfilter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c47510022.gfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
        and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c47510022.gfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c47510022.op(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
        if g:GetCount()>0 then
            Duel.BreakEffect()
            Duel.SendtoGrave(g,nil,REASON_EFFECT)
        end
    end
end
function c47510022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510022.filter(c)
    return c:IsFaceup() or c:IsFacedown() and c:IsCanChangePosition()
end
function c47510022.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510022.filter,tp,0,LOCATION_MZONE,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
    local g=Duel.GetMatchingGroup(c47510022.filter,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c47510022.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47510022.filter,tp,0,LOCATION_MZONE,nil)
    Duel.ChangePosition(g,POS_FACEUP_DEFENSE,true)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_PIERCE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(1)
    Duel.RegisterEffect(e1,tp)
end