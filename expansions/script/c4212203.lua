--摘星魔法使的赠礼
function c4212203.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --Draw
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(4212203,2))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c4212203.cost)
    e2:SetTarget(c4212203.target)
    e2:SetOperation(c4212203.operation)
    c:RegisterEffect(e2)
    --destroyed
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(4212313,3))
    e3:SetCategory(CATEGORY_RECOVER)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c4212203.condition)
    e3:SetTarget(c4212203.target2)
    e3:SetOperation(c4212203.operation2)
    c:RegisterEffect(e3)
end
function c4212203.filter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c4212203.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4212203.filter,tp,LOCATION_GRAVE,0,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c4212203.filter,tp,LOCATION_GRAVE,0,2,2,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c4212203.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c4212203.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c4212203.cfilter(c)
    return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER) and not c:IsPreviousLocation(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY) and c:IsReason(REASON_COST)
end
function c4212203.cfilter2(c,e,tp,zone)
    return c4212203.cfilter(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c4212203.condition(e,tp,eg,ep,ev,re,r,rp)
    return re and re:IsHasType(0x7f0) and re:GetHandler():IsRace(RACE_SPELLCASTER) and eg:IsExists(c4212203.cfilter,1,nil)
end
function c4212203.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(c4212203.cfilter,1,nil) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(500)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,400)
end
function c4212203.operation2(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    local zone=Duel.GetLinkedZone(tp)
    local sg = eg:Filter(c4212203.cfilter2,nil,e,tp,zone)
    if Duel.Recover(p,d,REASON_EFFECT)~=0 
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and sg:IsExists(c4212203.cfilter2,1,nil,e,tp,zone)then        
        if  Duel.SelectYesNo(tp,aux.Stringid(4212203,0)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
            local tc = sg:Select(tp,1,1,nil)
            Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
        end        
    end    
end