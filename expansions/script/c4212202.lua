--是丢啦的魔法
function c4212202.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c4212202.cost)
    e1:SetTarget(c4212202.target)
    e1:SetOperation(c4212202.activate)
    c:RegisterEffect(e1)
    --immue
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4212202,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCost(aux.bfgcost)
    e2:SetCondition(c4212202.condition)
    e2:SetTarget(c4212202.immutg)
    e2:SetOperation(c4212202.activate2)
    c:RegisterEffect(e2)
end
function c4212202.filter(c)
    return c:IsType(TYPE_TUNER) and c:IsRace(RACE_SPELLCASTER) and c:GetLevel()==3 and c:IsDiscardable()
end
function c4212202.smfilter(c)
    return c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER) and c:IsSummonable(true,nil)
end
function c4212202.filter2(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER)
end
function c4212202.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4212202.filter,tp,LOCATION_HAND,0,2,nil) end
    Duel.DiscardHand(tp,c4212202.filter,2,2,REASON_COST+REASON_DISCARD)
end
function c4212202.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c4212202.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    local ct=Duel.Draw(p,d,REASON_EFFECT)
    if ct==0 then return end
    local dc=Duel.GetOperatedGroup()
    Duel.ConfirmCards(1-tp,dc)
    if dc:FilterCount(Card.IsRace,nil,RACE_SPELLCASTER)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(4212202,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
        local g=Duel.SelectMatchingCard(tp,c4212202.smfilter,tp,LOCATION_HAND,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.Summon(tp,g:GetFirst(),true,nil)
        end
    end
end
function c4212202.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp and not Duel.CheckEvent(EVENT_CHAINING)
end
function c4212202.immutg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c4212202.filter2(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c4212202.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
    local g=Duel.SelectTarget(tp,c4212202.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end
function c4212202.activate2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EFFECT_IMMUNE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e2:SetValue(c4212202.efilter)
        tc:RegisterEffect(e2)
    end
end
function c4212202.efilter(e,te)
    return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwner()~=e:GetOwner()
end
