--堕天的星晶兽 奥利维尔
function c47510041.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510041.psplimit)
    c:RegisterEffect(e1)  
    --to extra
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOEXTRA)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510041)
    e2:SetCondition(c47510041.pencon)
    e2:SetTarget(c47510041.tetg)
    e2:SetOperation(c47510041.teop)
    c:RegisterEffect(e2) 
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47510042)
    e3:SetTarget(c47510041.drtg)
    e3:SetOperation(c47510041.drop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --sunmoneffect
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetCountLimit(1,47510000)
    e5:SetCost(c47510041.cost)
    e5:SetTarget(c47510041.sstg)
    e5:SetOperation(c47510041.ssop)
    c:RegisterEffect(e5)
    c47510041.ss_effect=e5
    --trapimm
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetValue(c47510041.efilter)
    c:RegisterEffect(e6)
    --trapimm
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e7:SetRange(LOCATION_MZONE)
    e7:SetValue(c47510041.efilter)
    c:RegisterEffect(e7)
end
function c47510041.pefilter(c)
    return c:IsRace(RACE_FAIRY) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c47510041.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510041.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510041.cfilter(c)
    return c:IsSetCard(0x5de) or c:IsSetCard(0x5da) 
end
function c47510041.pencon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47510041.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c47510041.tefilter(c)
    return c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x5de) or c:IsSetCard(0x5da)) and not c:IsForbidden()
end
function c47510041.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510041.tefilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c47510041.teop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47510041,0))
    local g=Duel.SelectMatchingCard(tp,c47510041.tefilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoExtraP(g,tp,REASON_EFFECT)
    end
end
function c47510041.filter(c,e)
    return (c:IsSetCard(0x5de) or c:IsSetCard(0x5da)) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function c47510041.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c47510041.filter(chkc,e) end
    local g=Duel.GetMatchingGroup(c47510041.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
    if chk==0 then return g:GetClassCount(Card.GetCode)>=5 and Duel.IsPlayerCanDraw(tp,2) end
    local sg=Group.CreateGroup()
    for i=1,5 do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local tc=g:Select(tp,1,1,nil):GetFirst()
        if tc then
            sg:AddCard(tc)
            g:Remove(Card.IsCode,nil,tc:GetCode())
        end
    end
    Duel.SetTargetCard(sg)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c47510041.drop(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
    Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
    local g=Duel.GetOperatedGroup()
    if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct>0 then
        Duel.BreakEffect()
        Duel.Draw(tp,2,REASON_EFFECT)
    end
end
function c47510041.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510041.ssfilter(c)
    return c:IsFacedown()
end
function c47510041.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(c47510041.ssfilter,tp,0,LOCATION_SZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetChainLimit(c47510041.chainlimit)
end
function c47510041.chainlimit(e,rp,tp)
    return not (e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsType(TYPE_TRAP))
end
function c47510041.ssop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47510041.ssfilter,tp,0,LOCATION_SZONE,nil)
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c47510041.efilter(e,re)
    return re:IsActiveType(TYPE_TRAP)
end